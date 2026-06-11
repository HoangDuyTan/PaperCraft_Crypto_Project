package com.papercraft.controller.api;

import com.papercraft.service.GHNAddressService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/api/ghn/address")
public class GHNAddressServlet extends HttpServlet {
    private final GHNAddressService ghnAddressService = new GHNAddressService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setCharacterEncoding("UTF-8");
        response.setContentType("application/json; charset=UTF-8");

        String type = request.getParameter("type");

        try {
            String resultJson;

            if ("province".equalsIgnoreCase(type)) {
                resultJson = ghnAddressService.getProvinces();

            } else if ("district".equalsIgnoreCase(type)) {
                String provinceId = request.getParameter("provinceId");

                if (provinceId == null || provinceId.isBlank()) {
                    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    response.getWriter().write("{\"code\":400,\"message\":\"provinceId is required\"}");
                    return;
                }

                resultJson = ghnAddressService.getDistricts(provinceId);

            } else if ("ward".equalsIgnoreCase(type)) {
                String districtId = request.getParameter("districtId");

                if (districtId == null || districtId.isBlank()) {
                    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    response.getWriter().write("{\"code\":400,\"message\":\"districtId is required\"}");
                    return;
                }

                resultJson = ghnAddressService.getWards(districtId);

            } else {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("{\"code\":400,\"message\":\"Invalid type\"}");
                return;
            }

            response.getWriter().write(resultJson);

        } catch (Exception e) {
            e.printStackTrace();

            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            String safeMessage = e.getMessage() == null ? "Unknown error" : e.getMessage().replace("\\", "\\\\").replace("\"", "\\\"").replace("\n", "\\n").replace("\r", "\\r");

            response.getWriter().write("{\"code\":500,\"message\":\"Cannot call GHN API\",\"error\":\"" + safeMessage + "\"}"
            );
        }
    }
}