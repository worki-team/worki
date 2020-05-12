package com.demo.model;

import java.util.Date;
import java.util.List;

import org.bson.types.ObjectId;
import org.springframework.data.mongodb.core.mapping.Document;

/**
 * Administrator
 */
@Document(collection = "administrators")
public class Administrator extends User {

    private String companyId;

    public String getCompanyId() {
        return companyId;
    }

    public void setCompanyId(String companyId) {
        this.companyId = companyId;
    }

    public Administrator(){

    };

    public Administrator(ObjectId id, String email, String password, String address, String gender, String name,
            Date birthDate, Date creationDate, Date modificationDate, long phone, String profilePic, String companyId, String fireUID,
            boolean isNewUser, boolean isActive, List<String> devices) {
        super(id, email, password, address, gender, name, birthDate, creationDate, 
        modificationDate, phone, profilePic, fireUID, isNewUser, isActive, devices);
        this.companyId = companyId;
    }

    public Administrator(String companyId) {
        this.companyId = companyId;
    }

    public Administrator(User user, String companyId) {
        super(user);
        this.companyId = companyId;
    }

    

}