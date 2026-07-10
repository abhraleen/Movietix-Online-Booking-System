package com.movietix.servlet;

import com.movietix.dao.MovieDAO;
import com.movietix.model.Movie;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

public class HomeServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        List<Movie> movies = new MovieDAO().getAllMovies();
        req.setAttribute("movies", movies);
        req.getRequestDispatcher("/index.jsp").forward(req, res);
    }
}