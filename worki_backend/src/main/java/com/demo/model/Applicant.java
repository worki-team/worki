package com.demo.model;

import java.util.Date;
import java.util.List;

import org.bson.types.ObjectId;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;

/**
 * Applicant
 */
@Document(collection = "applicant")

public class Applicant {
    @Id
    private ObjectId id;
    private Date closeDate;
    private int maxWorkers;
    private String jobId;
    private List<String> workersId; 

    public Applicant(ObjectId id, Date closeDate, int maxWorkers,List<String> workersId,String jobId) {
        this.id = id;
        this.closeDate = closeDate;
        this.maxWorkers = maxWorkers;
        this.jobId = jobId;
        this.workersId = workersId;
    }
    
    public Applicant(){

    }

    public String getId() {
        return id.toHexString();
    }

    public void setId(ObjectId id) {
        this.id = id;
    }

    public Date getCloseDate() {
        return closeDate;
    }

    public void setCloseDate(Date closeDate) {
        this.closeDate = closeDate;
    }

    public int getMaxWorkers() {
        return maxWorkers;
    }

    public void setMaxWorkers(int maxWorkers) {
        this.maxWorkers = maxWorkers;
    }

    public String getJobId() {
        return jobId;
    }

    public void setJobId(String jobId) {
        this.jobId = jobId;
    }

    public List<String> getWorkersId() {
        return workersId;
    }

    public void setWorkersId(List<String> workersId) {
        this.workersId = workersId;
    }

    

    

}