package com.demo.model;

import java.util.Date;
import java.util.List;

import org.bson.types.ObjectId;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;


@Document(collection = "jobs")
public class Job {
    @Id
    private ObjectId id;
    private String description;
    private int duration;
    private String jobPic;
    private String employmentType;
    private Date finalDate;
    private Date initialDate;
    private List<String> functions;
    private String name;
    private String qrCode;
    private float salary;
    private boolean state;
    private ObjectId eventId;
    private ObjectId companyId;
    private List<String> workersId;
    private List<String> registeredIds;
    private int people;
    private PhysicalProfile physicalProfile;

    public Job() {
    }

    public Job(Job job){
        this.id = job.id;
        this.description = job.description;
        this.duration = job.duration;
        this.jobPic = job.jobPic;
        this.employmentType = job.employmentType;
        this.finalDate = job.finalDate;
        this.initialDate = job.initialDate;
        this.functions = job.functions;
        this.name = job.name;
        this.qrCode = job.qrCode;
        this.salary = job.salary;
        this.state = job.state;
        this.eventId = job.eventId;
        this.companyId = job.companyId;
        this.workersId = job.workersId;
        this.registeredIds = job.registeredIds;
        this.people = job.people;
        this.physicalProfile = job.physicalProfile;
    }

    

    public Job(ObjectId id, String description, int duration, String employmentType, Date finalDate, String jobPic,
    Date initialDate, List<String> functions, String name, String qrCode, float salary, boolean state, int people,
    ObjectId eventId, ObjectId companyId, List<String> workersId,  List<String> registeredIds, PhysicalProfile physicalProfile) {
        this.id = id;
        this.description = description;
        this.duration = duration;
        this.jobPic = jobPic;
        this.employmentType = employmentType;
        this.finalDate = finalDate;
        this.initialDate = initialDate;
        this.functions = functions;
        this.name = name;
        this.qrCode = qrCode;
        this.salary = salary;
        this.state = state;
        this.eventId = eventId;
        this.companyId = companyId;
        this.workersId = workersId;
        this.people = people;
        this.physicalProfile = physicalProfile;
        this.registeredIds = registeredIds;
    }

    public String getId() {
        return this.id.toHexString();
    }

    public void setId(ObjectId id) {
        this.id = id;
    }

    public String getDescription() {
        return this.description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public int getDuration() {
        return this.duration;
    }

    public void setDuration(int duration) {
        this.duration = duration;
    }

    public int getPeople() {
        return this.people;
    }

    public void setPeople(int people) {
        this.people = people;
    }

    public String getEmploymentType() {
        return this.employmentType;
    }

    public void setEmploymentType(String employmentType) {
        this.employmentType = employmentType;
    }

    public Date getFinalDate() {
        return this.finalDate;
    }

    public void setFinalDate(Date finalDate) {
        this.finalDate = finalDate;
    }

    public Date getInitialDate() {
        return this.initialDate;
    }

    public void setInitialDate(Date initialDate) {
        this.initialDate = initialDate;
    }

    public List<String> getFunctions() {
        return this.functions;
    }

    public void setFunctions(List<String> functions) {
        this.functions = functions;
    }

    public String getName() {
        return this.name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getQrCode() {
        return this.qrCode;
    }

    public void setQrCode(String qrCode) {
        this.qrCode = qrCode;
    }

    public float getSalary() {
        return this.salary;
    }

    public void setSalary(float salary) {
        this.salary = salary;
    }

    public boolean isState() {
        return this.state;
    }

    public boolean getState() {
        return this.state;
    }

    public void setState(boolean state) {
        this.state = state;
    }

    public String getEventId() {
        return this.eventId.toHexString();
    }

    public void setEventId(ObjectId eventId) {
        this.eventId = eventId;
    }

    public String getCompanyId() {
        return this.companyId.toHexString();
    }

    public void setCompanyId(ObjectId companyId) {
        this.companyId = companyId;
    }

    public String getJobPic() {
        return this.jobPic;
    }

    public void setJobPic(String jobPic) {
        this.jobPic = jobPic;
    }

    public List<String> getworkersId() {
        return this.workersId;
    }

    public void setworkersId(List<String> workersId) {
        this.workersId = workersId;
    }

    public PhysicalProfile getPhysicalProfile() {
        return this.physicalProfile;
    }

    public void setPhysicalProfile(PhysicalProfile physicalProfile) {
        this.physicalProfile = physicalProfile;
    }

    public List<String> getRegisteredIds() {
        return this.registeredIds;
    }

    public void setRegisteredIds(List<String> registeredIds) {
        this.registeredIds = registeredIds;
    }

   

    @Override
    public String toString() {
        return "{" +
            " id='" + getId() + "'" +
            ", description='" + getDescription() + "'" +
            ", duration='" + getDuration() + "'" +
            ", employmentType='" + getEmploymentType() + "'" +
            ", finalDate='" + getFinalDate() + "'" +
            ", initialDate='" + getInitialDate() + "'" +
            ", functions='" + getFunctions() + "'" +
            ", name='" + getName() + "'" +
            ", qrCode='" + getQrCode() + "'" +
            ", salary='" + getSalary() + "'" +
            ", state='" + isState() + "'" +
            ", eventId='" + getEventId() + "'" +
            ", companyId='" + getCompanyId() + "'" +
            ", workersId='" + getworkersId() + "'" +
            ", physicalProfile='" + getPhysicalProfile() + "'" +
            "}";
    }


 

}