package com.movietix.dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.sql.Statement;

public class DBConnection {

    // ── UPDATE THESE TO MATCH YOUR MYSQL SETUP ──
    private static final String URL      = "jdbc:mysql://localhost:3306/movietix?useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true";
    private static final String USERNAME = "root";
    private static final String PASSWORD = "CLASHOFCLANSCOC";   // change to your MySQL password
    // ─────────────────────────────────────────────

    static {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            try (Connection con = DriverManager.getConnection(URL, USERNAME, PASSWORD);
                 Statement st = con.createStatement()) {
                st.executeUpdate("ALTER TABLE bookings MODIFY COLUMN status VARCHAR(50) DEFAULT 'pending'");
            } catch (Exception ex) {
                System.out.println("[DBConnection] Column status migrator: " + ex.getMessage());
            }
        } catch (ClassNotFoundException e) {
            System.err.println("[DBConnection] ERROR: MySQL JDBC Driver (mysql-connector-j) was not found in classpath!");
            e.printStackTrace();
            throw new ExceptionInInitializerError("MySQL JDBC Driver not found: " + e.getMessage());
        }
    }

    public static Connection getConnection() throws SQLException {
        try {
            return DriverManager.getConnection(URL, USERNAME, PASSWORD);
        } catch (SQLException e) {
            System.err.println("[DBConnection] DATABASE CONNECTION FAILURE:");
            System.err.println("  -> URL: " + URL);
            System.err.println("  -> User: " + USERNAME);
            System.err.println("  -> Error: " + e.getMessage());
            System.err.println("  -> SQLState: " + e.getSQLState());
            System.err.println("  -> VendorCode: " + e.getErrorCode());
            System.err.println("  [Troubleshooting Info] Please verify that your local MySQL server is currently running,");
            System.err.println("  the database named 'movietix' has been created using database/schema.sql, and your");
            System.err.println("  MySQL root password matches the configuration in src/main/java/com/movietix/dao/DBConnection.java");
            e.printStackTrace();
            throw e;
        }
    }
}
