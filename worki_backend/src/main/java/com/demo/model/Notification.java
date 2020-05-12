package com.demo.model;

import java.util.Map;

public class Notification {
   
    private String to;
    private Map<String,String> notification;
    private Map<String,String> data;


    public Notification() {
    }

    public Notification(String to, Map<String,String> notification, Map<String,String> data) {
        this.to = to;
        this.notification = notification;
        this.data = data;
    }

    public String getTo() {
        return this.to;
    }

    public void setTo(String to) {
        this.to = to;
    }

    public Map<String,String> getNotification() {
        return this.notification;
    }

    public void setNotification(Map<String,String> notification) {
        this.notification = notification;
    }

    public Map<String,String> getData() {
        return this.data;
    }

    public void setData(Map<String,String> data) {
        this.data = data;
    }

    public Notification to(String to) {
        this.to = to;
        return this;
    }

    public Notification notification(Map<String,String> notification) {
        this.notification = notification;
        return this;
    }

    public Notification data(Map<String,String> data) {
        this.data = data;
        return this;
    }

    @Override
    public String toString() {
        return "{" +
            " to='" + getTo() + "'" +
            ", notification='" + getNotification() + "'" +
            ", data='" + getData() + "'" +
            "}";
    }

    
}