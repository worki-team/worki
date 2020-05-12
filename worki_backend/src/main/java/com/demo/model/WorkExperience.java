package com.demo.model;

import java.util.Date;

public class WorkExperience {
    private String city;
    private String company;
    private String description;
    private Date finalYear;
    private Date initialYear;
    private String position;
    
    public WorkExperience(String city, String company, String description, Date finalYear, Date initialYear,
            String position) {
        this.city = city;
        this.company = company;
        this.description = description;
        this.finalYear = finalYear;
        this.initialYear = initialYear;
        this.position = position;
    }
    
    public WorkExperience() {
    }

    public String getCity() {
        return city;
    }

    public void setCity(String city) {
        this.city = city;
    }

    public String getCompany() {
        return company;
    }

    public void setCompany(String company) {
        this.company = company;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public Date getFinalYear() {
        return finalYear;
    }

    public void setFinalYear(Date finalYear) {
        this.finalYear = finalYear;
    }

    public Date getInitialYear() {
        return initialYear;
    }

    public void setInitialYear(Date initialYear) {
        this.initialYear = initialYear;
    }

    public String getPosition() {
        return position;
    }

    public void setPosition(String position) {
        this.position = position;
    }    
}