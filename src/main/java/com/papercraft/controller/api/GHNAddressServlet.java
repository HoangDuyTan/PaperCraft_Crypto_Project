package com.papercraft.controller.api;

import com.papercraft.service.GHNAddressService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.IOException;

@WebServlet("/api/ghn/address")
public class GHNAddressServlet extends HttpServlet {

    private static final Logger logger = LoggerFactory.getLogger(GHNAddressServlet.class);
    private final GHNAddressService ghnAddressService = new GHNAddressService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setCharacterEncoding("UTF-8");
        response.setContentType("application/json; charset=UTF-8");

        String type = request.getParameter("type");
        logger.info("Received GHN address API request. Query type: '{}'", type);

        try {
            String resultJson;

            if ("province".equalsIgnoreCase(type)) {
                resultJson = ghnAddressService.getProvinces();

            } else if ("district".equalsIgnoreCase(type)) {
                String provinceId = request.getParameter("provinceId");

                if (provinceId == null || provinceId.isBlank()) {
                    logger.warn("Request to get Districts failed: Missing 'provinceId' parameter.");
                    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    response.getWriter().write("{\"code\":400,\"message\":\"provinceId is required\"}");
                    return;
                }

                resultJson = ghnAddressService.getDistricts(provinceId);

            } else if ("ward".equalsIgnoreCase(type)) {
                String districtId = request.getParameter("districtId");

                if (districtId == null || districtId.isBlank()) {
                    logger.warn("Request to get Wards failed: Missing 'districtId' parameter.");
                    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    response.getWriter().write("{\"code\":400,\"message\":\"districtId is required\"}");
                    return;
                }

                resultJson = ghnAddressService.getWards(districtId);

            } else {
                logger.warn("The passed 'type' parameter is not supported: '{}'", type);
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("{\"code\":400,\"message\":\"Invalid type\"}");
                return;
            }

            response.getWriter().write(resultJson);
            logger.debug("Successfully responded with address data for type: '{}'", type);
        } catch (Exception e) {
            logger.error("Critical error occurred while establishing connection or processing data from partner GHN API (Type: '{}'): ", type, e);
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            String safeMessage = e.getMessage() == null ? "Unknown error" : e.getMessage().replace("\\", "\\\\").replace("\"", "\\\"").replace("\n", "\\n").replace("\r", "\\r");

            response.getWriter().write("{\"code\":500,\"message\":\"Cannot call GHN API\",\"error\":\"" + safeMessage + "\"}"
            );
        }
    }
}