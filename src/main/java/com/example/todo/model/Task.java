package com.example.todo.model;

public class Task {
    private int id;
    private String title;
    private boolean completed;

    // No-arg constructor for frameworks (Gson, etc.)
    public Task() {
    }

    // Constructor used when creating a new task (id assigned by DB)
    public Task(String title, boolean completed) {
        this.title = title;
        this.completed = completed;
    }

    // Full constructor
    public Task(int id, String title, boolean completed) {
        this.id = id;
        this.title = title;
        this.completed = completed;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public boolean isCompleted() {
        return completed;
    }

    public void setCompleted(boolean completed) {
        this.completed = completed;
    }

    @Override
    public String toString() {
        return "Task{" +
                "id=" + id +
                ", title='" + title + '\'' +
                ", completed=" + completed +
                '}';
    }
}
