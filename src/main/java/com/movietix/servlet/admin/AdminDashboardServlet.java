package com.movietix.servlet.admin;

import com.movietix.dao.BookingDAO;
import com.movietix.dao.MovieDAO;
import com.movietix.dao.UserDAO;
import com.movietix.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.math.BigDecimal;

public class AdminDashboardServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        if (!isAdmin(req, res)) return;

        BookingDAO bookingDAO = new BookingDAO();
        MovieDAO   movieDAO   = new MovieDAO();
        UserDAO    userDAO    = new UserDAO();

        req.setAttribute("totalMovies",   movieDAO.getTotalMovies());
        req.setAttribute("totalBookings", bookingDAO.getTotalBookings());
        req.setAttribute("totalUsers",    userDAO.getTotalUsers());
        req.setAttribute("totalRevenue",  bookingDAO.getTotalRevenue());
        req.setAttribute("recentBookings", bookingDAO.getAllBookings());

        req.getRequestDispatcher("/admin/dashboard.jsp").forward(req, res);
    }

    static boolean isAdmin(HttpServletRequest req, HttpServletResponse res) throws IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            res.sendRedirect(req.getContextPath() + "/login");
            return false;
        }
        User user = (User) session.getAttribute("user");
        if (!user.isAdmin()) {
            res.sendRedirect(req.getContextPath() + "/home");
            return false;
        }
        return true;
    }
}
