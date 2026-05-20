package com.smartgrocery.util;

import jakarta.mail.*;
import jakarta.mail.internet.*;
import java.io.InputStream;
import java.util.Properties;

public class EmailUtil {

    public static void sendOtp(String toEmail, String otp) throws Exception {
        // Load config
        Properties config = new Properties();
        InputStream is = EmailUtil.class.getClassLoader().getResourceAsStream("email.properties");
        config.load(is);

        String from     = config.getProperty("mail.from");
        String password = config.getProperty("mail.password");

        // Gmail SMTP
        Properties props = new Properties();
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");

        Session session = Session.getInstance(props, new Authenticator() {
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(from, password);
            }
        });

        Message msg = new MimeMessage(session);
        msg.setFrom(new InternetAddress(from));
        msg.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
        msg.setSubject("🔐 Smart Grocery — Your OTP Code");
        msg.setContent(
                "<div style='font-family:Poppins,sans-serif;max-width:400px;margin:auto;padding:30px;border-radius:12px;border:1px solid #e0e0e0'>" +
                        "<h2 style='color:#198754'>🛒 Smart Grocery</h2>" +
                        "<p>Your One-Time Password (OTP) is:</p>" +
                        "<h1 style='letter-spacing:8px;color:#198754;font-size:2.5rem'>" + otp + "</h1>" +
                        "<p style='color:#999;font-size:0.85rem'>This OTP expires in 5 minutes. Do not share it with anyone.</p>" +
                        "</div>",
                "text/html"
        );
        Transport.send(msg);
    }
}
