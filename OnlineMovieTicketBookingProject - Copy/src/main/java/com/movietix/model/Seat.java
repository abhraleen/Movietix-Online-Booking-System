package com.movietix.model;

public class Seat {
    private int id;
    private int showId;
    private String seatNumber;
    private boolean isBooked;

    public Seat() {}

    public Seat(int id, int showId, String seatNumber, boolean isBooked) {
        this.id = id;
        this.showId = showId;
        this.seatNumber = seatNumber;
        this.isBooked = isBooked;
    }

    public int getId()                      { return id; }
    public void setId(int id)               { this.id = id; }

    public int getShowId()                  { return showId; }
    public void setShowId(int showId)       { this.showId = showId; }

    public String getSeatNumber()               { return seatNumber; }
    public void setSeatNumber(String seatNumber){ this.seatNumber = seatNumber; }

    public boolean isBooked()               { return isBooked; }
    public void setBooked(boolean booked)   { this.isBooked = booked; }
}
