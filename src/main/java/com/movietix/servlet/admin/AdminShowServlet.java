package com.movietix.servlet.admin;

import com.movietix.dao.BookingDAO;
import com.movietix.dao.MovieDAO;
import com.movietix.model.Movie;
import com.movietix.model.Show;
import com.movietix.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.math.BigDecimal;
import java.sql.Time;
import java.text.SimpleDateFormat;
import java.util.List;

public class AdminShowServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            res.sendRedirect(req.getContextPath() + "/login");
            return;
        }
        User user = (User) session.getAttribute("user");
        if (!user.isAdmin()) {
            res.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied: Admin role required.");
            return;
        }

        BookingDAO bookingDAO = new BookingDAO();
        MovieDAO movieDAO = new MovieDAO();

        List<Show> shows = bookingDAO.getAllShows();
        List<Movie> movies = movieDAO.getAllMovies();

        // Single-use message flags
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

        req.setAttribute("shows", shows);
        req.setAttribute("movies", movies);
        req.getRequestDispatcher("/admin/manageShows.jsp").forward(req, res);
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
        if (!user.isAdmin()) {
            res.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied.");
            return;
        }

        String action = req.getParameter("action");
        BookingDAO dao = new BookingDAO();

        if ("add".equalsIgnoreCase(action)) {
            try {
                int movieId = Integer.parseInt(req.getParameter("movieId"));
                String dateStr = req.getParameter("showDate"); // YYYY-MM-DD
                String timeStr = req.getParameter("showTime"); // HH:MM (or HH:MM:SS)
                String hall = req.getParameter("hall");
                int totalSeats = Integer.parseInt(req.getParameter("totalSeats"));
                BigDecimal price = new BigDecimal(req.getParameter("price"));

                // Parse Date
                SimpleDateFormat dateFmt = new SimpleDateFormat("yyyy-MM-dd");
                java.util.Date parsedDate = dateFmt.parse(dateStr);
                java.sql.Date sqlDate = new java.sql.Date(parsedDate.getTime());

                // Parse Time
                if (timeStr != null && timeStr.length() == 5) {
                    timeStr += ":00"; // convert HH:MM to HH:MM:SS
                }
                Time sqlTime = Time.valueOf(timeStr);

                Show show = new Show();
                show.setMovieId(movieId);
                show.setShowDate(sqlDate);
                show.setShowTime(sqlTime);
                show.setHall(hall);
                show.setTotalSeats(totalSeats);
                show.setPrice(price);

                boolean success = dao.addShow(show);
                if (success) {
                    session.setAttribute("successMsg",
                            "Show created successfully! 60 seats (A1-F10) have been mapped to this showtime.");
                } else {
                    session.setAttribute("errorMsg", "Failed to add show. Verify database connection.");
                }
            } catch (Exception e) {
                e.printStackTrace();
                session.setAttribute("errorMsg", "Invalid inputs: " + e.getMessage());
            }
        } else if ("delete".equalsIgnoreCase(action)) {
            try {
                int showId = Integer.parseInt(req.getParameter("showId"));
                boolean success = dao.deleteShow(showId);
                if (success) {
                    session.setAttribute("successMsg",
                            "Show deleted successfully along with all mapping seats and dependent booking stubs.");
                } else {
                    session.setAttribute("errorMsg", "Failed to delete show.");
                }
            } catch (Exception e) {
                e.printStackTrace();
                session.setAttribute("errorMsg", "Error deleting show: " + e.getMessage());
            }
        }

        res.sendRedirect(req.getContextPath() + "/admin/shows");
    }
}
