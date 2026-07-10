package com.movietix.servlet.admin;

import com.movietix.dao.MovieDAO;
import com.movietix.model.Movie;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

public class AdminMovieServlet extends HttpServlet {

    private final MovieDAO dao = new MovieDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        if (!AdminDashboardServlet.isAdmin(req, res)) return;

        String action = req.getParameter("action");

        if ("edit".equals(action)) {
            try {
                int id = Integer.parseInt(req.getParameter("id"));
                req.setAttribute("editMovie", dao.getMovieById(id));
            } catch (NumberFormatException e) {
                e.printStackTrace();
            }
        } else if ("delete".equals(action)) {
            try {
                int id = Integer.parseInt(req.getParameter("id"));
                dao.deleteMovie(id);
                res.sendRedirect(req.getContextPath() + "/admin/movies");
                return;
            } catch (NumberFormatException e) {
                e.printStackTrace();
            }
        }

        req.setAttribute("movies", dao.getAllMovies());
        req.getRequestDispatcher("/admin/manageMovies.jsp").forward(req, res);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        if (!AdminDashboardServlet.isAdmin(req, res)) return;
        req.setCharacterEncoding("UTF-8");

        String action = req.getParameter("action");
        Movie m = buildMovieFromRequest(req);

        if ("add".equals(action)) {
            dao.addMovie(m);
        } else if ("edit".equals(action)) {
            try {
                m.setId(Integer.parseInt(req.getParameter("id")));
                dao.updateMovie(m);
            } catch (NumberFormatException e) {
                e.printStackTrace();
            }
        }
        res.sendRedirect(req.getContextPath() + "/admin/movies");
    }

    private Movie buildMovieFromRequest(HttpServletRequest req) {
        Movie m = new Movie();
        m.setTitle(req.getParameter("title"));
        m.setGenre(req.getParameter("genre"));
        m.setDescription(req.getParameter("description"));
        try { m.setDuration(Integer.parseInt(req.getParameter("duration"))); } catch (NumberFormatException e) { m.setDuration(0); }
        m.setLanguage(req.getParameter("language"));
        try { m.setRating(Double.parseDouble(req.getParameter("rating"))); } catch (NumberFormatException e) { m.setRating(0); }
        m.setPosterUrl(req.getParameter("posterUrl"));
        return m;
    }
}
