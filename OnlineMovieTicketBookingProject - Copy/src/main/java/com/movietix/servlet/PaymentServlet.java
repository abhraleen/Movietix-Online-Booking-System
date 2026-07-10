package com.movietix.servlet;

import com.movietix.dao.BookingDAO;
import com.movietix.model.Booking;
import com.movietix.model.Show;
import com.movietix.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;

public class PaymentServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            res.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        String action = req.getParameter("action");
        if ("cancel".equals(action)) {
            session.removeAttribute("pendingShowId");
            session.removeAttribute("pendingSeatIds");
            session.removeAttribute("pendingSeatNumbers");
            session.removeAttribute("pendingTotal");
            session.removeAttribute("pendingShow");
            res.sendRedirect(req.getContextPath() + "/home");
            return;
        }

        // Make sure pending booking exists
        if (session.getAttribute("pendingShowId") == null) {
            res.sendRedirect(req.getContextPath() + "/home");
            return;
        }
        req.getRequestDispatcher("/payment.jsp").forward(req, res);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            res.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        User user       = (User)          session.getAttribute("user");
        Integer showId  = (Integer)        session.getAttribute("pendingShowId");
        @SuppressWarnings("unchecked")
        List<Integer> seatIds = (List<Integer>) session.getAttribute("pendingSeatIds");
        BigDecimal total      = (BigDecimal)    session.getAttribute("pendingTotal");

        if (showId == null || seatIds == null || total == null) {
            res.sendRedirect(req.getContextPath() + "/home");
            return;
        }

        BookingDAO dao = new BookingDAO();
        int bookingId = dao.createBooking(user.getId(), showId, seatIds, total);

        if (bookingId > 0) {
            // Clear pending session data
            session.removeAttribute("pendingShowId");
            session.removeAttribute("pendingSeatIds");
            session.removeAttribute("pendingSeatNumbers");
            session.removeAttribute("pendingTotal");
            session.removeAttribute("pendingShow");

            Booking booking = dao.getBookingById(bookingId);
            req.setAttribute("booking", booking);
            req.getRequestDispatcher("/bookingConfirmation.jsp").forward(req, res);
        } else {
            session.setAttribute("error", "Booking failed. One or more seats you selected were already booked. Please choose different seats.");
            res.sendRedirect(req.getContextPath() + "/seats?showId=" + showId);
        }
    }
}
