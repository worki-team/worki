package com.demo.model;

import java.util.Date;
import java.util.List;
import org.bson.types.ObjectId;
import org.springframework.data.mongodb.core.mapping.Document;

@Document(collection = "coordinators")
public class Coordinator extends User {

    private String cardId;
    private String availability;
    private List<String> permissions;
    private ObjectId companyId;


    public Coordinator(){
        
    }
    
    public Coordinator(ObjectId id, String email, String password, String address, String gender, String name,
            Date birthDate, Date creationDate, Date modificationDate, long phone, ObjectId _id2, String cardId,
            String availability, List<String> permissions,String profilePic, String fireUID,
            boolean isNewUser, boolean isActive, List<String> devices ) {
        super(id, email, password, address, gender, name, birthDate, creationDate, 
        modificationDate, phone,profilePic, fireUID, isNewUser, isActive, devices);
        this.cardId = cardId;
        this.availability = availability;
        this.permissions = permissions;
    }


    public String getCardId() {
        return cardId;
    }

    public void setCardId(String cardId) {
        this.cardId = cardId;
    }

    public String getAvailability() {
        return availability;
    }

    public void setAvailability(String availability) {
        this.availability = availability;
    }

    public List<String> getPermissions() {
        return permissions;
    }

    public void setPermissions(List<String> permissions) {
        this.permissions = permissions;
    }
 
    public String getCompanyId() {
        return companyId.toHexString();
    }

    public void setCompanyId(ObjectId companyId) {
        this.companyId = companyId;
    }
}