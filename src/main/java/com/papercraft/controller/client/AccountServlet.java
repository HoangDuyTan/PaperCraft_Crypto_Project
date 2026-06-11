package com.papercraft.controller.client;

import com.papercraft.dao.AddressDAO;
import com.papercraft.dao.UserDAO;
import com.papercraft.model.Address;
import com.papercraft.model.User;
import com.papercraft.utils.MD5;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet(name = "UpdateProfileServlet", value = "/account")
public class AccountServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("acc");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }


        AddressDAO addressDAO = new AddressDAO();
        Address address = addressDAO.findDefaultAddress(user.getId());

        String lnameAdrr = request.getParameter("lname");
        String fnameAdrr = request.getParameter("fname");
        String phoneAdrr = request.getParameter("address-phone");
        String nation = request.getParameter("nation");
//        String city = request.getParameter("city");
        String poseCode = request.getParameter("post-code");
        String detailAddress = request.getParameter("address");
        String provinceIdRaw = request.getParameter("provinceId");
        String provinceName = request.getParameter("provinceName");
        String districtIdRaw = request.getParameter("districtId");
        String districtName = request.getParameter("districtName");
        String wardCode = request.getParameter("wardCode");
        String wardName = request.getParameter("wardName");

        if (lnameAdrr != null && fnameAdrr != null && phoneAdrr != null && nation != null && provinceIdRaw != null
                && provinceName != null && districtIdRaw != null && districtName != null && wardCode != null
                && wardName != null && poseCode != null && detailAddress != null) {

            Integer provinceId = null;
            Integer districtId = null;

            try {
                if (!provinceIdRaw.isBlank()) {
                    provinceId = Integer.parseInt(provinceIdRaw);
                }

                if (!districtIdRaw.isBlank()) {
                    districtId = Integer.parseInt(districtIdRaw);
                }
            } catch (NumberFormatException e) {
                request.setAttribute("errorAddr", "Địa chỉ không hợp lệ, vui lòng chọn lại Tỉnh/Huyện/Xã.");
                request.setAttribute("address", address);
                request.getRequestDispatcher("/WEB-INF/views/client/account.jsp").forward(request, response);
                return;
            }

            if (address != null) {
                address.setFname(fnameAdrr);
                address.setLname(lnameAdrr);
                address.setPhone(phoneAdrr);
                address.setDetailAddress(detailAddress);
                address.setNation(nation);

                address.setCity(provinceName);
                address.setPostcode(poseCode);

                address.setProvinceId(provinceId);
                address.setProvinceName(provinceName);
                address.setDistrictId(districtId);
                address.setDistrictName(districtName);
                address.setWardCode(wardCode);
                address.setWardName(wardName);
                boolean isUpdateAddr = addressDAO.updateAddress(address, user.getId());
                if (isUpdateAddr) {
                    request.setAttribute("msgAddr", "Cập nhật thông tin thành công!");
                    address = addressDAO.getAddresById(user.getId());
                    request.setAttribute("address", address);
                } else {
                    request.setAttribute("errorAddr", "Có lỗi xảy ra, vui lòng thử lại!");
                }
            } else {
                address = new Address();
                address.setUserId(user.getId());
                address.setFname(fnameAdrr);
                address.setLname(lnameAdrr);
                address.setPhone(phoneAdrr);
                address.setDetailAddress(detailAddress);
                address.setNation(nation);

                address.setCity(provinceName);
                address.setPostcode(poseCode);

                address.setProvinceId(provinceId);
                address.setProvinceName(provinceName);
                address.setDistrictId(districtId);
                address.setDistrictName(districtName);
                address.setWardCode(wardCode);
                address.setWardName(wardName);

                address.setEmail(user.getEmail());
                address.setDefault(true);
                boolean inserted = addressDAO.insertAddress(address);

                if (inserted) {
                    request.setAttribute("msgAddr", "Cập nhật thông tin thành công!");
//                    address = addressDAO.getAddresById(address.getId());
                    address = addressDAO.getAddresById(user.getId());
                    request.setAttribute("address", address);
                } else {
                    request.setAttribute("errorAddr", "Có lỗi xảy ra, vui lòng thử lại!");
                }
            }
        }
        request.setAttribute("address", address);
        request.getRequestDispatcher("/WEB-INF/views/client/account.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("acc");

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        request.setCharacterEncoding("UTF-8");
        String fname = request.getParameter("firstname");
        String lname = request.getParameter("lastname");
        String phone = request.getParameter("phone");
        String gender = request.getParameter("gender");

        String missingInformation = request.getParameter("missingInformation");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirm-password");

        if (fname != null && lname != null && phone != null && gender != null) {
            User userToUpdate = new User();
            userToUpdate.setId(user.getId());
            userToUpdate.setFname(fname);
            userToUpdate.setLname(lname);
            userToUpdate.setPhoneNumber(phone);
            userToUpdate.setGender(gender);

            boolean error = false;
            if (missingInformation != null && missingInformation.equals("true")) {
                if (!password.matches("^(?=.*[0-9])(?=.*[!@#$%^&+=])(?=\\S+$).{8,}$")) {
                    session.setAttribute("error", "Mật khẩu mới yếu! Cần ít nhất 8 kí tự, có số và kí tự đặc biệt");
                    error = true;
                } else if (!password.equals(confirmPassword)) {
                    session.setAttribute("error", "Mật khẩu xác nhận không trùng khớp");
                    error = true;
                } else {
                    userToUpdate.setPasswordHash(MD5.getMD5(password));
                }
            }

            if (!error) {
                UserDAO userDAO = new UserDAO();
                boolean isUpdated = userDAO.updateProfile(userToUpdate);

                if (isUpdated) {
                    user.setFname(fname);
                    user.setLname(lname);
                    user.setPhoneNumber(phone);
                    user.setGender(gender);
                    session.setAttribute("acc", user);

                    if (missingInformation != null && missingInformation.equals("true")) {
                        session.setAttribute("success", "Cập nhật thông tin thành công!");
                        session.removeAttribute("missingInformation");
                        session.removeAttribute("error");
                        session.removeAttribute("password");
                        session.removeAttribute("confirm-password");
                        response.sendRedirect("home");
                        return;
                    }
                    request.setAttribute("msg", "Cập nhật thông tin thành công!");
                } else {
                    request.setAttribute("error", "Có lỗi xảy ra, vui lòng thử lại!");
                }
            }
        }
        request.getRequestDispatcher("/WEB-INF/views/client/account.jsp").forward(request, response);
    }
}
