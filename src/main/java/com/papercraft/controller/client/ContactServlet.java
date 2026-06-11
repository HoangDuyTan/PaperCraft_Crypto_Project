package com.papercraft.controller.client;

import com.google.gson.JsonObject;
import com.papercraft.dao.ContactDAO;
import com.papercraft.dao.NotificationDAO;
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

import java.io.IOException;

@WebServlet("/contact")
public class ContactServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.getRequestDispatcher("/WEB-INF/views/client/contact.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
         //cấu hình TV
        request.setCharacterEncoding("UTF-8");

        // Lấy dữ liệu từ Form
        String fullname = request.getParameter("fullname") !=null ? request.getParameter("fullname") : "";
        String email = request.getParameter("email") != null ? request.getParameter("email") : "";
        String subject = request.getParameter("subject") != null ? request.getParameter("subject"): "";
        String message = request.getParameter("message") !=null ? request.getParameter("message") : "";

        String errorFullname="";
        String errorEmail="";
        String errorSubject= "";
        String errorMessage="";

        if (fullname.isEmpty()){
            errorFullname = "Vui lòng nhập họ và tên.";
        }
        if (email.isEmpty()){
            errorEmail="Vui lòng nhập Email";
        }else if(!email.matches("^[\\w.-]+@[\\w.-]+\\.[A-Za-z]{2,}$")) {
            errorEmail="Email phải có dạng: nguyenvana@gmail.com.";
        }
        if (subject.isEmpty()){
            errorSubject="Vui lòng nhập chủ dề.";
        }
        if (message.isEmpty()){
            errorMessage="Vui lòng nhập nội dung liên hệ.";
        }

        boolean hasError= !errorFullname.isEmpty()
                || !errorEmail.isEmpty()
                || !errorSubject.isEmpty()
                || !errorMessage.isEmpty();
        JsonObject json= new JsonObject();
        if (hasError){
            json.addProperty("success",false);
            json.addProperty("message","Vui lòng kiểm tra lại thông tin đã nhập.");
            json.addProperty("errorFullname", errorFullname);
            json.addProperty("errorEmail", errorEmail);
            json.addProperty("errorSubject",errorSubject);
            json.addProperty("errorMessage", errorMessage);

            response.getWriter().write(json.toString());
            return;
        }
        Contact contact= new Contact();
        contact.setUserFullname(fullname);
        contact.setEmail(email);
        contact.setContactTitle(subject);
        contact.setContent(message);

        HttpSession session= request.getSession();
        User user = (User) session.getAttribute("acc");
        contact.setUserId(user != null ? user.getId() : null);

        ContactDAO dao= new ContactDAO();
        boolean isuccess= dao.insertContact(contact);
        if(isuccess&& user!=null){
            NotificationDAO notificationDAO = new NotificationDAO();
            Notification noti = new Notification(user.getId(), NotificationType.CONTACT_SUBMITTED,null);
            notificationDAO.insertNotification(noti);
        }

        json.addProperty("success", isuccess);
        json.addProperty("message",isuccess?"Gửi liên hệ thành công! chúng tôi sẽ phản hồi sớm" : "Có lỗi xảy ra. Vui lòng thử lại!");
        json.addProperty("errorFullname","");
        json.addProperty("errorEmail", "");
        json.addProperty("errorSubject","");
        json.addProperty("errorMessage","");

        response.getWriter().write(json.toString());

    }
}