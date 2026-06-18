package com.papercraft.controller.admin;

import com.papercraft.dao.NotificationDAO;
import com.papercraft.dao.OrderDAO;
import com.papercraft.model.Notification;
import com.papercraft.model.Order;
import com.papercraft.model.User;
import com.papercraft.model.enums.NotificationType;
import com.papercraft.model.enums.VerificationStatus;
import com.papercraft.service.OrderVerificationService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet(name = "AdminOrderManage", value = "/admin/admin-order-manage")
public class AdminOrderManage extends HttpServlet {

    private static final Logger logger = LoggerFactory.getLogger(AdminOrderManage.class);

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("acc");
        String action = request.getParameter("action");
        String status = request.getParameter("status");

        action = (action == null) ? "" : action;
        status = (status == null || status.isEmpty()) ? "" : status;
        logger.debug("Received request to AdminOrderManage. Action: '{}', Status Filter: '{}'", action, status);

        List<Order> orders = new ArrayList<>();
        OrderDAO orderDAO = new OrderDAO();
        if ("filter-status".equals(action)) {
            logger.info("Filtering order list by status: '{}'", status);
            orders = orderDAO.getOrderByState(status, Integer.MAX_VALUE, 0);
        } else if ("change-status".equals(action)) {
            NotificationDAO notificationDAO = new NotificationDAO();
            String idParam = request.getParameter("id");
            String newStatus = request.getParameter("status-order");
            logger.info("Request to change order status. ID: '{}', New status: '{}'", idParam, newStatus);

            if (idParam != null && newStatus != null) {
                try {
                    int orderId = Integer.parseInt(idParam);
                    Order order = orderDAO.getOrderByID(orderId);

                    if (order == null) {
                        logger.warn("Order with ID: {} not found in the database.", orderId);
                    } else {
                        String currentStatus = order.getStatus();

                        if (isValidStatusChange(currentStatus, newStatus)) {
                            orderDAO.updateOrderStatus(orderId, newStatus);
                            logger.info("Admin ID '{}' successfully updated Order {} from [{}] -> [{}]",
                                    (user != null ? user.getId() : "Unknown"), orderId, currentStatus, newStatus);

                            //tao thong bao order
                            NotificationType typeNoti = switch (newStatus) {
                                case "pending" -> NotificationType.ORDER_PENDING;
                                case "shipped" -> NotificationType.ORDER_SHIPPED;
                                case "completed" -> NotificationType.ORDER_COMPLETED;
                                case "canceled" -> NotificationType.ORDER_CANCELLED;
                                default -> null;
                            };

                            if (typeNoti != null) {
                                int customerId = order.getUserId();
                                Notification noti = new Notification(customerId, typeNoti, orderId);
                                notificationDAO.insertNotification(noti);
                                logger.debug("Sent notification of type '{}' for Order ID: {}", typeNoti, orderId);
                            }
                        } else {
                            logger.warn("INVALID status transition for Order ID {}: Cannot change from [{}] to [{}]",
                                    orderId, currentStatus, newStatus);
                        }
                    }
                } catch (NumberFormatException e) {
                    logger.error("Format error: Order ID parameter is not a number: '{}'", idParam);
                } catch (Exception e) {
                    logger.error("System error while changing status of Order ID '{}': ", idParam, e);
                }
            }
            orders = orderDAO.getAllOrders();

        } else if (action.equals("search-order-id")) {
            String orderIdRaw = request.getParameter("order-id");
            request.setAttribute("orderId", orderIdRaw);
            logger.info("Searching for order by ID: '{}'", orderIdRaw);

            try {
                int orderId = Integer.parseInt(orderIdRaw);
                Order order = orderDAO.getOrderByID(orderId);
                if (order != null) {
                    orders.add(order);
                    logger.debug("Found order matching ID: {}", orderId);
                } else {
                    logger.info("No order found with ID: {}", orderId);
                }
            } catch (NumberFormatException e) {
                logger.error("Search error: Format of search order ID '{}' is invalid.", orderIdRaw);
            } catch (Exception e) {
                logger.error("System error while searching for Order ID '{}': ", orderIdRaw, e);
            }
        } else if (action.equals("search-date")) {
            String yearRaw = request.getParameter("year");
            String monthRaw = request.getParameter("month");
            String dayRaw = request.getParameter("day");

            request.setAttribute("dateSearch", yearRaw + "-" + monthRaw + "-" + dayRaw);
            logger.info("Searching for orders by specific date: {}/{}/{}", dayRaw, monthRaw, yearRaw);

            try {
                int year = Integer.parseInt(yearRaw);
                int month = Integer.parseInt(monthRaw);
                int day = Integer.parseInt(dayRaw);
                orders = orderDAO.searchOrderByDate(year, month, day);
                logger.debug("Search results by date: found {} orders.", (orders != null ? orders.size() : 0));
            } catch (NumberFormatException e) {
                logger.error("Format of day/month/year parameters contains invalid characters: [Day: '{}', Month: '{}', Year: '{}']",
                        dayRaw, monthRaw, yearRaw);
            } catch (Exception e) {
                logger.error("System error when querying orders by date: ", e);
            }

        } else if (action.equals("search-month")) {
            String yearRaw = request.getParameter("year");
            String monthRaw = request.getParameter("month");
            logger.info("Searching for orders by month: {}/{}", monthRaw, yearRaw);

            request.setAttribute("monthSearch", yearRaw + "-" + monthRaw);
            try {
                int year = Integer.parseInt(yearRaw);
                int month = Integer.parseInt(monthRaw);
                orders = orderDAO.searchOrderByMonth(year, month);
                logger.debug("Search results by month: found {} orders.", (orders != null ? orders.size() : 0));
            } catch (NumberFormatException e) {
                logger.error("Format of month/year parameters contains invalid characters: [Month: '{}', Year: '{}']", monthRaw, yearRaw);
            } catch (Exception e) {
                logger.error("System error when querying orders by month: ", e);
            }
        } else {
            logger.info("Loading default list of all orders from DB.");
            orders = orderDAO.getAllOrders();
            logger.debug("Successfully loaded {} order records.", (orders != null ? orders.size() : 0));
        }

