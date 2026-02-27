package com.example.todo.dao;

import com.example.todo.model.Task;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class TaskDAO {
    private final String jdbcUrl = "jdbc:sqlite:todo.db";

    public TaskDAO() throws SQLException {
        init();
    }

    private void init() throws SQLException {
        // Ensure the SQLite JDBC driver is loaded in the webapp classloader
        try {
            Class.forName("org.sqlite.JDBC");
        } catch (ClassNotFoundException e) {
            throw new SQLException("SQLite JDBC driver not found", e);
        }

        try (Connection conn = DriverManager.getConnection(jdbcUrl);
             Statement st = conn.createStatement()) {
            st.executeUpdate(
                "CREATE TABLE IF NOT EXISTS tasks (" +
                "id INTEGER PRIMARY KEY AUTOINCREMENT," +
                "title TEXT NOT NULL," +
                "completed INTEGER NOT NULL DEFAULT 0" +
                ")"
            );
        }
    }

    public List<Task> getAll() throws SQLException {
        List<Task> results = new ArrayList<>();
        String sql = "SELECT id, title, completed FROM tasks ORDER BY id";
        try (Connection conn = DriverManager.getConnection(jdbcUrl);
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                results.add(new Task(
                    rs.getInt("id"),
                    rs.getString("title"),
                    rs.getInt("completed") != 0
                ));
            }
        }
        return results;
    }

    public Task getById(int id) throws SQLException {
        String sql = "SELECT id, title, completed FROM tasks WHERE id = ?";
        try (Connection conn = DriverManager.getConnection(jdbcUrl);
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new Task(
                        rs.getInt("id"),
                        rs.getString("title"),
                        rs.getInt("completed") != 0
                    );
                }
            }
        }
        return null;
    }

    public Task create(Task task) throws SQLException {
        String sql = "INSERT INTO tasks(title, completed) VALUES(?, ?)";
        try (Connection conn = DriverManager.getConnection(jdbcUrl);
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, task.getTitle());
            ps.setInt(2, task.isCompleted() ? 1 : 0);
            int affected = ps.executeUpdate();
            if (affected == 0) return null;
            try (ResultSet keys = ps.getGeneratedKeys()) {
                if (keys.next()) {
                    task.setId(keys.getInt(1));
                    return task;
                }
            }
        }
        return null;
    }

    public boolean update(Task task) throws SQLException {
        String sql = "UPDATE tasks SET title = ?, completed = ? WHERE id = ?";
        try (Connection conn = DriverManager.getConnection(jdbcUrl);
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, task.getTitle());
            ps.setInt(2, task.isCompleted() ? 1 : 0);
            ps.setInt(3, task.getId());
            return ps.executeUpdate() > 0;
        }
    }

    public boolean delete(int id) throws SQLException {
        String sql = "DELETE FROM tasks WHERE id = ?";
        try (Connection conn = DriverManager.getConnection(jdbcUrl);
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        }
    }
}
