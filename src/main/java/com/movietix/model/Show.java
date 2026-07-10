package com.movietix.model;

import java.math.BigDecimal;
import java.sql.Date;
import java.sql.Time;

public class Show {
    private int id;
    private int movieId;
    private Date showDate;
    private Time showTime;
    private String hall;
    private int totalSeats;
    private BigDecimal price;

    // Joined field (from movies table)
    private String movieTitle;

    public Show() {}

    public Show(int id, int movieId, Date showDate, Time showTime,
                String hall, int totalSeats, BigDecimal price) {
        this.id = id;
        this.movieId = movieId;
        this.showDate = showDate;
        this.showTime = showTime;
        this.hall = hall;
        this.totalSeats = totalSeats;
        this.price = price;
    }

    public int getId()                      { return id; }
    public void setId(int id)               { this.id = id; }

    public int getMovieId()                 { return movieId; }
    public void setMovieId(int movieId)     { this.movieId = movieId; }

    public Date getShowDate()               { return showDate; }
    public void setShowDate(Date showDate)  { this.showDate = showDate; }

    public Time getShowTime()               { return showTime; }
    public void setShowTime(Time showTime)  { this.showTime = showTime; }

    public String getHall()                 { return hall; }
    public void setHall(String hall)        { this.hall = hall; }

    public int getTotalSeats()              { return totalSeats; }
    public void setTotalSeats(int s)        { this.totalSeats = s; }

    public BigDecimal getPrice()            { return price; }
    public void setPrice(BigDecimal price)  { this.price = price; }

    public String getMovieTitle()               { return movieTitle; }
    public void setMovieTitle(String t)         { this.movieTitle = t; }

    /** Helper: returns "HH:mm" formatted show time — safe for use in EL expressions */
    public String getShowTimeFormatted() {
        if (showTime == null) return "";
        String s = showTime.toString(); // returns HH:mm:ss
        return s.length() >= 5 ? s.substring(0, 5) : s;
    }
}
