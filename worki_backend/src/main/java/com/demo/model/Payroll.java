package com.demo.model;

import java.util.Date;
import java.util.List;

import org.bson.types.ObjectId;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;


@Document(collection = "payroll")
public class Payroll {
    @Id
    private ObjectId id;
    private Date date;
    private String name;
    private int registered;
    private List<Job> jobs;
    private ObjectId eventId;

    public Payroll() {
    }

    public Payroll(Payroll payroll){
        this.id = payroll.id;
        this.date = payroll.date;
        this.name = payroll.name;
        this.registered = payroll.registered;
        this.jobs = payroll.jobs;
        this.eventId = payroll.eventId;
    }

    public Payroll(ObjectId id, Date date, String name, int registered, List<Job> jobs, ObjectId eventId) {
        this.id = id;
        this.date = date;
        this.name = name;
        this.registered = registered;
        this.jobs = jobs;
        this.eventId = eventId;
    }

    public String getId() {
        return this.id.toHexString();
    }

    public void setId(ObjectId id) {
        this.id = id;
    }

    public Date getDate() {
        return this.date;
    }

    public void setDate(Date date) {
        this.date = date;
    }

    public String getName() {
        return this.name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public int getRegistered() {
        return this.registered;
    }

    public void setRegistered(int registered) {
        this.registered = registered;
    }

    public List<Job> getJobs() {
        return this.jobs;
    }

    public void setJobs(List<Job> jobs) {
        this.jobs = jobs;
    }

    public String getEventId() {
        return this.eventId.toHexString();
    }

    public void setEventId(ObjectId eventId) {
        this.eventId = eventId;
    }


    @Override
    public String toString() {
        return "{" +
            " id='" + getId() + "'" +
            ", date='" + getDate() + "'" +
            ", name='" + getName() + "'" +
            ", registered='" + getRegistered() + "'" +
            ", jobs='" + getJobs() + "'" +
            ", eventId='" + getEventId() + "'" +
            "}";
    }





 

}