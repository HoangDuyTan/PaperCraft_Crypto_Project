package com.papercraft.utils;

import java.io.File;
import java.util.Properties;
import java.util.Random;
import javax.mail.*;
import javax.mail.internet.*;

public class EmailUtils {
    private static final String FROM_EMAIL = "papercraft1784@gmail.com";
    private static final String PASSWORD = "akmu dgzk mxcd uprd";

    public static String generateOTP() {
        Random random = new Random();
        int otp = 100000 + random.nextInt(900000);
        return String.valueOf(otp);
    }

    public static boolean sendEmail(String toEmail, String subject, String content) {
        Properties props = new Properties();
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");

        Authenticator auth = new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(FROM_EMAIL, PASSWORD);
            }
        };
        Session session = Session.getInstance(props, auth);

        try {
            MimeMessage msg = new MimeMessage(session);
            // Header
            msg.addHeader("Content-type", "text/HTML; charset=UTF-8");
            msg.setFrom(new InternetAddress(FROM_EMAIL, "Papercraft"));
            msg.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
            // Body
            msg.setSubject(subject, "UTF-8");
            msg.setContent(content, "text/html; charset=UTF-8");

            Transport.send(msg);
            return true;
        } catch (Exception e) {
            System.err.println("Error sending email to " + toEmail + ": " + e.getMessage());
            return false;
        }
    }

    // Nội dung cho Đăng ký
    public static boolean sendRegisterOTP(String toEmail, String otp) {
        String subject = "Mã xác thực đăng ký tài khoản PaperCraft";
        String content = """
                <h3>Xin chào,</h3>
                <p>Cảm ơn bạn đã đăng ký tài khoản PaperCraft.</p>
                <p>Mã xác thực của bạn là: <strong style='color:blue; font-size: 18px;'> %s </strong></p>
                <p>Mã này có hiệu lực trong thời gian ngắn. Vui lòng không chia sẻ mã này cho bất kỳ ai.</p>
                """.formatted(otp);
        return sendEmail(toEmail, subject, content);
    }

    // Nội dung cho Quên mật khẩu
    public static boolean sendForgotPasswordOTP(String toEmail, String otp) {
        String subject = "Mã xác thực Quên Mật Khẩu PaperCraft";
        String content = """
                <h3>Xin chào,</h3>
                <p>Bạn đã yêu cầu đặt lại mật khẩu tại PaperCraft.</p>
                <p>Mã xác thực của bạn là: <strong style='color:red; font-size: 18px;'> %s </strong></p>
                <p>Mã này có hiệu lực trong thời gian ngắn. Vui lòng không chia sẻ mã này cho bất kỳ ai.</p>
                """.formatted(otp);
        return sendEmail(toEmail, subject, content);
    }

    // Gửi file khóa
    public static boolean sendPrivateKey(String receiver, File pemFile) {
        Properties props = new Properties();
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");

        Session session = Session.getInstance(props, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(FROM_EMAIL, PASSWORD);
            }
        });

        try {
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(FROM_EMAIL, "Papercraft"));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(receiver));
            message.setSubject("RSA Private Key");

            MimeBodyPart textPart = new MimeBodyPart();
            textPart.setText("Đây là Private Key của bạn. Vui lòng lưu giữ cẩn thận.", "UTF-8");

            MimeBodyPart attachmentPart = new MimeBodyPart();
            attachmentPart.attachFile(pemFile);

            Multipart multipart = new MimeMultipart();
            multipart.addBodyPart(textPart);
            multipart.addBodyPart(attachmentPart);

            message.setContent(multipart);
            Transport.send(message);
            return true;
        } catch (Exception e) {
            System.err.println("Error sending private key to " + receiver + ": " + e.getMessage());
            return false;
        }
    }
    public static boolean sendRevokeKeyOTP(
            String toEmail,
            String otp) {

        String subject =
                "Xác nhận báo mất khóa chữ ký số";

        String content = """
        <h3>Xin chào,</h3>

        <p>Hệ thống vừa nhận được yêu cầu báo mất khóa chữ ký số.</p>

        <p>Mã OTP xác nhận của bạn là:</p>

        <h2 style='color:red;'>%s</h2>

        <p>Mã có hiệu lực trong 5 phút.</p>

        <p>Nếu bạn không thực hiện thao tác này, hãy đổi mật khẩu tài khoản ngay lập tức.</p>
        """.formatted(otp);

        return sendEmail(
                toEmail,
                subject,
                content
        );
    }

}