        // ATBM
        OrderVerificationService verifyService = new OrderVerificationService();
        NotificationDAO notiDAO = new NotificationDAO(); // Initialize once outside the loop

        if (orders != null) {
            for (Order order : orders) {
                VerificationStatus verificationStatus = verifyService.verifyOrder(order);
                order.setVerificationStatus(verificationStatus);

                if (verificationStatus == VerificationStatus.TAMPERED) {
                    if (!notiDAO.existsNotification(order.getUserId(), order.getId(), NotificationType.ORDER_TAMPERED)) {
                        Notification noti = new Notification();
                        noti.setUserId(order.getUserId());
                        noti.setType(NotificationType.ORDER_TAMPERED);
                        noti.setReferenceId(order.getId());
                        noti.setContent("Cảnh báo bảo mật: Đơn hàng #" + order.getId() + " có dấu hiệu bị thay đổi dữ liệu.");

                        notiDAO.insertNotification(noti);
                        logger.warn("Cảnh báo bảo mật: Đơn hàng {} bị thay đổi dữ liệu. Đã gửi thông báo.", order.getId());
                    }
                }
            }
        }

        request.setAttribute("orders", orders);
        request.setAttribute("status", status);
        // request.setAttribute("currentPage", currentPage);
        // request.setAttribute("totalPages", totalPages);

        logger.debug("Forwarding presentation flow to admin-order-manage.jsp");
        request.getRequestDispatcher("/WEB-INF/views/admin/admin-order-manage.jsp").forward(request, response);
    }

    private boolean isValidStatusChange(String currentStatus, String newStatus) {
        if (currentStatus == null || newStatus == null) {
            return false;
        }

        currentStatus = currentStatus.trim().toLowerCase();
        newStatus = newStatus.trim().toLowerCase();

        switch (currentStatus) {
            case "pending":
                return newStatus.equals("shipped") || newStatus.equals("canceled");

            case "shipped":
                return newStatus.equals("completed") || newStatus.equals("canceled");

            case "completed":
            case "canceled":
                return false;

            default:
                return false;
        }

    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws
            ServletException, IOException {
        // Code xử lý yêu cầu POST
    }
}