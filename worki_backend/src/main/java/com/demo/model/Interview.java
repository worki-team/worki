package com.demo.model;

import java.sql.Date;

public class Interview {

    public static enum InterviewType {
        CHAT, PRESENTIAL, VIDEOCHAT
    }

    private String background;
    private Date date;
    private String description;
    private String pychologicalTest;
    private String result;
    private InterviewType type;

    public Interview(){

    }

    public Interview(String background, Date date, String description, String pychologicalTest, String result,
            InterviewType type) {
        this.background = background;
        this.date = date;
        this.description = description;
        this.pychologicalTest = pychologicalTest;
        this.result = result;
        this.type = type;
    }

    public String getBackground() {
        return background;
    }

    public void setBackground(String background) {
        this.background = background;
    }

    public Date getDate() {
        return date;
    }

    public void setDate(Date date) {
        this.date = date;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getPychologicalTest() {
        return pychologicalTest;
    }

    public void setPychologicalTest(String pychologicalTest) {
        this.pychologicalTest = pychologicalTest;
    }

    public String getResult() {
        return result;
    }

    public void setResult(String result) {
        this.result = result;
    }

    public InterviewType getType() {
        return type;
    }

    public void setType(InterviewType type) {
        this.type = type;
    }
    
    
    
}