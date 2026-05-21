package com.smartgrocery.servlet;

import com.smartgrocery.model.Order;
import com.smartgrocery.model.User;
import com.smartgrocery.service.OrderService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/payment")
public class PaymentServlet extends HttpServlet {

    private OrderService orderService;

    @Override
    public void init() throws ServletException {
        orderService = new OrderService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String orderId = request.getParameter("orderId");
        String amount = request.getParameter("amount");

        if (orderId != null && amount != null) {
            request.setAttribute("orderId", orderId);
            request.setAttribute("amount", amount);
            request.getRequestDispatcher("payment.jsp").forward(request, response);
        } else {
            response.sendRedirect("orders?action=history");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String orderId = request.getParameter("orderId");
        String cardNumber = request.getParameter("cardNumber");
        String expiry = request.getParameter("expiry");
        String cvv = request.getParameter("cvv");
        String cardName = request.getParameter("cardName");
        String amount = request.getParameter("amount");

        if (orderId == null || orderId.isEmpty()) {
            response.sendRedirect("payment.jsp?error=Invalid+Order");
            return;
        }

        String validationError = validateCard(cardNumber, expiry, cvv, cardName);
        if (validationError != null) {
            response.sendRedirect("payment.jsp?error=" + validationError + "&orderId=" + orderId + "&amount=" + amount);
            return;
        }

        Order order = orderService.getOrderById(orderId);
        if (order == null) {
            response.sendRedirect("orders?action=history&error=Order+Not+Found");
            return;
        }

        boolean statusUpdated = orderService.updateOrderStatus(orderId, "CONFIRMED");

        if (statusUpdated) {
            response.sendRedirect("payment-success.jsp?orderId=" + orderId + "&amount=" + amount);
        } else {
            response.sendRedirect("payment.jsp?error=Payment+Failed&orderId=" + orderId + "&amount=" + amount);
        }
    }

    private String validateCard(String cardNumber, String expiry, String cvv, String cardName) {
        String cleanCardNumber = cardNumber != null ? cardNumber.replaceAll("\\s", "") : "";

        if (cleanCardNumber.isEmpty() || !cleanCardNumber.matches("\\d{16}")) {
            return "Invalid+Card+Number";
        }

        if (expiry == null || !expiry.matches("(0[1-9]|1[0-2])/(\\d{2})")) {
            return "Invalid+Expiry+Date";
        }

        if (cvv == null || !cvv.matches("\\d{3}")) {
            return "Invalid+CVV";
        }

        if (cardName == null || cardName.trim().isEmpty()) {
            return "Cardholder+Name+Required";
        }

        return null;
    }
}