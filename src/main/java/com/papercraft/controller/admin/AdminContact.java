package com.papercraft.controller.admin;

import com.google.gson.Gson;
import com.papercraft.dao.ContactDAO;
import com.papercraft.dao.NotificationDAO;
import com.papercraft.dto.ContactDTO;
import com.papercraft.model.Contact;
import com.papercraft.model.Notification;
import com.papercraft.model.User;
import com.papercraft.model.enums.NotificationType;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.IOException;
import java.io.PrintWriter;
import java.net.URLEncoder;
import java.util.List;

@WebServlet(name = "AdminContact", value = "/admin/admin-contacts")
public class AdminContact extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        ContactDAO contactDAO = new ContactDAO();
        String action = request.getParameter("action");


        if ("get-by-month".equals(action)) {

            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");

            try {
                int month = Integer.parseInt(request.getParameter("month"));
                int year = Integer.parseInt(request.getParameter("year"));

                System.out.println(year);
                List<ContactDTO> list = new ContactDAO().getContactsByMonth(month, year);

                PrintWriter out = response.getWriter();
                out.print(new Gson().toJson(list));
                out.flush();

            } catch (Exception e) {
                e.printStackTrace();
                response.setStatus(500);
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
                System.out.println("format error at admin contact");
                e.printStackTrace();
            }
        }

        if ("toggle".equals(action)) {
            try {
                int id = Integer.parseInt(request.getParameter("id"));
                boolean currentStatus = Boolean.parseBoolean(request.getParameter("status"));
                contactDAO.updateStatus(id, !currentStatus);

                String redirectUrl = "admin-contacts?keyword=" + URLEncoder.encode(keyword, "UTF-8");
                if (replied != -1) {
                    redirectUrl += "&replied=" + replied;
                }
                if(!currentStatus){
                    HttpSession session = request.getSession();
                    User user = (User) session.getAttribute("acc");
                    NotificationDAO notificationDAO = new NotificationDAO();
                    Notification noti = new Notification(user.getId(), NotificationType.CONTACT_REPLIED,id);
                    notificationDAO.insertNotification(noti);
                }
                response.sendRedirect(redirectUrl);
                return;
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        if ("delete".equals(action)) {
            try {
                int id = Integer.parseInt(request.getParameter("id"));
                boolean deleted = contactDAO.deleteContactById(id);

                response.sendRedirect("admin-contacts?deleted=" + deleted);
                return;

            } catch (Exception e) {
                e.printStackTrace();
                response.sendRedirect("admin-contacts?deleted=false");
                return;
            }
        }

        List<Contact> contacts = contactDAO.getContact(keyword, replied);

        request.setAttribute("contacts", contacts);
        request.setAttribute("keyword", keyword);
        request.setAttribute("currentReplied", replied);
        request.getRequestDispatcher("/WEB-INF/views/admin/admin-contacts.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Code xử lý yêu cầu POST
    }
}