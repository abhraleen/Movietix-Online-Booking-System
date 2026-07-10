package com.movietix.servlet.admin;

import com.movietix.dao.BookingDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

public class AdminBookingServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        if (!AdminDashboardServlet.isAdmin(req, res)) return;
        req.setAttribute("bookings", new BookingDAO().getAllBookings());
        req.getRequestDispatcher("/admin/manageBookings.jsp").forward(req, res);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        if (!AdminDashboardServlet.isAdmin(req, res)) return;
        String bookingIdParam = req.getParameter("bookingId");
        String action = req.getParameter("action");
        if (bookingIdParam != null) {
            try {
                int bookingId = Integer.parseInt(bookingIdParam);
                BookingDAO dao = new BookingDAO();
                if ("approve".equals(action)) {
                    dao.approveBooking(bookingId);
                } else if ("reject".equals(action)) {
                    dao.rejectBooking(bookingId);
                } else {
                    dao.cancelBooking(bookingId);
                }
            } catch (NumberFormatException e) {
                e.printStackTrace();
            }
        }
        res.sendRedirect(req.getContextPath() + "/admin/bookings");
    }
}
