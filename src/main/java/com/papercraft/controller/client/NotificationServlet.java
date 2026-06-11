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

import java.io.IOException;
import java.util.List;

@WebServlet(name = "NotificationServlet", urlPatterns = {"/notification"})
public class NotificationServlet extends HttpServlet {
    private final NotificationDAO notificationDAO = new NotificationDAO();
    private String contextPath;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession sesion = request.getSession();
        User user = (User) sesion.getAttribute("acc");
        if (user != null) {
            String action = request.getParameter("action");

            if (action == null || action.equals("list")) {
                getNotifications(request, response);
            } else {
                response.sendError(400);
            }
        }

    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");

        if ("seen".equals(action)) {
            markSeen(request, response);
        } else if ("read".equals(action)) {
            markRead(request, response);
        } else {
            response.sendError(400);
        }
    }

    private void getNotifications(HttpServletRequest request, HttpServletResponse response) throws IOException {
        User acc = (User) request.getSession().getAttribute("acc");
        contextPath = request.getContextPath();

        if (acc == null) {
            response.sendError(HttpServletResponse.SC_UNAUTHORIZED);
            return;
        }

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

        response.setContentType("application/json;charset=UTF-8");
        response.getWriter().write(result.toString());
    }

    private void markSeen(HttpServletRequest request, HttpServletResponse response) throws IOException {
        User acc = (User) request.getSession().getAttribute("acc");

        if (acc == null) {
            response.sendError(HttpServletResponse.SC_UNAUTHORIZED);
            return;
        }
        notificationDAO.markAllSeen(acc.getId());
        response.setStatus(HttpServletResponse.SC_OK);
    }

    private void markRead(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String idStr = request.getParameter("id");

        if (idStr == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST);
            return;
        }

        int notificationId = Integer.parseInt(idStr);
        notificationDAO.markRead(notificationId);
        response.setStatus(HttpServletResponse.SC_OK);
    }

    private String buildNotificationUrl(Notification notification) {
        if (contextPath == null) return "";
        NotificationType type = notification.getType();
        if (type == null) {
            return contextPath;
        }
        if (type.requiresReferenceId()) {
            Integer refId = notification.getReferenceId();
            if (refId == null) {
                return contextPath;
            }
            return contextPath+ "/" +String.format(type.getRoutePattern(), notification.getReferenceId());
        }
        return contextPath+"/" + type.getRoutePattern();
    }
}