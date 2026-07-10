package com.movietix.model;

import java.sql.Timestamp;

public class Movie {
    private int id;
    private String title;
    private String genre;
    private String description;
    private int duration;
    private String language;
    private double rating;
    private String posterUrl;
    private Timestamp createdAt;

    public Movie() {}

    public Movie(int id, String title, String genre, String description,
                 int duration, String language, double rating, String posterUrl, Timestamp createdAt) {
        this.id = id;
        this.title = title;
        this.genre = genre;
        this.description = description;
        this.duration = duration;
        this.language = language;
        this.rating = rating;
        this.posterUrl = posterUrl;
        this.createdAt = createdAt;
    }

    public int getId()                      { return id; }
    public void setId(int id)               { this.id = id; }

    public String getTitle()                { return title; }
    public void setTitle(String title)      { this.title = title; }

    public String getGenre()                { return genre; }
    public void setGenre(String genre)      { this.genre = genre; }

    public String getDescription()                  { return description; }
    public void setDescription(String description)  { this.description = description; }

    public int getDuration()                { return duration; }
    public void setDuration(int duration)   { this.duration = duration; }

    public String getLanguage()                 { return language; }
    public void setLanguage(String language)    { this.language = language; }

    public double getRating()               { return rating; }
    public void setRating(double rating)    { this.rating = rating; }

    public String getPosterUrl()                { return posterUrl; }
    public void setPosterUrl(String posterUrl)  { this.posterUrl = posterUrl; }

    public Timestamp getCreatedAt()                 { return createdAt; }
    public void setCreatedAt(Timestamp createdAt)   { this.createdAt = createdAt; }

    /** Helper: "2h 49m" format */
    public String getDurationFormatted() {
        return (duration / 60) + "h " + (duration % 60) + "m";
    }
}
