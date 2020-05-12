package com.demo.model;

import java.util.Date;
import java.util.List;

import org.bson.types.ObjectId;
import org.springframework.data.mongodb.core.mapping.Document;

@Document(collection = "workers")
public class Worker extends User {

    private int age;
    private List<String> allergies;
    private String cardId;
    private String description;
    private String nationality;
    private String maritalStatus;
    private long secondaryPhone;
    private String ocupation;
    private String rh;
    private String availability;
    private List<String> physicalLimitation;
    private List<String> languages;
    private String personalReference;
    private long referencePhone;
    private String referenceEmail;
    private List<String> interests;
    private List<String> aptitudes;
    private boolean isProfileFinished;
    private List<Rating> rating;
    private List<String> reportJobs;
    private double reportSalary;

    //Other classes
    private List<WorkExperience> workExperience;
    private List<Education> education;
    private PhysicalProfile physicalProfile;
    

    public Worker() {
   
    }

    public Worker(ObjectId id, String email, String password, String address, String gender, String name,
            Date birthDate, Date creationDate, Date modificationDate, long phone, int age, List<String> allergies,
            String cardId, String description, String nationality, String maritalStatus,
            long secondaryPhone, String ocupation, String rh, String availability, List<String> physicalLimitation,
            List<String> languages, String personalReference, long referencePhone, String referenceEmail,
            List<String> interests, List<String> aptitudes, String profilePic, String fireUID, boolean isNewUser, 
            boolean isProfileFinished, boolean isActive,  List<Rating> rating, List<WorkExperience> workExperience, 
            List<Education> education, List<String> devices) {
        super(id, email, password, address, gender, name, birthDate, creationDate, modificationDate, phone,
                profilePic, fireUID, isNewUser, isActive, devices);
        this.age = age;
        this.allergies = allergies;
        this.cardId = cardId;
        this.description = description;
        this.nationality = nationality;
        this.maritalStatus = maritalStatus;
        this.secondaryPhone = secondaryPhone;
        this.ocupation = ocupation;
        this.rh = rh;
        this.availability = availability;
        this.physicalLimitation = physicalLimitation;
        this.languages = languages;
        this.personalReference = personalReference;
        this.referencePhone = referencePhone;
        this.referenceEmail = referenceEmail;
        this.interests = interests;
        this.aptitudes = aptitudes;
        this.isProfileFinished = isProfileFinished;
        this.rating = rating;
        this.workExperience = workExperience;
        this.education = education;
    }

    

    public int getAge() {
        return age;
    }

    public void setAge(int age) {
        this.age = age;
    }

    public List<String> getAllergies() {
        return allergies;
    }

    public void setAllergies(List<String> allergies) {
        this.allergies = allergies;
    }

    public String getCardId() {
        return cardId;
    }

    public void setCardId(String cardId) {
        this.cardId = cardId;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getNationality() {
        return nationality;
    }

    public void setNationality(String nationality) {
        this.nationality = nationality;
    }

    public String getMaritalStatus() {
        return maritalStatus;
    }

    public void setMaritalStatus(String maritalStatus) {
        this.maritalStatus = maritalStatus;
    }

    public long getSecondaryPhone() {
        return secondaryPhone;
    }

    public void setSecondaryPhone(long secondaryPhone) {
        this.secondaryPhone = secondaryPhone;
    }

    public String getOcupation() {
        return ocupation;
    }

    public void setOcupation(String ocupation) {
        this.ocupation = ocupation;
    }

    public String getRh() {
        return rh;
    }

    public void setRh(String rh) {
        this.rh = rh;
    }

    public String getAvailability() {
        return availability;
    }

    public void setAvailability(String availability) {
        this.availability = availability;
    }

    public List<String> getPhysicalLimitation() {
        return physicalLimitation;
    }

    public void setPhysicalLimitation(List<String> physicalLimitation) {
        this.physicalLimitation = physicalLimitation;
    }

    public List<String> getLanguages() {
        return languages;
    }

    public void setLanguages(List<String> languages) {
        this.languages = languages;
    }

    public String getPersonalReference() {
        return personalReference;
    }

    public void setPersonalReference(String personalReference) {
        this.personalReference = personalReference;
    }

    public long getReferencePhone() {
        return referencePhone;
    }

    public void setReferencePhone(long referencePhone) {
        this.referencePhone = referencePhone;
    }

    public String getReferenceEmail() {
        return referenceEmail;
    }

    public void setReferenceEmail(String referenceEmail) {
        this.referenceEmail = referenceEmail;
    }

    public List<String> getInterests() {
        return interests;
    }

    public void setInterests(List<String> interests) {
        this.interests = interests;
    }

    public List<String> getAptitudes() {
        return aptitudes;
    }

    public void setAptitudes(List<String> aptitudes) {
        this.aptitudes = aptitudes;
    }

    public List<WorkExperience> getWorkExperience() {
        return workExperience;
    }

    public void setWorkExperience(List<WorkExperience> workExperience) {
        this.workExperience = workExperience;
    }

    public List<Education> getEducation() {
        return education;
    }

    public void setEducation(List<Education> education) {
        this.education = education;
    }

    public PhysicalProfile getPhysicalProfile() {
        return physicalProfile;
    }

    public void setPhysicalProfile(PhysicalProfile physicalProfile) {
        this.physicalProfile = physicalProfile;
    }

    public boolean getIsProfileFinished(){
        return this.isProfileFinished;
    }

    public void setIsProfileFinished(boolean isProfileFinished){
        this.isProfileFinished = isProfileFinished;
    }

    public void setProfileFinished(boolean isProfileFinished) {
        this.isProfileFinished = isProfileFinished;
    }

    public List<Rating> getRating() {
        return rating;
    }

    public void setRating(List<Rating> rating) {
        this.rating = rating;
    }

    public void setReportJobs(List<String> reportJobs){
        this.reportJobs = reportJobs;
    }

    public List<String> getReportJobs(){
        return this.reportJobs;
    }

    public void setReportSalary(double reportSalary){
        this.reportSalary = reportSalary;
    }

    public double getReportSalary(){
        return this.reportSalary;
    }
 
   
}