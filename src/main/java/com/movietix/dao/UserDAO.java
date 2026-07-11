package com.movietix.dao;

import com.movietix.model.User;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.sql.*;

public class UserDAO {

    /** SHA-256 hex hash */
    public static String hashPassword(String plain) {
        if (plain == null) {
            return "";
        }
        try {
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            byte[] hash = md.digest(plain.getBytes(java.nio.charset.StandardCharsets.UTF_8));
            StringBuilder sb = new StringBuilder();
            for (byte b : hash) sb.append(String.format("%02x", b));
            return sb.toString();
        } catch (NoSuchAlgorithmException e) {
            System.err.println("[UserDAO] NoSuchAlgorithmException: SHA-256 algorithm not supported locally!");
            e.printStackTrace();
            throw new RuntimeException("SHA-256 not available", e);
        }
    }

    /** Register a new user. Returns true on success. */
    public boolean register(String name, String email, String password) {
        String sql = "INSERT INTO users (name, email, password, role) VALUES (?, ?, ?, 'user')";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, name);
            ps.setString(2, email);
            ps.setString(3, hashPassword(password));
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("[UserDAO] SQLException inside register() for email: " + email);
            e.printStackTrace();
            return false;   // duplicate email or other error
        }
    }

    /** Login — returns User object or null. */
    public User login(String email, String password) {
        String sql = "SELECT * FROM users WHERE email = ? AND password = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, email);
            ps.setString(2, hashPassword(password));
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapRow(rs);
            }
        } catch (SQLException e) {
            System.err.println("[UserDAO] SQLException inside login() for email: " + email);
            e.printStackTrace();
        }
        return null;
    }

    /** Check if email already exists. */
    public boolean emailExists(String email) {
        String sql = "SELECT id FROM users WHERE email = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        } catch (SQLException e) {
            System.err.println("[UserDAO] SQLException inside emailExists() for email: " + email);
            e.printStackTrace();
            return false;
        }
    }

    /** Total user count for admin dashboard. */
    public int getTotalUsers() {
        String sql = "SELECT COUNT(*) FROM users WHERE role = 'user'";
        try (Connection con = DBConnection.getConnection();
             Statement st = con.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    /** Update profile details for a user. Returns true on success. */
    public boolean updateProfile(int userId, String name, String email, String newPassword) {
        // First check if email is taken by another user
        String emailCheckSql = "SELECT id FROM users WHERE email = ? AND id != ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement psCheck = con.prepareStatement(emailCheckSql)) {
            psCheck.setString(1, email);
            psCheck.setInt(2, userId);
            try (ResultSet rs = psCheck.executeQuery()) {
                if (rs.next()) {
                    System.err.println("[UserDAO] Email " + email + " is already taken by another user.");
                    return false;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }

        // Proceed to update
        String sql;
        boolean updatePassword = newPassword != null && !newPassword.trim().isEmpty();
        if (updatePassword) {
            sql = "UPDATE users SET name = ?, email = ?, password = ? WHERE id = ?";
        } else {
            sql = "UPDATE users SET name = ?, email = ? WHERE id = ?";
        }

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, name);
            ps.setString(2, email);
            if (updatePassword) {
                ps.setString(3, hashPassword(newPassword));
                ps.setInt(4, userId);
            } else {
                ps.setInt(3, userId);
            }
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    private User mapRow(ResultSet rs) throws SQLException {
        User u = new User();
        u.setId(rs.getInt("id"));
        u.setName(rs.getString("name"));
        u.setEmail(rs.getString("email"));
        u.setPassword(rs.getString("password"));
        u.setRole(rs.getString("role"));
        u.setCreatedAt(rs.getTimestamp("created_at"));
        return u;
    }
}
