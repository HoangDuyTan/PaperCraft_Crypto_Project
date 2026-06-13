package com.papercraft.controller.client;

import com.google.gson.JsonObject;
import com.papercraft.config.MomoConfig;
import com.papercraft.config.VNPAYConfig;
import com.papercraft.dao.*;
import com.papercraft.model.*;
import com.papercraft.service.OrderService;
import com.papercraft.utils.OrderCryptoUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.text.SimpleDateFormat;
import java.util.*;

@WebServlet("/checkout")
public class CheckoutServlet extends HttpServlet {

    private static final Logger logger = LoggerFactory.getLogger(CheckoutServlet.class);

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        HttpSession session = request.getSession();

        // Kiểm tra Login
        if (session.getAttribute("acc") == null) {
            logger.warn("GET /checkout request denied: Not logged into the system.");
            response.sendRedirect(request.getContextPath() + "/login?redirect=/checkout");
            return;
        }

        User user = (User) session.getAttribute("acc");
        if (user == null) {
            logger.warn("GET /checkout request denied: User object in session is null.");
            response.sendRedirect(request.getContextPath() + "/login?redirect=/checkout");
            return;
        }

        Cart cart = (Cart) session.getAttribute("cart");
        if (cart == null || cart.list().isEmpty()) {
            logger.warn("User ID '{}' accessed checkout but the cart is empty or not initialized.", user.getId());
            response.sendRedirect(request.getContextPath() + "/cart");
            return;
        }


        String selectedIdsRaw = request.getParameter("selectedIds");
        Set<Integer> selectedIds = parseSelectedIdSet(selectedIdsRaw);

        if (selectedIds.isEmpty()) {
            logger.warn("User ID '{}' accessed checkout but no products were selected (selectedIds is empty).", user.getId());
            response.sendRedirect(request.getContextPath() + "/cart");
            return;
        }

        logger.info("User ID '{}' started the Checkout process for product IDs: '{}'", user.getId(), selectedIdsRaw);

        AddressDAO addressDAO = new AddressDAO();
        Address userAddr = addressDAO.findDefaultAddress(user.getId());
        request.setAttribute("addr", userAddr);
        logger.debug("Loaded default address for User ID '{}': {}", user.getId(), userAddr != null ? userAddr.getId() : "Chưa có địa chỉ");

        UserVoucherDAO userVoucherDAO = new UserVoucherDAO();
        List<Voucher> vouchers = userVoucherDAO.getVouchersByUserId(user.getId());
        request.setAttribute("vouchers", vouchers);

        String voucherCode = request.getParameter("voucherCode");
        if (voucherCode != null && !voucherCode.trim().isEmpty()) {
            logger.info("User ID '{}' is saving/applying Voucher code directly from code: '{}'", user.getId(), voucherCode);
            Voucher voucher = new VoucherDAO().getVoucherByCode(voucherCode.trim());
            if (voucher == null) {
                logger.warn("Applying code failed: Voucher code '{}' does not exist.", voucherCode);
                request.setAttribute("saveVoucherError", "Mã voucher không tồn tại");
            } else if (!voucher.isAvailable()) {
                logger.warn("Applying code failed: Voucher ID '{}' ('{}') is currently unavailable.", voucher.getId(), voucherCode);
                request.setAttribute("saveVoucherError", "Voucher hiện không khả dụng");
            } else {
                boolean success = userVoucherDAO.addUserVoucher(user.getId(), voucher.getId());
                if (!success) {
                    logger.warn("Applying code failed: User ID '{}' already saved or used voucher ID '{}' previously.", user.getId(), voucher.getId());
                    request.setAttribute("saveVoucherError", "Bạn đã lưu voucher này rồi hoặc đã sử dụng");
                } else {
                    logger.info("User ID '{}' successfully saved and applied voucher ID '{}' ('{}') to the list.", user.getId(), voucher.getId(), voucherCode);
                    request.setAttribute("saveVoucherSuccess", "Áp dụng voucher thành công");
                    request.setAttribute("selectedVoucher", voucher);
                }
            }
        }


        List<OrderItem> items = new ArrayList<>();
        double subTotal = 0;
        ProductDAO productDAO = new ProductDAO();
        boolean hasInvalidStockItem = false;

