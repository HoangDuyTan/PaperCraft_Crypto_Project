package com.papercraft.controller.api;

import com.papercraft.model.Cart;
import com.papercraft.model.Product;
import com.papercraft.service.GHNFeeService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.HashSet;
import java.util.Set;

@WebServlet("/api/ghn/fee")
public class GHNFeeServlet extends HttpServlet {
    private final GHNFeeService ghnFeeService = new GHNFeeService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setCharacterEncoding("UTF-8");
        response.setContentType("application/json; charset=UTF-8");

        try {
            String districtIdRaw = request.getParameter("districtId");
            String wardCode = request.getParameter("wardCode");
            String selectedIdsRaw= request.getParameter("selectedIds");
            Set<Integer> selectedIds= parseSelectedIdSet(selectedIdsRaw);

            if (districtIdRaw == null || districtIdRaw.isBlank()
                    || wardCode == null || wardCode.isBlank()) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("{\"code\":400,\"message\":\"districtId and wardCode are required\"}");
                return;
            }

            int toDistrictId = Integer.parseInt(districtIdRaw);

            HttpSession session = request.getSession(false);
            Cart cart = session == null ? null : (Cart) session.getAttribute("cart");

            if (cart == null || cart.list().isEmpty()) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("{\"code\":400,\"message\":\"Giỏ hàng trong session đang rỗng. Vui lòng thêm sản phẩm và vào checkout lại.\"}");                return;
            }

            int totalQuantity = 0;
            double subTotal = 0;

            for (Product product : cart.list()) {
                if (product == null || product.getQuantity() == null || product.getQuantity() <= 0) {
                    continue;
                }
                if (!selectedIds.isEmpty() && !selectedIds.contains(product.getId())){
                    continue;
                }
                totalQuantity += product.getQuantity();
                subTotal += product.getPrice() * product.getQuantity();

            }

            if (totalQuantity <= 0) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("{\"code\":400,\"message\":\"Không tìm thấy sản phẩm được chọn để tính phí vận chuyển.\"}");                return;
            }


             //Tạm tính dùng mỗi sp 500g và 30 x 20 x 10 cm
            int weight = Math.max(totalQuantity * 500, 500);
            int length = 30;
            int width = 20;
            int height = 10;

             //GHN giới hạn insurance_value an toàn => cap tối đa 5.000.000.
            int insuranceValue = (int) Math.min(Math.round(subTotal), 5_000_000);

            String ghnResponse = ghnFeeService.calculateFee(
                    toDistrictId,
                    wardCode,
                    weight,
                    length,
                    width,
                    height,
                    insuranceValue
            );

            response.getWriter().write(ghnResponse);

        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"code\":400,\"message\":\"districtId is invalid\"}");

        } catch (Exception e) {
            e.printStackTrace();

            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);

            String safeMessage = e.getMessage() == null ? "Unknown error" : e.getMessage()
                    .replace("\\", "\\\\")
                    .replace("\"", "\\\"")
                    .replace("\n", "\\n")
                    .replace("\r", "\\r");

            response.getWriter().write(
                    "{\"code\":500,\"message\":\"Cannot calculate GHN fee\",\"error\":\"" + safeMessage + "\"}"
            );
        }
    }

    private Set<Integer> parseSelectedIdSet(String selectedIdsRaw) {
        Set<Integer> result = new HashSet<>();

        if (selectedIdsRaw == null || selectedIdsRaw.trim().isEmpty()) {
            return result;
        }

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