package com.movietix.model;

import java.math.BigDecimal;
import java.sql.Timestamp;
import java.util.List;

public class Booking {
    private int id;
    private int userId;
    private int showId;
    private Timestamp bookingDate;
    private BigDecimal totalAmount;
    private String status;

    // Joined / transient fields
    private String movieTitle;
    private String showDate;
    private String showTime;
    private String hall;
    private String userName;
    private String userEmail;
    private String posterUrl;
    private List<String> seatNumbers;

    public Booking() {}

    public int getId()                          { return id; }
    public void setId(int id)                   { this.id = id; }

    public int getUserId()                      { return userId; }
    public void setUserId(int userId)           { this.userId = userId; }

    public int getShowId()                      { return showId; }
    public void setShowId(int showId)           { this.showId = showId; }

    public Timestamp getBookingDate()                       { return bookingDate; }
    public void setBookingDate(Timestamp bookingDate)       { this.bookingDate = bookingDate; }

    public BigDecimal getTotalAmount()                      { return totalAmount; }
    public void setTotalAmount(BigDecimal totalAmount)      { this.totalAmount = totalAmount; }

    public String getStatus()                   { return status; }
    public void setStatus(String status)        { this.status = status; }

    public String getMovieTitle()               { return movieTitle; }
    public void setMovieTitle(String t)         { this.movieTitle = t; }

    public String getShowDate()                 { return showDate; }
    public void setShowDate(String d)           { this.showDate = d; }

    public String getShowTime()                 { return showTime; }
    public void setShowTime(String t)           { this.showTime = t; }

    public String getHall()                     { return hall; }
    public void setHall(String hall)            { this.hall = hall; }

    public String getUserName()                 { return userName; }
    public void setUserName(String n)           { this.userName = n; }

    public String getUserEmail()                { return userEmail; }
    public void setUserEmail(String e)          { this.userEmail = e; }

    public String getPosterUrl()                { return posterUrl; }
    public void setPosterUrl(String url)        { this.posterUrl = url; }

    public List<String> getSeatNumbers()                    { return seatNumbers; }
    public void setSeatNumbers(List<String> seatNumbers)    { this.seatNumbers = seatNumbers; }

    /** Helper: returns "HH:mm" formatted show time — safe for use in EL (showTime is stored as String e.g. "14:30:00") */
    public String getShowTimeShort() {
        if (showTime == null) return "";
        return showTime.length() >= 5 ? showTime.substring(0, 5) : showTime;
    }

    /** Helper: returns showDate without dashes (e.g. "20260720") — safe for use in EL */
    public String getShowDateCompact() {
        if (showDate == null) return "";
        return showDate.replace("-", "");
    }
}