        for (Product p : cart.list()) {

            //nếu sp khng được tick
            if (!selectedIds.contains(p.getId())) {
                continue;
            }
            Product freshProduct = productDAO.getProductById(p.getId());

            if (freshProduct == null || freshProduct.getStockQuantity() <= 0) {
                logger.warn("Stock check failed: Product ID {} does not exist or is out of stock.", p.getId());
                hasInvalidStockItem = true;
                continue;
            }

            if (p.getQuantity() > freshProduct.getStockQuantity()) {
                logger.warn("Stock check failed: Product ID {} quantity in cart ({}) exceeds actual stock quantity ({}).",
                        p.getId(), p.getQuantity(), freshProduct.getStockQuantity());
                hasInvalidStockItem = true;
                continue;
            }

            OrderItem item = new OrderItem();
            item.setProduct(p);
            item.setProductId(p.getId());
            item.setQuantity(p.getQuantity());

            BigDecimal price = BigDecimal.valueOf(p.getPrice());
            item.setPrice(price);

            BigDecimal total = price.multiply(BigDecimal.valueOf(p.getQuantity()));
            item.setTotal(total);

            items.add(item);
            subTotal += total.doubleValue();
        }
        if (hasInvalidStockItem) {
            logger.warn("Checkout process for User ID '{}' was cancelled and redirected to cart due to stock errors.", user.getId());
            session.setAttribute("error", "Một số sản phẩm đã hết hàng hoặc không đủ tồn kho. Vui lòng kiểm tra lại giỏ hàng.");
            response.sendRedirect(request.getContextPath() + "/cart");
            return;
        }

        //nếu selectedId gửi lên không khớp sp trong cart => không cho checkout(về cart )
        if (items.isEmpty()) {
            logger.warn("No valid products found matching the selection of User ID '{}'. Returning to cart.", user.getId());
            response.sendRedirect(request.getContextPath() + "/cart");
            return;
        }

        subTotal = Math.round(subTotal);
        double shippingFee = (subTotal > 5000000 || subTotal == 0) ? 0 : 0;
        double vat = Math.round(subTotal * 0.05);
        double grandTotal = Math.round(subTotal + vat + shippingFee);


        //tính voucher
        BigDecimal discountAmount = BigDecimal.ZERO;
        String voucherIdRaw = request.getParameter("voucherId");
        Voucher selectedVoucher = null;
        if (voucherIdRaw != null && !voucherIdRaw.isBlank()) {
            try {
                int voucherId = Integer.parseInt(voucherIdRaw);
                logger.debug("Processing discount calculation for Voucher ID: '{}'", voucherId);
                selectedVoucher = new VoucherDAO().getVoucherById(voucherId);
                if (selectedVoucher != null) {
                    String voucherError = selectedVoucher.validateString(BigDecimal.valueOf(grandTotal));

                    if (voucherError != null) {
                        logger.warn("Voucher ID '{}' is invalid for this order. Reason: '{}'", voucherId, voucherError);
                        request.setAttribute("errorVoucher", voucherError);

                    } else {
                        discountAmount = selectedVoucher.calculateDiscount(BigDecimal.valueOf(grandTotal));
                        grandTotal = selectedVoucher.applyDiscount(BigDecimal.valueOf(grandTotal)).toBigInteger().doubleValue();
                        logger.info("Successfully applied Voucher ID '{}' for User ID '{}'. Discount amount: {}", voucherId, user.getId(), discountAmount);
                        request.setAttribute("successVoucher", "Áp dụng voucher thành công");
                        request.setAttribute("selectedVoucher", selectedVoucher);
                    }
                }
            } catch (NumberFormatException e) {
                logger.error("Invalid format for submitted parameter 'voucherId': '{}'", voucherIdRaw);
                request.setAttribute("errorVoucher", "Voucher không hợp lệ");
            }
        }

        request.setAttribute("items", items);
        request.setAttribute("subTotal", subTotal);
        request.setAttribute("vat", vat);
        request.setAttribute("shippingFee", shippingFee);
        request.setAttribute("discountAmount", discountAmount);
        request.setAttribute("grandTotal", grandTotal);

