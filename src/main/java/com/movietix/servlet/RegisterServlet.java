package com.movietix.servlet;

import com.movietix.dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

public class RegisterServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        req.getRequestDispatcher("/register.jsp").forward(req, res);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        String nameParam     = req.getParameter("name");
        String emailParam    = req.getParameter("email");
        String password      = req.getParameter("password");
        String confirm       = req.getParameter("confirmPassword");

        if (nameParam == null || emailParam == null || password == null || confirm == null) {
            req.setAttribute("error", "All fields are required.");
            req.getRequestDispatcher("/register.jsp").forward(req, res);
            return;
        }

        String name     = nameParam.trim();
        String email    = emailParam.trim();

        // Basic validations
        if (name.isEmpty() || email.isEmpty() || password.isEmpty()) {
            req.setAttribute("error", "All fields are required.");
            req.getRequestDispatcher("/register.jsp").forward(req, res);
            return;
        }
        if (!email.matches("^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}$")) {
            req.setAttribute("error", "Invalid email format.");
            req.getRequestDispatcher("/register.jsp").forward(req, res);
            return;
        }
        if (!password.equals(confirm)) {
            req.setAttribute("error", "Passwords do not match.");
            req.getRequestDispatcher("/register.jsp").forward(req, res);
            return;
        }
        if (password.length() < 6) {
            req.setAttribute("error", "Password must be at least 6 characters.");
            req.getRequestDispatcher("/register.jsp").forward(req, res);
            return;
        }

        UserDAO dao = new UserDAO();
        if (dao.emailExists(email)) {
            req.setAttribute("error", "An account with this email already exists.");
            req.getRequestDispatcher("/register.jsp").forward(req, res);
            return;
        }

        boolean ok = dao.register(name, email, password);
        if (ok) {
            req.setAttribute("success", "Registration successful! Please login.");
            req.getRequestDispatcher("/login.jsp").forward(req, res);
        } else {
            req.setAttribute("error", "Registration failed. Please try again.");
            req.getRequestDispatcher("/register.jsp").forward(req, res);
        }
    }
}
