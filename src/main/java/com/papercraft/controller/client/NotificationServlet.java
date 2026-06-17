package com.papercraft.controller.client;

import com.google.gson.JsonArray;
import com.google.gson.JsonObject;
import com.papercraft.dao.NotificationDAO;
import com.papercraft.model.Notification;
import com.papercraft.model.User;
import com.papercraft.model.enums.NotificationType;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "NotificationServlet", urlPatterns = {"/notification"})
public class NotificationServlet extends HttpServlet {

    private static final Logger logger =  LoggerFactory.getLogger(NotificationServlet.class);
    private final NotificationDAO notificationDAO = new NotificationDAO();
    private String contextPath;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession sesion = request.getSession();
        User user = (User) sesion.getAttribute("acc");
        if (user != null) {
            String action = request.getParameter("action");
            logger.debug("Received GET /notification request from User ID: '{}', Action: '{}'", user.getId(), action);

            if (action == null || action.equals("list")) {
                getNotifications(request, response);
            } else {
                logger.warn("Invalid GET request action: '{}' from User ID: '{}'", action, user.getId());
                response.sendError(400);
            }
        }

    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("acc");
        String action = request.getParameter("action");

        if (user != null) {
            logger.info("Received POST /notification request to change state from User ID: '{}', Action: '{}'", user.getId(), action);
        }

        if ("seen".equals(action)) {
            markSeen(request, response);
        } else if ("read".equals(action)) {
            markRead(request, response);
        } else {
            logger.warn("POST request action is not supported or is empty: '{}'", action);
            response.sendError(400);
        }
    }

    private void getNotifications(HttpServletRequest request, HttpServletResponse response) throws IOException {
        User acc = (User) request.getSession().getAttribute("acc");
        contextPath = request.getContextPath();

        if (acc == null) {
            logger.warn("getNotifications blocked: Account object in session is null.");
            response.sendError(HttpServletResponse.SC_UNAUTHORIZED);
            return;
        }

        logger.debug("Querying notification list and unseen count for User ID: '{}'", acc.getId());
        List<Notification> notifications = notificationDAO.getAllNotificationByUserId(acc.getId());
        int unseenCount = notificationDAO.countUnseenNotification(acc.getId());

        JsonObject result = new JsonObject();
        result.addProperty("unseenCount", unseenCount);

        JsonArray array = new JsonArray();
        for (Notification n : notifications) {
            JsonObject item = new JsonObject();
            item.addProperty("id", n.getId());
            item.addProperty("content", n.getContent());
            item.addProperty("type", n.getType() != null ? n.getType().name() : "");
            item.addProperty("title", n.getType() != null ? n.getType().getTitle() : "");
            item.addProperty("isRead", n.isRead());
            item.addProperty("isSeen", n.isSeen());
            item.addProperty("relativeTime", n.getRelativeTime());
            item.addProperty("url", buildNotificationUrl(n));

            array.add(item);
        }

        result.add("notifications", array);

        logger.info("Successfully loaded notification list for User ID: '{}'. Total: {}, Unseen count: {}",
                acc.getId(), notifications.size(), unseenCount);

        response.setContentType("application/json;charset=UTF-8");
        response.getWriter().write(result.toString());
    }

    private void markSeen(HttpServletRequest request, HttpServletResponse response) throws IOException {
        User acc = (User) request.getSession().getAttribute("acc");

        if (acc == null) {
            logger.warn("markSeen blocked: Request to update 'seen' status from anonymous user.");
            response.sendError(HttpServletResponse.SC_UNAUTHORIZED);
            return;
        }

        logger.debug("Updating status: Marking all notifications as SEEN for User ID: '{}'", acc.getId());
        notificationDAO.markAllSeen(acc.getId());

        logger.info("Successfully updated SEEN status for all notifications of User ID: '{}'", acc.getId());
        response.setStatus(HttpServletResponse.SC_OK);
    }

    private void markRead(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String idStr = request.getParameter("id");

        if (idStr == null) {
            logger.warn("markRead failed: Missing 'id' parameter of the notification to update.");
            response.sendError(HttpServletResponse.SC_BAD_REQUEST);
            return;
        }

        try {
            int notificationId = Integer.parseInt(idStr);
            logger.debug("Updating status: Marking notification ID '{}' as READ", notificationId);
            notificationDAO.markRead(notificationId);
            logger.info("Successfully updated READ status for notification ID: '{}'", notificationId);
            response.setStatus(HttpServletResponse.SC_OK);
        } catch (NumberFormatException e) {
            logger.error("Format of submitted notification 'id' parameter is not a valid integer: '{}'", idStr);
            response.sendError(HttpServletResponse.SC_BAD_REQUEST);
        }
    }

    private String buildNotificationUrl(Notification notification) {
        if (contextPath == null) return "";
        NotificationType type = notification.getType();
        if (type == null) {
            logger.warn("Detected notification ID '{}' without classification type (NotificationType is null).", notification.getId());
            return contextPath;
        }
        if (type.requiresReferenceId()) {
            Integer refId = notification.getReferenceId();
            if (refId == null) {
                logger.warn("Notification type '{}' (ID: '{}') requires ReferenceId but this field is empty.", type.name(), notification.getId());
                return contextPath;
            }
            return contextPath+ "/" +String.format(type.getRoutePattern(), notification.getReferenceId());
        }
        return contextPath+"/" + type.getRoutePattern();
    }
}