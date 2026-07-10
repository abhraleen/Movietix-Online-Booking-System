package com.movietix.servlet;

import com.movietix.dao.BookingDAO;
import com.movietix.model.Show;
import com.movietix.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

public class BookingServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");

        // Auth check
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            res.sendRedirect(req.getContextPath() + "/login");
            return;
        }
        User user = (User) session.getAttribute("user");

        String showIdParam = req.getParameter("showId");
        String[] seatIdParams = req.getParameterValues("seatIds");

        if (showIdParam == null || seatIdParams == null || seatIdParams.length == 0) {
            res.sendRedirect(req.getContextPath() + "/home");
            return;
        }

        try {
            int showId = Integer.parseInt(showIdParam);
            BookingDAO dao = new BookingDAO();
            Show show = dao.getShowById(showId);
            if (show == null) { res.sendRedirect(req.getContextPath() + "/home"); return; }

            List<Integer> seatIds = new ArrayList<>();
            for (String s : seatIdParams) seatIds.add(Integer.parseInt(s));

            List<String> seatNumbers = dao.getSeatNumbersByIds(seatIds);
            BigDecimal total = show.getPrice().multiply(BigDecimal.valueOf(seatIds.size()));

            // Store pending info in session for payment page
            session.setAttribute("pendingShowId",    showId);
            session.setAttribute("pendingSeatIds",   seatIds);
            session.setAttribute("pendingSeatNumbers", seatNumbers);
            session.setAttribute("pendingTotal",     total);
            session.setAttribute("pendingShow",      show);

            res.sendRedirect(req.getContextPath() + "/payment");

        } catch (NumberFormatException e) {
            res.sendRedirect(req.getContextPath() + "/home");
        }
    }
}
