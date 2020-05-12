package com.demo.model;

import com.demo.utils.DegreeType;

public class Education {

    private int duration;
    private String fieldOfStudy;
    private int initialYear;
    private int finalYear;
    private String school;
    private DegreeType type;

    public Education(int duration, String fieldOfStudy, int initialYear, int finalYear, String school,
            DegreeType type) {
        this.duration = duration;
        this.fieldOfStudy = fieldOfStudy;
        this.initialYear = initialYear;
        this.finalYear = finalYear;
        this.school = school;
        this.type = type;
    }

    public Education(){
        
    }

    public int getDuration() {
        return duration;
    }

    public void setDuration(int duration) {
        this.duration = duration;
    }

    public String getFieldOfStudy() {
        return fieldOfStudy;
    }

    public void setFieldOfStudy(String fieldOfStudy) {
        this.fieldOfStudy = fieldOfStudy;
    }

    public int getInitialYear() {
        return initialYear;
    }

    public void setInitialYear(int initialYear) {
        this.initialYear = initialYear;
    }

    public int getFinalYear() {
        return finalYear;
    }

    public void setFinalYear(int finalYear) {
        this.finalYear = finalYear;
    }

    public String getSchool() {
        return school;
    }

    public void setSchool(String school) {
        this.school = school;
    }

    public DegreeType getType() {
        return type;
    }

    public void setType(DegreeType type) {
        this.type = type;
    }

}