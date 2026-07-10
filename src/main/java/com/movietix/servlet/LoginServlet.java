package com.movietix.servlet;

import com.movietix.dao.UserDAO;
import com.movietix.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

public class LoginServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        // If already logged in, redirect
        HttpSession session = req.getSession(false);
        if (session != null && session.getAttribute("user") != null) {
            User u = (User) session.getAttribute("user");
            res.sendRedirect(u.isAdmin() ? req.getContextPath() + "/admin/dashboard"
                                         : req.getContextPath() + "/home");
            return;
        }
        req.getRequestDispatcher("/login.jsp").forward(req, res);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        String emailParam = req.getParameter("email");
        String password   = req.getParameter("password");

        if (emailParam == null || password == null || emailParam.trim().isEmpty() || password.isEmpty()) {
            req.setAttribute("error", "Email and password are required.");
            req.getRequestDispatcher("/login.jsp").forward(req, res);
            return;
        }

        String email = emailParam.trim();

        UserDAO dao = new UserDAO();
        User user = dao.login(email, password);

        if (user != null) {
            HttpSession session = req.getSession(true);
            session.setAttribute("user", user);
            session.setMaxInactiveInterval(30 * 60);

            if (user.isAdmin()) {
                res.sendRedirect(req.getContextPath() + "/admin/dashboard");
            } else {
                res.sendRedirect(req.getContextPath() + "/home");
            }
        } else {
            req.setAttribute("error", "Invalid email or password. Please try again.");
            req.getRequestDispatcher("/login.jsp").forward(req, res);
        }
    }
}
