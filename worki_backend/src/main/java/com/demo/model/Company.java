package com.demo.model;

import java.util.List;

import org.bson.types.ObjectId;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.index.Indexed;
import org.springframework.data.mongodb.core.mapping.Document;

/**
 * Company
 */
@Document(collection = "company")
public class Company {

    @Id
    private ObjectId id;
    private String name;
    private String description;
    private String address;
    private Double latitude;
    private Double longitude;  
    private String city;
    private long nit;
    private long phone;
    private long secondaryPhone;
    private String category;
    private String profilePic;
    private List<Rating> rating;

    public Company(ObjectId id, String name, String description, String address, Double latitude, Double longitude,
            String city, long nit,long phone, long secondaryPhone, String category, String profilePic, List<Rating> rating) {
        this.id = id;
        this.name = name;
        this.description = description;
        this.address = address;
        this.latitude = latitude;
        this.longitude = longitude;
        this.city = city;
        this.nit = nit;
        this.phone = phone;
        this.secondaryPhone = secondaryPhone;
        this.category = category;
        this.profilePic = profilePic;
        this.rating = rating;
    }

    public String getId() {
        return id.toHexString();
    }

    public void setId(ObjectId id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public Double getLatitude() {
        return latitude;
    }

    public void setLatitude(Double latitude) {
        this.latitude = latitude;
    }

    public Double getLongitude() {
        return longitude;
    }

    public void setLongitude(Double longitude) {
        this.longitude = longitude;
    }

    public String getCity() {
        return city;
    }

    public void setCity(String city) {
        this.city = city;
    }

    public long getNit() {
        return nit;
    }

    public void setNit(long nit) {
        this.nit = nit;
    }

    public long getPhone() {
        return phone;
    }

    public void setPhone(long phone) {
        this.phone = phone;
    }

    public long getSecondaryPhone() {
        return secondaryPhone;
    }

    public void setSecondaryPhone(long secondaryPhone) {
        this.secondaryPhone = secondaryPhone;
    }

    public String getCategory() {
        return category;
    }

    public void setCategory(String category) {
        this.category = category;
    }

    public String getProfilePic() {
        return profilePic;
    }

    public void setProfilePic(String profilePic) {
        this.profilePic = profilePic;
    }

    public List<Rating> getRating(){
        return rating;
    }

    public void setRating(List<Rating> rating){
        this.rating = rating;
    }
}