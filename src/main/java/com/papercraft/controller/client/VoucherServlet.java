package com.papercraft.controller.client;

import com.papercraft.dao.UserVoucherDAO;
import com.papercraft.dao.VoucherDAO;
import com.papercraft.model.User;
import com.papercraft.model.Voucher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet(name = "VoucherServlet", urlPatterns = {"/voucher"})
public class VoucherServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        UserVoucherDAO dao = new UserVoucherDAO();
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("acc");
        List<Voucher> vouchers;
        if (user!= null){


            String voucherCode=request.getParameter("voucherCode");
            if(voucherCode!=null&&!voucherCode.trim().isEmpty()){
                Voucher voucher=new VoucherDAO().getVoucherByCode(voucherCode.trim());
                if(voucher==null){
                    request.setAttribute("saveVoucherError", "Mã voucher không tồn tại");
                }else if(!voucher.isAvailable()){
                    request.setAttribute("saveVoucherError", "Voucher hiện không khả dụng");
                }else{
                    boolean success= dao.addUserVoucher(user.getId(), voucher.getId());
                    if(!success){
                        request.setAttribute("saveVoucherError", "Bạn đã lưu voucher này rồi  hoặc đã sử dụng");
                    }else{
                        request.setAttribute("saveVoucherSuccess", "Áp dụng voucher thành công");
                        request.setAttribute("selectedVoucher",voucher);
                    }
                }
            }

            vouchers = dao.getVouchersByUserId(user.getId());
            request.setAttribute("vouchers", vouchers);

        }


        request.getRequestDispatcher("/WEB-INF/views/client/voucher.jsp").forward(request, response);

    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

    }
}