        request.setAttribute("selectedIds", selectedIdsRaw);

        logger.debug("Forwarding flow to payment.jsp for User ID '{}'", user.getId());
        request.getRequestDispatcher("/WEB-INF/views/client/payment.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {

        request.setCharacterEncoding("UTF-8");
        //fix bug
//        System.out.println("===Test checkout sevlet running ====");
//        System.out.println("cryptoAction= " + request.getParameter("cryptoAction")); --monng muốn ra "prepare"
//        if ("prepare".equalsIgnoreCase(request.getParameter("cryptoAction"))) {
//            response.setContentType("application/json;charset=UTF-8");
//
//            JsonObject json = new JsonObject();
//            json.addProperty("success", true);
//            json.addProperty("hashValue", "abcdtestPopUpHashWhenCheckout");
//
//            response.getWriter().write(json.toString());
//            return;
//        }

        HttpSession session = request.getSession();

        User user = (User) session.getAttribute("acc");
        Cart cart = (Cart) session.getAttribute("cart");

        String selectedIdsRaw = request.getParameter("selectedIds");
        Set<Integer> selectedIds = parseSelectedIdSet(selectedIdsRaw);

        if (user == null || cart == null || cart.list().isEmpty()) {
            logger.warn("POST /checkout request denied: Invalid User or Cart information in session.");
            response.sendRedirect(request.getContextPath() + "/cart");
            return;
        }

        if (selectedIds.isEmpty()) {
            logger.warn("POST /checkout request denied: Selected product IDs list is empty.");
            response.sendRedirect(request.getContextPath() + "/cart");
            return;
        }
        logger.info("User ID '{}' submitted order confirmation request for products: '{}'", user.getId(), selectedIdsRaw);

        String cryptoAction = request.getParameter("cryptoAction");
        String submittedHash = request.getParameter("hashValue");
        String digitalSignature = request.getParameter("digitalSignature");
        boolean isPrepare = "prepare".equalsIgnoreCase(cryptoAction);

        if (cart.list().isEmpty()) {
            logger.warn("Giỏ hàng ảo xử lý thanh toán (selectedCart) rỗng đối với User ID '{}'.", user.getId());
            if (isPrepare) {
                writeJsonError(response, "Giỏ hàng trống hoặc phiên đăng nhập đã hết hạn.");
            } else {
                response.sendRedirect(request.getContextPath() + "/cart");
            }
            return;
        }

        if (selectedIds.isEmpty()) {
            if (isPrepare) {
                writeJsonError(response, "Bạn chưa chọn sản phẩm để thanh toán.");
            } else {
                response.sendRedirect(request.getContextPath() + "/cart");
            }
            return;
        }
        ProductDAO productDAO = new ProductDAO();
        Cart selectedCart = new Cart();

        for (Product p : cart.list()) {
            if (!selectedIds.contains(p.getId())) {
                continue;
            }

            Product freshProduct = productDAO.getProductById(p.getId());

            if (freshProduct == null || freshProduct.getStockQuantity() <= 0) {
                String message = "Một số sản phẩm đã hết hàng. Vui lòng kiểm tra lại giỏ hàng.";
                if (isPrepare) {
                    writeJsonError(response, message);
                } else {
                    session.setAttribute("error", message);
                    response.sendRedirect(request.getContextPath() + "/cart");
                }
                return;
            }

            if (p.getQuantity() > freshProduct.getStockQuantity()) {
                String message = "Số lượng sản phẩm trong giỏ đã vượt quá tồn kho hiện tại.";
                if (isPrepare) {
                    writeJsonError(response, message);
                } else {
                    session.setAttribute("error", message);
                    response.sendRedirect(request.getContextPath() + "/cart");
                }
                return;
            }

            freshProduct.setQuantity(p.getQuantity());
            selectedCart.put(freshProduct);
        }
        if (selectedCart.list().isEmpty()) {
            if (isPrepare) {
                writeJsonError(response, "Không tìm thấy sản phẩm hợp lệ để thanh toán.");
            } else {
                response.sendRedirect(request.getContextPath() + "/cart");
            }
            return;
        }

        String fullname = request.getParameter("fullname");
        String phone = request.getParameter("phone");
        String note = request.getParameter("note");
        String address = request.getParameter("address");
        String city = request.getParameter("city");
        String districtName = request.getParameter("districtName");
        String wardName = request.getParameter("wardName");
        String nation = request.getParameter("nation");
        String paymentMethod = request.getParameter("paymentMethod");
        String shippingProvider = request.getParameter("shippingProvider");
        String shippingFeeRaw = request.getParameter("shippingFee");
        String voucherIdRaw = request.getParameter("voucherId");
        StringBuilder fullAddressBuilder = new StringBuilder();

        if (address != null && !address.isBlank()) {
            fullAddressBuilder.append(address.trim());
        }
        if (wardName != null && !wardName.isBlank()) {
            fullAddressBuilder.append(", ").append(wardName.trim());
        }
        if (districtName != null && !districtName.isBlank()) {
            fullAddressBuilder.append(", ").append(districtName.trim());
        }
        if (city != null && !city.isBlank()) {
            fullAddressBuilder.append(", ").append(city.trim());
        }
        if (nation != null && !nation.isBlank()) {
            fullAddressBuilder.append(", ").append(nation.trim());
        }
        String fullAddress = fullAddressBuilder.toString();
        //parse phí ship
        BigDecimal shippingFee;

        try {
            if (shippingFeeRaw == null || shippingFeeRaw.isBlank()) {
                logger.warn("Payment request denied: Shipping fee information not received from client.");
                if (isPrepare) {
                    writeJsonError(response, "Vui lòng chọn địa chỉ để hệ thống tính phí vận chuyển.");
                } else {
                    request.setAttribute("error", "Vui lòng chọn địa chỉ để hệ thống tính phí vận chuyển.");
                    doGet(request, response);
                }
                return;
            }

            shippingFee = new BigDecimal(shippingFeeRaw.trim());

            if (shippingFee.compareTo(BigDecimal.ZERO) < 0) {
                logger.warn("Payment request denied: Received shipping fee is less than 0 ({})", shippingFeeRaw);
                if (isPrepare) {
                    writeJsonError(response, "Phí vận chuyển không hợp lệ.");
                } else {
                    request.setAttribute("error", "Phí vận chuyển không hợp lệ.");
                    doGet(request, response);
                }
                return;
            }

        } catch (NumberFormatException e) {
            logger.error("Error parsing numeric shipping fee from raw value: '{}'", shippingFeeRaw);

            if (isPrepare) {
                writeJsonError(response, "Phí vận chuyển không hợp lệ.");
            } else {
                request.setAttribute("error", "Phí vận chuyển không hợp lệ.");
                doGet(request, response);
            }
            return;
        }

        if (shippingProvider == null || shippingProvider.isBlank()) {
            shippingProvider = "GHN";
        }


        Order order = new Order();
        order.setShippingName(fullname);
        order.setShippingPhone(phone);
        order.setShippingAddress(fullAddress);
        order.setShippingProvider(shippingProvider);
        order.setShippingFee(shippingFee);

//        //test
//        order.setShippingProvider("GHN");
//        order.setShippingFee(BigDecimal.valueOf(30000));

        order.setNote(note == null ? "" : note.trim());

        if (paymentMethod == null || paymentMethod.isBlank()) {
            paymentMethod = "COD";
        }

        //Tạo dữ liệu đơn hàng chuẩn hóa hash_value để user copy sang tool ký số.
        List<OrderItem> orderItemsForHash = new ArrayList<>();
        BigDecimal subTotalBD = BigDecimal.ZERO;

        for (Product product : selectedCart.list()) {
            BigDecimal price = BigDecimal.valueOf(product.getPrice()).setScale(2, RoundingMode.HALF_UP);
            BigDecimal discountRate = OrderCryptoUtil.normalizeDiscountRate(product.getDiscount());

            OrderItem item = new OrderItem();
            item.setProductId(product.getId());
            item.setQuantity(product.getQuantity());
            item.setPrice(price);
            item.setDiscountRate(discountRate);
            orderItemsForHash.add(item);

            BigDecimal lineTotal = price.multiply(BigDecimal.valueOf(product.getQuantity()));
            subTotalBD = subTotalBD.add(lineTotal);
        }

        BigDecimal vatBD = subTotalBD.multiply(BigDecimal.valueOf(0.05)).setScale(0, RoundingMode.HALF_UP).setScale(2, RoundingMode.HALF_UP);
        BigDecimal grandTotalBD = subTotalBD.add(vatBD).add(shippingFee).setScale(2, RoundingMode.HALF_UP);

        //lấy voucher tại thời điểm checkout (nếu không dùng voucher=> voucherCode= none, discountAmount= 0.00)
        BigDecimal discountAmount = BigDecimal.ZERO;
        String voucherCode = "NONE";

        if (voucherIdRaw != null && !voucherIdRaw.isBlank()) {
            try {
                int voucherId = Integer.parseInt(voucherIdRaw);
                Voucher voucher = new VoucherDAO().getVoucherById(voucherId);
                if (voucher != null) {
                    String voucherError = voucher.validateString(grandTotalBD);
                    if (voucherError == null) {
                        voucherCode = voucher.getCode();
                        discountAmount = voucher.calculateDiscount(grandTotalBD).setScale(2, RoundingMode.HALF_UP);
                        grandTotalBD = voucher.applyDiscount(grandTotalBD).setScale(2, RoundingMode.HALF_UP);
                        session.setAttribute("voucherId", voucherId);
                    }
                }
            } catch (NumberFormatException e) {
                logger.error("Error parsing voucherIdRaw in POST flow: {}", voucherIdRaw);
                request.setAttribute("error", "Voucher không hợp lệ.");
                doGet(request, response);
                return;
            }
        }

        // Tạo chuỗi chuẩn hóa theo format:
        // user_id:shipping_name:shipping_phone:shipping_address|voucher_code:discount_amount|total_price|product_id,quantity,price,discount_rate;...
        String plainText = OrderCryptoUtil.buildOrderPlainText(user.getId(), fullname, phone, fullAddress, voucherCode, discountAmount, grandTotalBD, orderItemsForHash);
        String serverHashValue = OrderCryptoUtil.sha256Hex(plainText);

        //Nếu gọi bước prepare => chỉ trả hash_value về popup, chưa lưu đơn hàng vào db.
        if ("prepare".equalsIgnoreCase(cryptoAction)) {
            response.setContentType("application/json;charset=UTF-8");
            JsonObject json = new JsonObject();
            json.addProperty("success", true);
            json.addProperty("hashValue", serverHashValue);
            response.getWriter().write(json.toString());
            return;
        }

        // Nếu gọi bước place => bắt buộc có chữ ký số mới cho lưu đơn hàng.
        if ("place".equalsIgnoreCase(cryptoAction)) {
            if (submittedHash == null || !submittedHash.equalsIgnoreCase(serverHashValue)) {
                request.setAttribute("error", "Mã băm đơn hàng không khớp. Vui lòng thử lại.");
                doGet(request, response);
                return;
            }

            if (digitalSignature == null || digitalSignature.trim().isEmpty()) {
                request.setAttribute("error", "Vui lòng nhập chữ ký điện tử trước khi đặt hàng.");
                doGet(request, response);
                return;
            }
            order.setHashValue(serverHashValue);
            order.setSignature(digitalSignature.trim());
            order.setVoucherCode(voucherCode);
            order.setDiscountAmount(discountAmount);
            order.setTotalPrice(grandTotalBD);
        } else {
            response.sendRedirect(request.getContextPath() + "/cart");
            return;
        }

        OrderService orderService = new OrderService();
        int orderId = orderService.placeOrderAndReturnId(user, selectedCart, order, paymentMethod);

        if (orderId > 0) {
            CartDAO cartDAO = new CartDAO();

            for (Integer id : selectedIds) {
                cart.remove(id);
                cartDAO.deleteItem(user.getId(), id);
            }

            session.setAttribute("cart", cart);

            // Cho phép vào trang /orderSuccess
            session.setAttribute("orderSuccess", true);

            // Lưu orderId vừa đặt
            session.setAttribute("lastOrderId", orderId);

            double calculatedSubTotal = selectedCart.total();
            double calculatedVat = Math.round(calculatedSubTotal * 0.05);
            double calculatedGrandTotal = Math.round(calculatedSubTotal + calculatedVat + shippingFee.doubleValue());

            if (voucherIdRaw != null && !voucherIdRaw.isBlank()) {
                VoucherDAO voucherDAO = new VoucherDAO();
                Voucher v = voucherDAO.getVoucherById(Integer.parseInt(voucherIdRaw));
                if (v != null) {
                    calculatedGrandTotal = v.applyDiscount(BigDecimal.valueOf(calculatedGrandTotal)).doubleValue();
                }
            }

            if ("VNPAY".equals(paymentMethod)) {
                long amount = (long) calculatedGrandTotal * 100;
                Map<String, String> vnp_Params = new HashMap<>();
                vnp_Params.put("vnp_Version", "2.1.0");
                vnp_Params.put("vnp_Command", "pay");
                vnp_Params.put("vnp_TmnCode", VNPAYConfig.vnp_TmnCode);
                vnp_Params.put("vnp_Amount", String.valueOf(amount));
                vnp_Params.put("vnp_CurrCode", "VND");
                vnp_Params.put("vnp_TxnRef", String.valueOf(orderId));
                vnp_Params.put("vnp_OrderInfo", "Thanh toan don hang " + orderId);
                vnp_Params.put("vnp_OrderType", "other");
                vnp_Params.put("vnp_Locale", "vn");
                vnp_Params.put("vnp_ReturnUrl", VNPAYConfig.getReturnUrl(request));
                vnp_Params.put("vnp_IpAddr", VNPAYConfig.getIpAddress(request));

                Calendar calendar = Calendar.getInstance(TimeZone.getTimeZone("Etc/GMT+7"));
                SimpleDateFormat formatter = new SimpleDateFormat("yyyyMMddHHmmss");
                String vnp_CreateDate = formatter.format(calendar.getTime());
                vnp_Params.put("vnp_CreateDate", vnp_CreateDate);

                calendar.add(Calendar.MINUTE, 15);
                String vnp_ExpireDate = formatter.format(calendar.getTime());
                vnp_Params.put("vnp_ExpireDate", vnp_ExpireDate);

                List fieldNames = new ArrayList(vnp_Params.keySet());
                Collections.sort(fieldNames);

                StringBuilder hashData = new StringBuilder();
                StringBuilder query = new StringBuilder();
                Iterator itr = fieldNames.iterator();
                while (itr.hasNext()) {
                    String fieldName = (String) itr.next();
                    String fieldValue = vnp_Params.get(fieldName);
                    if (fieldName != null && !fieldName.isEmpty()) {
                        hashData.append(fieldName);
                        hashData.append('=');
                        hashData.append(URLEncoder.encode(fieldValue, StandardCharsets.US_ASCII));

                        query.append(URLEncoder.encode(fieldName, StandardCharsets.US_ASCII));
                        query.append('=');
                        query.append(URLEncoder.encode(fieldValue, StandardCharsets.US_ASCII));

                        if (itr.hasNext()) {
                            query.append('&');
                            hashData.append('&');
                        }
                    }
                }

                String queryUrl = query.toString();
                String vnp_SecureHash = VNPAYConfig.hmacSHA512(VNPAYConfig.vnp_HashSecret, hashData.toString());
                queryUrl += "&vnp_SecureHash=" + vnp_SecureHash;

                String paymentUrl = VNPAYConfig.vnp_Url + "?" + queryUrl;
                response.sendRedirect(paymentUrl);
            } else if ("MOMO".equals(paymentMethod)) {
                String amount = String.valueOf((long) calculatedGrandTotal);
                String momoOrderId = orderId + "_" + System.currentTimeMillis();
                String requestId = String.valueOf(System.currentTimeMillis());
                String orderInfo = "Thanh toan don hang " + orderId;
                String returnUrl = MomoConfig.getReturnUrl(request);
                String ipnUrl = MomoConfig.getIpnUrl(request);
                String requestType = "captureWallet";
                String extraData = "";

                String rawHash = "accessKey=" + MomoConfig.accessKey + "&amount=" + amount + "&extraData=" + extraData + "&ipnUrl=" + ipnUrl + "&orderId=" + momoOrderId + "&orderInfo=" + orderInfo + "&partnerCode=" + MomoConfig.partnerCode + "&redirectUrl=" + returnUrl + "&requestId=" + requestId + "&requestType=" + requestType;

                String signature = MomoConfig.hcmacSHA256(MomoConfig.secretKey, rawHash);

                String jsonRequest = "{" + "\"partnerCode\":\"" + MomoConfig.partnerCode + "\"," + "\"partnerName\":\"PaperCraft\"," + "\"storeId\":\"MomoTestStore\"," + "\"requestId\":\"" + requestId + "\"," + "\"amount\":" + amount + "," + "\"orderId\":\"" + momoOrderId + "\"," + "\"orderInfo\":\"" + orderInfo + "\"," + "\"redirectUrl\":\"" + returnUrl + "\"," + "\"ipnUrl\":\"" + ipnUrl + "\"," + "\"lang\":\"vi\"," + "\"requestType\":\"" + requestType + "\"," + "\"autoCapture\":true," + "\"extraData\":\"" + extraData + "\"," + "\"signature\":\"" + signature + "\"" + "}";

                // Gọi API momo
                URL url = new URL(MomoConfig.momo_Url);
                HttpURLConnection conn = (HttpURLConnection) url.openConnection();
                conn.setRequestMethod("POST");
                conn.setRequestProperty("Content-Type", "application/json; charset=UTF-8");
                conn.setDoOutput(true);

                // Đọc dữ liệu trả về từ momo
                try (OutputStream os = conn.getOutputStream()) {
                    byte[] input = jsonRequest.getBytes(StandardCharsets.UTF_8);
                    os.write(input, 0, input.length);
                }
                StringBuilder responseStr = new StringBuilder();
                try (BufferedReader br = new BufferedReader(new InputStreamReader(conn.getInputStream(), StandardCharsets.UTF_8))) {
                    String responseLine;
                    while ((responseLine = br.readLine()) != null) {
                        responseStr.append(responseLine.trim());
                    }
                }

                String resultJson = responseStr.toString();
                String payUrl = "";
                int payUrlIndex = resultJson.indexOf("\"payUrl\":\"");
                if (payUrlIndex != -1) {
                    int start = payUrlIndex + 10;
                    int end = resultJson.indexOf("\"", start);
                    payUrl = resultJson.substring(start, end);
                }

                if (!payUrl.isEmpty()) {
                    response.sendRedirect(payUrl);
                } else {
                    System.out.println("MoMo API Error Response: " + resultJson); // debug
                    request.getSession().setAttribute("error", "Lỗi tạo giao dịch MoMo. Hệ thống đang bảo trì!");
                    response.sendRedirect(request.getContextPath() + "/cart");
                }
            } else {
                response.sendRedirect(request.getContextPath() + "/order-success");
            }
        } else {
            request.setAttribute("error", "Đặt hàng thất bại. Có thể một số sản phẩm không còn đủ tồn kho, vui lòng kiểm tra lại giỏ hàng.");
            doGet(request, response);
        }
    }

    //parseSelectedIdSet
    private Set<Integer> parseSelectedIdSet(String selectedIdsRaw) {
        Set<Integer> result = new HashSet<>();

        //check đàu vào rỗng
        boolean isEmpty = selectedIdsRaw == null || selectedIdsRaw.trim().isEmpty();
        if (isEmpty) {
            return result;
        }
        //tách chuỗi thành mảng theo ","
        String[] parts = selectedIdsRaw.split(",");
        for (String part : parts) {
            String trimmed = part.trim();
            if (trimmed.matches("\\d+")) {
                result.add(Integer.parseInt(trimmed));
            }
        }
        return result;
    }

    //hàm trả json lỗi
    private void writeJsonError(HttpServletResponse response, String message) throws IOException {
        response.setContentType("application/json;charset=UTF-8");

        JsonObject json = new JsonObject();
        json.addProperty("success", false);
        json.addProperty("message", message);

        response.getWriter().write(json.toString());
    }
}