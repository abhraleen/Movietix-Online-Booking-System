
package com.movietix.dao;

import com.movietix.model.Booking;
import com.movietix.model.Seat;
import com.movietix.model.Show;
import java.math.BigDecimal;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class BookingDAO {

    // ─── SHOWS ─────────────────────────────────────────────────────────────

    public List<Show> getShowsByMovie(int movieId) {
        List<Show> list = new ArrayList<>();
        String sql = "SELECT * FROM shows WHERE movie_id = ? ORDER BY show_date, show_time";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, movieId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(mapShow(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public Show getShowById(int showId) {
        String sql = "SELECT s.*, m.title AS movie_title FROM shows s JOIN movies m ON s.movie_id = m.id WHERE s.id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, showId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Show sh = mapShow(rs);
                    sh.setMovieTitle(rs.getString("movie_title"));
                    return sh;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // ─── SEATS ──────────────────────────────────────────────────────────────

    public List<Seat> getSeatsByShow(int showId) {
        List<Seat> list = new ArrayList<>();
        String sql = "SELECT * FROM seats WHERE show_id = ? ORDER BY seat_number";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, showId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(mapSeat(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public int countAvailableSeats(int showId) {
        String sql = "SELECT COUNT(*) FROM seats WHERE show_id = ? AND is_booked = FALSE";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, showId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    // ─── BOOKINGS ───────────────────────────────────────────────────────────

    /**
     * Creates a booking + marks selected seats as booked.
     * Returns the new booking ID, or -1 on failure.
     */
    public int createBooking(int userId, int showId, List<Integer> seatIds, BigDecimal totalAmount) {
        Connection con = null;
        try {
            con = DBConnection.getConnection();
            con.setAutoCommit(false);

            // 0. Prevent duplicate booking: Lock and verify seats
            String checkSql = "SELECT is_booked FROM seats WHERE id = ? FOR UPDATE";
            try (PreparedStatement psCheck = con.prepareStatement(checkSql)) {
                for (int seatId : seatIds) {
                    psCheck.setInt(1, seatId);
                    try (ResultSet rsCheck = psCheck.executeQuery()) {
                        if (!rsCheck.next() || rsCheck.getBoolean("is_booked")) {
                            // Seat not found or already booked! Rollback.
                            con.rollback();
                            return -1;
                        }
                    }
                }
            }

            // 1. Insert booking (corrected syntax error and set initial status to PAYMENT_SUBMITTED)
            String sql1 = "INSERT INTO bookings (user_id, show_id, total_amount, status) VALUES (?, ?, ?, 'PAYMENT_SUBMITTED')";
            int bookingId = -1;
            try (PreparedStatement ps = con.prepareStatement(sql1, Statement.RETURN_GENERATED_KEYS)) {
                ps.setInt(1, userId);
                ps.setInt(2, showId);
                ps.setBigDecimal(3, totalAmount);
                ps.executeUpdate();
                try (ResultSet keys = ps.getGeneratedKeys()) {
                    if (keys.next()) bookingId = keys.getInt(1);
                }
            }

            if (bookingId == -1) { con.rollback(); return -1; }

            // 2. Insert booking_seats + mark seats booked
            String sql2 = "INSERT INTO booking_seats (booking_id, seat_id) VALUES (?, ?)";
            String sql3 = "UPDATE seats SET is_booked = TRUE WHERE id = ?";
            try (PreparedStatement ps2 = con.prepareStatement(sql2);
                 PreparedStatement ps3 = con.prepareStatement(sql3)) {
                for (int seatId : seatIds) {
                    ps2.setInt(1, bookingId);
                    ps2.setInt(2, seatId);
                    ps2.addBatch();
                    ps3.setInt(1, seatId);
                    ps3.addBatch();
                }
                ps2.executeBatch();
                ps3.executeBatch();
            }

            con.commit();
            return bookingId;

        } catch (SQLException e) {
            e.printStackTrace();
            if (con != null) try { con.rollback(); } catch (SQLException ex) { ex.printStackTrace(); }
            return -1;
        } finally {
            if (con != null) {
                try { con.setAutoCommit(true); } catch (SQLException ex) { ex.printStackTrace(); }
                try { con.close(); } catch (SQLException ex) { ex.printStackTrace(); }
            }
        }
    }

    public List<String> getSeatNumbersByIds(List<Integer> seatIds) {
        List<String> list = new ArrayList<>();
        if (seatIds == null || seatIds.isEmpty()) return list;
        StringBuilder sql = new StringBuilder("SELECT seat_number FROM seats WHERE id IN (");
        for (int i = 0; i < seatIds.size(); i++) {
            sql.append("?");
            if (i < seatIds.size() - 1) sql.append(",");
        }
        sql.append(") ORDER BY seat_number");
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql.toString())) {
            for (int i = 0; i < seatIds.size(); i++) {
                ps.setInt(i + 1, seatIds.get(i));
            }
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(rs.getString("seat_number"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    /** All bookings for a given user, with joined movie/show info. */
    public List<Booking> getBookingsByUser(int userId) {
        List<Booking> list = new ArrayList<>();
        String sql = """
            SELECT b.*, m.title AS movie_title, m.poster_url, s.show_date, s.show_time, s.hall
            FROM bookings b
            JOIN shows s ON b.show_id = s.id
            JOIN movies m ON s.movie_id = m.id
            WHERE b.user_id = ?
            ORDER BY b.booking_date DESC
        """;
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Booking bk = mapBooking(rs);
                    bk.setSeatNumbers(getSeatNumbersForBooking(bk.getId()));
                    list.add(bk);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    /** All bookings — for admin. */
    public List<Booking> getAllBookings() {
        List<Booking> list = new ArrayList<>();
        String sql = """
            SELECT b.*, u.name AS user_name, u.email AS user_email, m.title AS movie_title, m.poster_url, s.show_date, s.show_time, s.hall
            FROM bookings b
            JOIN users u ON b.user_id = u.id
            JOIN shows s ON b.show_id = s.id
            JOIN movies m ON s.movie_id = m.id
            ORDER BY b.booking_date DESC
        """;
        try (Connection con = DBConnection.getConnection();
             Statement st = con.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            while (rs.next()) {
                Booking bk = mapBooking(rs);
                bk.setSeatNumbers(getSeatNumbersForBooking(bk.getId()));
                list.add(bk);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public Booking getBookingById(int bookingId) {
        String sql = """
            SELECT b.*, u.name AS user_name, u.email AS user_email, m.title AS movie_title, m.poster_url, s.show_date, s.show_time, s.hall
            FROM bookings b
            JOIN users u ON b.user_id = u.id
            JOIN shows s ON b.show_id = s.id
            JOIN movies m ON s.movie_id = m.id
            WHERE b.id = ?
        """;
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, bookingId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Booking bk = mapBooking(rs);
                    bk.setSeatNumbers(getSeatNumbersForBooking(bk.getId()));
                    return bk;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean cancelBooking(int bookingId) {
        Connection con = null;
        try {
            con = DBConnection.getConnection();
            con.setAutoCommit(false);

            // Free seats
            String sql1 = "UPDATE seats SET is_booked = FALSE WHERE id IN (SELECT seat_id FROM booking_seats WHERE booking_id = ?)";
            try (PreparedStatement ps = con.prepareStatement(sql1)) {
                ps.setInt(1, bookingId);
                ps.executeUpdate();
            }
            // Update status
            String sql2 = "UPDATE bookings SET status = 'cancelled' WHERE id = ?";
            try (PreparedStatement ps = con.prepareStatement(sql2)) {
                ps.setInt(1, bookingId);
                ps.executeUpdate();
            }

            con.commit();
            return true;
        } catch (SQLException e) {
            e.printStackTrace();
            if (con != null) try { con.rollback(); } catch (SQLException ex) { ex.printStackTrace(); }
            return false;
        } finally {
            if (con != null) {
                try { con.setAutoCommit(true); } catch (SQLException ex) { ex.printStackTrace(); }
                try { con.close(); } catch (SQLException ex) { ex.printStackTrace(); }
            }
        }
    }

    public boolean approveBooking(int bookingId) {
        String sql = "UPDATE bookings SET status = 'confirmed' WHERE id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, bookingId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean rejectBooking(int bookingId) {
        Connection con = null;
        try {
            con = DBConnection.getConnection();
            con.setAutoCommit(false);

            // Free seats
            String sql1 = "UPDATE seats SET is_booked = FALSE WHERE id IN (SELECT seat_id FROM booking_seats WHERE booking_id = ?)";
            try (PreparedStatement ps = con.prepareStatement(sql1)) {
                ps.setInt(1, bookingId);
                ps.executeUpdate();
            }
            // Update status
            String sql2 = "UPDATE bookings SET status = 'rejected' WHERE id = ?";
            try (PreparedStatement ps = con.prepareStatement(sql2)) {
                ps.setInt(1, bookingId);
                ps.executeUpdate();
            }

            con.commit();
            return true;
        } catch (SQLException e) {
            e.printStackTrace();
            if (con != null) try { con.rollback(); } catch (SQLException ex) { ex.printStackTrace(); }
            return false;
        } finally {
            if (con != null) {
                try { con.setAutoCommit(true); } catch (SQLException ex) { ex.printStackTrace(); }
                try { con.close(); } catch (SQLException ex) { ex.printStackTrace(); }
            }
        }
    }

    // ─── ADMIN STATS ────────────────────────────────────────────────────────

    public int getTotalBookings() {
        String sql = "SELECT COUNT(*) FROM bookings WHERE status != 'cancelled' AND status != 'rejected'";
        try (Connection con = DBConnection.getConnection();
             Statement st = con.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) { e.printStackTrace(); }
        return 0;
    }

    public BigDecimal getTotalRevenue() {
        String sql = "SELECT COALESCE(SUM(total_amount), 0) FROM bookings WHERE status = 'confirmed'";
        try (Connection con = DBConnection.getConnection();
             Statement st = con.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            if (rs.next()) return rs.getBigDecimal(1);
        } catch (SQLException e) { e.printStackTrace(); }
        return BigDecimal.ZERO;
    }

    // ─── SHOWS MANAGEMENT CRUD ──────────────────────────────────────────────

    public List<Show> getAllShows() {
        List<Show> list = new ArrayList<>();
        String sql = "SELECT s.*, m.title AS movie_title FROM shows s JOIN movies m ON s.movie_id = m.id ORDER BY s.show_date, s.show_time";
        try (Connection con = DBConnection.getConnection();
             Statement st = con.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            while (rs.next()) {
                Show sh = mapShow(rs);
                sh.setMovieTitle(rs.getString("movie_title"));
                list.add(sh);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean addShow(Show show) {
        Connection con = null;
        try {
            con = DBConnection.getConnection();
            con.setAutoCommit(false);

            String sql = "INSERT INTO shows (movie_id, show_date, show_time, hall, total_seats, price) VALUES (?, ?, ?, ?, ?, ?)";
            int showId = -1;
            try (PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
                ps.setInt(1, show.getMovieId());
                ps.setDate(2, new java.sql.Date(show.getShowDate().getTime()));
                ps.setTime(3, show.getShowTime());
                ps.setString(4, show.getHall());
                ps.setInt(5, show.getTotalSeats());
                ps.setBigDecimal(6, show.getPrice());
                ps.executeUpdate();
                try (ResultSet keys = ps.getGeneratedKeys()) {
                    if (keys.next()) {
                        showId = keys.getInt(1);
                    }
                }
            }

            if (showId == -1) {
                con.rollback();
                return false;
            }

            // Generate 60 seats (A1-F10) for this show
            String seatSql = "INSERT INTO seats (show_id, seat_number, is_booked) VALUES (?, ?, FALSE)";
            try (PreparedStatement psSeat = con.prepareStatement(seatSql)) {
                for (int row = 0; row < 6; row++) {
                    char rowChar = (char) ('A' + row);
                    for (int col = 1; col <= 10; col++) {
                        psSeat.setInt(1, showId);
                        psSeat.setString(2, "" + rowChar + col);
                        psSeat.addBatch();
                    }
                }
                psSeat.executeBatch();
            }

            con.commit();
            return true;
        } catch (SQLException e) {
            e.printStackTrace();
            if (con != null) {
                try { con.rollback(); } catch (SQLException ex) { ex.printStackTrace(); }
            }
            return false;
        } finally {
            if (con != null) {
                try { con.setAutoCommit(true); } catch (SQLException ex) { ex.printStackTrace(); }
                try { con.close(); } catch (SQLException ex) { ex.printStackTrace(); }
            }
        }
    }

    public boolean deleteShow(int showId) {
        Connection con = null;
        try {
            con = DBConnection.getConnection();
            con.setAutoCommit(false);

            // 1. Delete booking seats for bookings of this show
            String sql1 = "DELETE FROM booking_seats WHERE booking_id IN (SELECT id FROM bookings WHERE show_id = ?)";
            try (PreparedStatement ps = con.prepareStatement(sql1)) {
                ps.setInt(1, showId);
                ps.executeUpdate();
            }

            // 2. Delete bookings of this show
            String sql2 = "DELETE FROM bookings WHERE show_id = ?";
            try (PreparedStatement ps = con.prepareStatement(sql2)) {
                ps.setInt(1, showId);
                ps.executeUpdate();
            }

            // 3. Delete seats
            String sql3 = "DELETE FROM seats WHERE show_id = ?";
            try (PreparedStatement ps = con.prepareStatement(sql3)) {
                ps.setInt(1, showId);
                ps.executeUpdate();
            }

            // 4. Delete show itself
            String sql4 = "DELETE FROM shows WHERE id = ?";
            try (PreparedStatement ps = con.prepareStatement(sql4)) {
                ps.setInt(1, showId);
                ps.executeUpdate();
            }

            con.commit();
            return true;
        } catch (SQLException e) {
            e.printStackTrace();
            if (con != null) {
                try { con.rollback(); } catch (SQLException ex) { ex.printStackTrace(); }
            }
            return false;
        } finally {
            if (con != null) {
                try { con.setAutoCommit(true); } catch (SQLException ex) { ex.printStackTrace(); }
                try { con.close(); } catch (SQLException ex) { ex.printStackTrace(); }
            }
        }
    }

    // ─── HELPERS ────────────────────────────────────────────────────────────

    private List<String> getSeatNumbersForBooking(int bookingId) {
        List<String> seats = new ArrayList<>();
        String sql = "SELECT s.seat_number FROM seats s JOIN booking_seats bs ON s.id = bs.seat_id WHERE bs.booking_id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, bookingId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) seats.add(rs.getString("seat_number"));
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return seats;
    }

    private Show mapShow(ResultSet rs) throws SQLException {
        Show s = new Show();
        s.setId(rs.getInt("id"));
        s.setMovieId(rs.getInt("movie_id"));
        s.setShowDate(rs.getDate("show_date"));
        s.setShowTime(rs.getTime("show_time"));
        s.setHall(rs.getString("hall"));
        s.setTotalSeats(rs.getInt("total_seats"));
        s.setPrice(rs.getBigDecimal("price"));
        return s;
    }

    private Seat mapSeat(ResultSet rs) throws SQLException {
        return new Seat(rs.getInt("id"), rs.getInt("show_id"),
                rs.getString("seat_number"), rs.getBoolean("is_booked"));
    }

    private Booking mapBooking(ResultSet rs) throws SQLException {
        Booking b = new Booking();
        b.setId(rs.getInt("id"));
        b.setUserId(rs.getInt("user_id"));
        b.setShowId(rs.getInt("show_id"));
        b.setBookingDate(rs.getTimestamp("booking_date"));
        b.setTotalAmount(rs.getBigDecimal("total_amount"));
        b.setStatus(rs.getString("status"));
        b.setMovieTitle(rs.getString("movie_title"));
        b.setShowDate(rs.getString("show_date"));
        b.setShowTime(rs.getString("show_time"));
        b.setHall(rs.getString("hall"));
        try { b.setUserName(rs.getString("user_name")); } catch (SQLException e) {}
        try { b.setUserEmail(rs.getString("user_email")); } catch (SQLException e) {}
        try { b.setPosterUrl(rs.getString("poster_url")); } catch (SQLException e) {}
        return b;
    }
}
