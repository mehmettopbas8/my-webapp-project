package com.example.todo.servlet;

import com.example.todo.dao.TaskDAO;
import com.example.todo.model.Task;
import com.google.gson.Gson;
import com.google.gson.JsonSyntaxException;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

public class TasksServlet extends HttpServlet {
    private TaskDAO dao;
    private final Gson gson = new Gson();

    @Override
    public void init() throws ServletException {
        super.init();
        try {
            dao = new TaskDAO();
        } catch (SQLException e) {
            throw new ServletException("Unable to initialize TaskDAO", e);
        }
    }

    private Integer parseId(String pathInfo) {
        if (pathInfo == null || pathInfo.equals("/")) return null;
        String p = pathInfo.startsWith("/") ? pathInfo.substring(1) : pathInfo;
        try {
            return Integer.valueOf(p);
        } catch (NumberFormatException ex) {
            return null;
        }
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String pathInfo = req.getPathInfo();
        try {
            Integer id = parseId(pathInfo);
            resp.setContentType("application/json");
            if (id == null) {
                List<Task> all = dao.getAll();
                resp.getWriter().write(gson.toJson(all));
                resp.setStatus(HttpServletResponse.SC_OK);
            } else {
                Task t = dao.getById(id);
                if (t == null) {
                    resp.setStatus(HttpServletResponse.SC_NOT_FOUND);
                } else {
                    resp.getWriter().write(gson.toJson(t));
                    resp.setStatus(HttpServletResponse.SC_OK);
                }
            }
        } catch (SQLException e) {
            resp.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, e.getMessage());
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        try {
            Task input = gson.fromJson(req.getReader(), Task.class);
            if (input == null || input.getTitle() == null) {
                resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing task title");
                return;
            }
            Task created = dao.create(new Task(input.getTitle(), input.isCompleted()));
            if (created == null) {
                resp.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                return;
            }
            resp.setContentType("application/json");
            resp.setStatus(HttpServletResponse.SC_CREATED);
            resp.getWriter().write(gson.toJson(created));
        } catch (JsonSyntaxException | SQLException e) {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST, e.getMessage());
        }
    }

    @Override
    protected void doPut(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String pathInfo = req.getPathInfo();
        Integer id = parseId(pathInfo);
        if (id == null) {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing id in path");
            return;
        }
        try {
            Task input = gson.fromJson(req.getReader(), Task.class);
            if (input == null) {
                resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid body");
                return;
            }
            input.setId(id);
            boolean ok = dao.update(input);
            if (!ok) {
                resp.setStatus(HttpServletResponse.SC_NOT_FOUND);
            } else {
                resp.setStatus(HttpServletResponse.SC_NO_CONTENT);
            }
        } catch (JsonSyntaxException | SQLException e) {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST, e.getMessage());
        }
    }

    @Override
    protected void doDelete(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String pathInfo = req.getPathInfo();
        Integer id = parseId(pathInfo);
        if (id == null) {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing id in path");
            return;
        }
        try {
            boolean ok = dao.delete(id);
            if (!ok) {
                resp.setStatus(HttpServletResponse.SC_NOT_FOUND);
            } else {
                resp.setStatus(HttpServletResponse.SC_NO_CONTENT);
            }
        } catch (SQLException e) {
            resp.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, e.getMessage());
        }
    }
}
