package com.papercraft.controller.admin;

import com.google.gson.Gson;
import com.papercraft.dao.ContactDAO;
import com.papercraft.dao.NotificationDAO;
import com.papercraft.dto.ContactDTO;
import com.papercraft.model.Contact;
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
import java.io.PrintWriter;
import java.net.URLEncoder;
import java.util.List;

@WebServlet(name = "AdminContact", value = "/admin/admin-contacts")
public class AdminContact extends HttpServlet {

    private static final Logger logger = LoggerFactory.getLogger(AdminContact.class);

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        ContactDAO contactDAO = new ContactDAO();
        String action = request.getParameter("action");
        logger.debug("Received GET request to AdminContact with action: '{}'", action);

        if ("get-by-month".equals(action)) {

            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");

            try {
                int month = Integer.parseInt(request.getParameter("month"));
                int year = Integer.parseInt(request.getParameter("year"));

                logger.info("AJAX request: Loading contact list by month {}/{}", month, year);
                List<ContactDTO> list = new ContactDAO().getContactsByMonth(month, year);

                PrintWriter out = response.getWriter();
                out.print(new Gson().toJson(list));
                out.flush();
                logger.debug("Successfully returned JSON data for action 'get-by-month'");
            } catch (Exception e) {
                logger.error("Critical system error while retrieving contact data by month: ", e);
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                response.getWriter().print("{\"error\":\"server error\"}");
            }
            return;
        }


        String keyword = request.getParameter("keyword");
        if (keyword == null) keyword = "";

        String reply = request.getParameter("reply");
        int replied = -1;

        if (reply != null && !reply.isEmpty()) {
            try {
                replied = Integer.parseInt(reply);
            } catch (NumberFormatException e) {
                logger.warn("Format error for 'reply' filter received from URL (reply='{}'). Automatically setting to display all (-1).", reply);
            }
        }

        if ("toggle".equals(action)) {
            String idRaw = request.getParameter("id");
            try {
                int id = Integer.parseInt(idRaw);
                boolean currentStatus = Boolean.parseBoolean(request.getParameter("status"));
                boolean newStatus = !currentStatus;

                logger.info("Changing status of contact ID '{}' from {} to {}", id, currentStatus, newStatus);
                contactDAO.updateStatus(id, !currentStatus);

                String redirectUrl = "admin-contacts?keyword=" + URLEncoder.encode(keyword, "UTF-8");
                if (replied != -1) {
                    redirectUrl += "&replied=" + replied;
                }

                if (!currentStatus) {
                    HttpSession session = request.getSession();
                    User user = (User) session.getAttribute("acc");

                    if (user != null) {
                        NotificationDAO notificationDAO = new NotificationDAO();
                        Notification noti = new Notification(user.getId(), NotificationType.CONTACT_REPLIED, id);
                        notificationDAO.insertNotification(noti);
                        logger.info("Admin ID '{}' has processed contact ID '{}'. Sent CONTACT_REPLIED notification.", user.getId(), id);
                    } else {
                        logger.warn("Admin info not found in session. Skipping system notification creation.");
                    }
                }

                logger.debug("Redirecting to contact list: {}", redirectUrl);
                response.sendRedirect(redirectUrl);
                return;
            } catch (Exception e) {
                logger.error("Critical error occurred while changing status of contact ID '{}': ", idRaw, e);
            }
        }

        if ("delete".equals(action)) {
            String idRaw = request.getParameter("id");
            try {
                int id = Integer.parseInt(idRaw);
                logger.info("Request to delete contact ID: {}", id);
                boolean deleted = contactDAO.deleteContactById(id);
                logger.info("Result of deleting contact ID '{}' from DB: {}", id, deleted);

                response.sendRedirect("admin-contacts?deleted=" + deleted);
                return;

            } catch (Exception e) {
                logger.error("System error while deleting contact ID '{}': ", idRaw, e);
                response.sendRedirect("admin-contacts?deleted=false");
                return;
            }
        }

        logger.info("Loading contact list - Filters [Keyword: '{}', Reply status (replied): {}]", keyword, replied);
        List<Contact> contacts = contactDAO.getContact(keyword, replied);
        logger.debug("Found total of {} contact records.", (contacts != null ? contacts.size() : 0));

        request.setAttribute("contacts", contacts);
        request.setAttribute("keyword", keyword);
        request.setAttribute("currentReplied", replied);

        logger.debug("Forwarding data to admin-contacts.jsp interface");
        request.getRequestDispatcher("/WEB-INF/views/admin/admin-contacts.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Code xử lý yêu cầu POST
    }
}