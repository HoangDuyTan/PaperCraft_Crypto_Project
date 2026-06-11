package com.papercraft.controller.client;

import com.papercraft.config.MomoConfig;
import com.papercraft.config.VNPAYConfig;
import com.papercraft.dao.*;
import com.papercraft.model.*;
import com.papercraft.service.OrderService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.math.BigDecimal;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.text.SimpleDateFormat;
import java.util.*;

@WebServlet("/checkout")
public class CheckoutServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        HttpSession session = request.getSession();

        // Kiểm tra Login
        if (session.getAttribute("acc") == null) {
            response.sendRedirect(request.getContextPath() + "/login?redirect=/checkout");
            return;
        }

        User user = (User) session.getAttribute("acc");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login?redirect=/checkout");
            return;
        }

        Cart cart = (Cart) session.getAttribute("cart");
        if (cart == null || cart.list().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/cart");
            return;
        }


        String selectedIdsRaw = request.getParameter("selectedIds");
        Set<Integer> selectedIds = parseSelectedIdSet(selectedIdsRaw);

        if (selectedIds.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/cart");
            return;
        }

        AddressDAO addressDAO = new AddressDAO();
        Address userAddr = addressDAO.findDefaultAddress(user.getId());
        request.setAttribute("addr", userAddr);

        UserVoucherDAO userVoucherDAO = new UserVoucherDAO();
        List<Voucher> vouchers = userVoucherDAO.getVouchersByUserId(user.getId());
        request.setAttribute("vouchers", vouchers);

        String voucherCode = request.getParameter("voucherCode");
        if (voucherCode != null && !voucherCode.trim().isEmpty()) {
            Voucher voucher = new VoucherDAO().getVoucherByCode(voucherCode.trim());
            if (voucher == null) {
                request.setAttribute("saveVoucherError", "Mã voucher không tồn tại");
            } else if (!voucher.isAvailable()) {
                request.setAttribute("saveVoucherError", "Voucher hiện không khả dụng");
            } else {
                boolean success = userVoucherDAO.addUserVoucher(user.getId(), voucher.getId());
                if (!success) {
                    request.setAttribute("saveVoucherError", "Bạn đã lưu voucher này rồi hoặc đã sử dụng");
                } else {
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
                hasInvalidStockItem = true;
                continue;
            }

            if (p.getQuantity() > freshProduct.getStockQuantity()) {
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
            session.setAttribute("error", "Một số sản phẩm đã hết hàng hoặc không đủ tồn kho. Vui lòng kiểm tra lại giỏ hàng.");
            response.sendRedirect(request.getContextPath() + "/cart");
            return;
        }

        //nếu selectedId gửi lên không khớp sp trong cart => không cho checkout(về cart )
        if (items.isEmpty()) {
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
                selectedVoucher = new VoucherDAO().getVoucherById(voucherId);
                if (selectedVoucher != null) {
                    String voucherError = selectedVoucher.validateString(BigDecimal.valueOf(grandTotal));

                    if (voucherError != null) {
                        request.setAttribute("errorVoucher", voucherError);

                    } else {
                        discountAmount = selectedVoucher.calculateDiscount(BigDecimal.valueOf(grandTotal));
                        grandTotal = selectedVoucher.applyDiscount(BigDecimal.valueOf(grandTotal)).toBigInteger().doubleValue();
                        request.setAttribute("successVoucher", "Áp dụng voucher thành công");
                        request.setAttribute("selectedVoucher", selectedVoucher);
                    }
                }
            } catch (NumberFormatException e) {
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

        request.getRequestDispatcher("/WEB-INF/views/client/payment.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {

        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();

        User user = (User) session.getAttribute("acc");
        Cart cart = (Cart) session.getAttribute("cart");

        String selectedIdsRaw = request.getParameter("selectedIds");
        Set<Integer> selectedIds = parseSelectedIdSet(selectedIdsRaw);

        if (user == null || cart == null || cart.list().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/cart");
            return;
        }

        if (selectedIds.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/cart");
            return;
        }
//        Cart selectedCart = new Cart();
//        for (Product p : cart.list()) {
//            if (selectedIds.contains(p.getId())) {
//                selectedCart.put(p);
//            }
//        }
        ProductDAO productDAO = new ProductDAO();
        Cart selectedCart = new Cart();

        for (Product p : cart.list()) {
            if (!selectedIds.contains(p.getId())) {
                continue;
            }

            Product freshProduct = productDAO.getProductById(p.getId());

            if (freshProduct == null || freshProduct.getStockQuantity() <= 0) {
                session.setAttribute("error", "Một số sản phẩm đã hết hàng. Vui lòng kiểm tra lại giỏ hàng.");
                response.sendRedirect(request.getContextPath() + "/cart");
                return;
            }

            if (p.getQuantity() > freshProduct.getStockQuantity()) {
                session.setAttribute("error", "Số lượng sản phẩm trong giỏ đã vượt quá tồn kho hiện tại.");
                response.sendRedirect(request.getContextPath() + "/cart");
                return;
            }

            freshProduct.setQuantity(p.getQuantity());
            selectedCart.put(freshProduct);
        }
        if (selectedCart.list().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/cart");
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
        if (voucherIdRaw != null && !voucherIdRaw.isBlank()) {
            int voucherId = Integer.parseInt(voucherIdRaw);
            session.setAttribute("voucherId", voucherId);
        }

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

//        String fullAddress = fullAddressBuilder.toString();
        String fullAddress = address + ", " + wardName + ", " + districtName + ", " + city + ", " + nation;

        //parse phí ship
        BigDecimal shippingFee;

        try {
            if (shippingFeeRaw == null || shippingFeeRaw.isBlank()) {
                request.setAttribute("error", "Vui lòng chọn địa chỉ để hệ thống tính phí vận chuyển.");
                doGet(request, response);
                return;
            }

            shippingFee = new BigDecimal(shippingFeeRaw.trim());

            if (shippingFee.compareTo(BigDecimal.ZERO) < 0) {
                request.setAttribute("error", "Phí vận chuyển không hợp lệ.");
                doGet(request, response);
                return;
            }

        } catch (NumberFormatException e) {
            request.setAttribute("error", "Phí vận chuyển không hợp lệ.");
            doGet(request, response);
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

                String rawHash = "accessKey=" + MomoConfig.accessKey +
                        "&amount=" + amount +
                        "&extraData=" + extraData +
                        "&ipnUrl=" + ipnUrl +
                        "&orderId=" + momoOrderId +
                        "&orderInfo=" + orderInfo +
                        "&partnerCode=" + MomoConfig.partnerCode +
                        "&redirectUrl=" + returnUrl +
                        "&requestId=" + requestId +
                        "&requestType=" + requestType;

                String signature = MomoConfig.hcmacSHA256(MomoConfig.secretKey, rawHash);

                String jsonRequest = "{" +
                        "\"partnerCode\":\"" + MomoConfig.partnerCode + "\"," +
                        "\"partnerName\":\"PaperCraft\"," +
                        "\"storeId\":\"MomoTestStore\"," +
                        "\"requestId\":\"" + requestId + "\"," +
                        "\"amount\":" + amount + "," +
                        "\"orderId\":\"" + momoOrderId + "\"," +
                        "\"orderInfo\":\"" + orderInfo + "\"," +
                        "\"redirectUrl\":\"" + returnUrl + "\"," +
                        "\"ipnUrl\":\"" + ipnUrl + "\"," +
                        "\"lang\":\"vi\"," +
                        "\"requestType\":\"" + requestType + "\"," +
                        "\"autoCapture\":true," +
                        "\"extraData\":\"" + extraData + "\"," +
                        "\"signature\":\"" + signature + "\"" +
                        "}";

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
}