package com.papercraft.controller.admin;

import com.papercraft.dao.AddressDAO;
import com.papercraft.dao.UserDAO;
import com.papercraft.model.Address;
import com.papercraft.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.IOException;

@WebServlet(name = "AdminAccUpdateServlet", value = "/admin/admin-account-update")
public class AdminAccUpdateServlet extends HttpServlet {

    private static final Logger logger = LoggerFactory.getLogger(AdminAccUpdateServlet.class);

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String idRaw = request.getParameter("id");
        logger.debug("Received GET request to show update form for ID: '{}'", idRaw);
        int id = Integer.parseInt(idRaw);

        UserDAO userDAO = new UserDAO();
        User user = userDAO.getUserById(id);

        AddressDAO addressDAO = new AddressDAO();
        Address address = addressDAO.findDefaultAddress(id);

        if (user != null) {
            logger.info("Successfully loaded update data for User: {} (ID: {})", user.getEmail(), id);
            request.setAttribute("acc", user);
            request.setAttribute("address", address);
            request.getRequestDispatcher("/WEB-INF/views/admin/admin-account-update.jsp").forward(request, response);
        } else {
            logger.warn("User not found with ID: {} to update. Redirecting.", id);
            response.sendRedirect("admin-account");
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();

        // Profile
        int id = Integer.parseInt(request.getParameter("id"));
        logger.info("Received POST request to update account for ID: '{}'", id);

        String fname = request.getParameter("fname");
        String lname = request.getParameter("lname");
        String gender = request.getParameter("gender");
        String phoneNumber = request.getParameter("phoneNumber");
        boolean status = Boolean.parseBoolean(request.getParameter("status"));
        logger.debug("Profile data received: [Name: {} {}, Gender: {}, Phone: {}, Status: {}]",
                fname, lname, gender, phoneNumber, status);

        User user = new User();
        user.setId(id);
        user.setFname(fname);
        user.setLname(lname);
        user.setGender(gender);
        user.setPhoneNumber(phoneNumber);

        UserDAO userDAO = new UserDAO();
        boolean isProfileUpdated = userDAO.updateProfile(user);
        boolean isStatusUpdated = userDAO.updateUserStatus(id, status);

        // Address
        String detailAddress = request.getParameter("detailAddress");
        String city = request.getParameter("city");
        String nation = request.getParameter("nation");
        String postcode = request.getParameter("postcode");
        logger.debug("Address data received: [Detail: {}, City: {}, Nation: {}, Postcode: {}]",
                detailAddress, city, nation, postcode);

        Address address = new Address();
        address.setFname(fname);
        address.setLname(lname);
        address.setEmail(user.getEmail());
        address.setPhone(user.getPhoneNumber());
        address.setCity(city);
        address.setDetailAddress(detailAddress);
        address.setNation(nation);
        address.setPostcode(postcode);

        AddressDAO addressDAO = new AddressDAO();
        boolean isAddressUpdated = addressDAO.updateAddress(address, id);

        if (isProfileUpdated && isStatusUpdated && isAddressUpdated) {
            logger.info("Successfully updated all information (Profile, Status, Address) for User ID: {}", id);
            session.setAttribute("msg", "Cập nhật thành công");
        } else {
            logger.error("Failed to update User ID: {}. Detailed status: [Profile: {}, Status: {}, Address: {}]",
                    id, isProfileUpdated, isStatusUpdated, isAddressUpdated);
            session.setAttribute("error", "Có lỗi xảy ra! Cập nhật thất bại");
        }

        logger.debug("Redirecting back to update page with ID: {}", id);
        response.sendRedirect(request.getContextPath() + "/admin/admin-account-update?id=" + id);
    }
}
