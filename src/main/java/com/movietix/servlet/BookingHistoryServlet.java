package com.movietix.servlet;

import com.movietix.dao.BookingDAO;
import com.movietix.model.Booking;
import com.movietix.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

public class BookingHistoryServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            res.sendRedirect(req.getContextPath() + "/login");
            return;
        }
        User user = (User) session.getAttribute("user");
        System.out.println("Logged User ID: " + user.getId());

        List<Booking> bookings = new BookingDAO().getBookingsByUser(user.getId());
        System.out.println("Total bookings found: " + bookings.size());

        // Compute statistics
        int totalBookings = bookings.size();
        int cancelledBookings = 0;
        int upcomingBookings = 0;
        java.time.LocalDate today = java.time.LocalDate.now();

        for (Booking b : bookings) {
            String status = b.getStatus();
            if ("cancelled".equalsIgnoreCase(status) || "rejected".equalsIgnoreCase(status)) {
                cancelledBookings++;
            } else {
                try {
                    java.time.LocalDate showDate = java.time.LocalDate.parse(b.getShowDate());
                    if (!showDate.isBefore(today)) {
                        upcomingBookings++;
                    }
                } catch (Exception e) {
                     // Default fallback if date not parseable
                     upcomingBookings++;
                }
            }
        }

        // Pass success and error messages from session to request
        String successMsg = (String) session.getAttribute("successMsg");
        if (successMsg != null) {
            req.setAttribute("successMsg", successMsg);
            session.removeAttribute("successMsg");
        }
        String errorMsg = (String) session.getAttribute("errorMsg");
        if (errorMsg != null) {
            req.setAttribute("errorMsg", errorMsg);
            session.removeAttribute("errorMsg");
        }

        req.setAttribute("bookings", bookings);
        req.setAttribute("totalBookings", totalBookings);
        req.setAttribute("cancelledBookings", cancelledBookings);
        req.setAttribute("upcomingBookings", upcomingBookings);

        req.getRequestDispatcher("/bookingHistory.jsp").forward(req, res);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            res.sendRedirect(req.getContextPath() + "/login");
            return;
        }
        User user = (User) session.getAttribute("user");
        String action = req.getParameter("action");

        if ("updateProfile".equals(action)) {
            String name = req.getParameter("name");
            String email = req.getParameter("email");
            String password = req.getParameter("password");

            if (name == null || name.trim().isEmpty() || email == null || email.trim().isEmpty()) {
                session.setAttribute("errorMsg", "Name and email are required fields.");
            } else {
                com.movietix.dao.UserDAO userDAO = new com.movietix.dao.UserDAO();
                boolean success = userDAO.updateProfile(user.getId(), name, email, password);
                if (success) {
                    user.setName(name);
                    user.setEmail(email);
                    session.setAttribute("user", user);
                    session.setAttribute("successMsg", "Your profile details have been updated successfully.");
                } else {
                    session.setAttribute("errorMsg", "Failed to update profile. Email might already be registered by another account.");
                }
            }
            res.sendRedirect(req.getContextPath() + "/history?tab=profile");
            return;
        }

        // Default action is cancelBooking
        String bookingIdParam = req.getParameter("bookingId");
        if (bookingIdParam != null) {
            try {
                int bookingId = Integer.parseInt(bookingIdParam);
                BookingDAO dao = new BookingDAO();
                Booking booking = dao.getBookingById(bookingId);
                if (booking != null && (booking.getUserId() == user.getId() || user.isAdmin())) {
                    boolean success = dao.cancelBooking(bookingId);
                    if (success) {
                        session.setAttribute("successMsg", "Lounger booking canceled successfully. Seat allocations are now freed.");
                    } else {
                        session.setAttribute("errorMsg", "Failed to cancel lounge booking.");
                    }
                }
            } catch (NumberFormatException e) {
                e.printStackTrace();
            }
        }
        res.sendRedirect(req.getContextPath() + "/history");
    }
}
