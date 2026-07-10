package com.movietix.servlet;

import com.movietix.dao.BookingDAO;
import com.movietix.dao.MovieDAO;
import com.movietix.model.Movie;
import com.movietix.model.Show;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

public class MovieDetailServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        String idParam = req.getParameter("id");
        if (idParam == null) { res.sendRedirect(req.getContextPath() + "/home"); return; }

        try {
            int movieId = Integer.parseInt(idParam);
            Movie movie = new MovieDAO().getMovieById(movieId);
            if (movie == null) { res.sendRedirect(req.getContextPath() + "/home"); return; }

            List<Show> shows = new BookingDAO().getShowsByMovie(movieId);
            req.setAttribute("movie", movie);
            req.setAttribute("shows", shows);
            req.getRequestDispatcher("/movieDetail.jsp").forward(req, res);
        } catch (NumberFormatException e) {
            res.sendRedirect(req.getContextPath() + "/home");
        }
    }
}
