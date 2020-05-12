package com.demo.model;

import java.util.Date;
import java.util.List;
import java.util.Set;
import org.bson.types.ObjectId;
import org.springframework.data.annotation.Id;

public class User {
  @Id
  private ObjectId id;
  private String email;
  private String password;
  private String city;
  private String gender;
  private String name;
  private Date birthDate;
  private Date creationDate;
  private Date modificationDate;
  private long phone;
  private String profilePic;
  // Security roles
  private Set<String> roles;
  private String fireUID;
  private boolean isNewUser;
  private boolean isActive;
  private List<String> devices;
  

  // Constructors
  public User(){

  }
  
  public User(User user) {
    this.email = user.email;
    this.password = user.password;
    this.city = user.city;
    this.gender = user.gender;
    this.name = user.name;
    this.birthDate = user.birthDate;
    this.creationDate = user.creationDate;
    this.modificationDate = user.modificationDate;
    this.phone = user.phone;
    this.profilePic = user.profilePic;
    this.roles = user.roles;
    this.fireUID = user.fireUID;
    this.isNewUser = user.isNewUser;
    this.isActive = user.isActive;
    this.devices = user.devices;
  }

  public User(ObjectId id, String email, String password, String city, String gender, String name, Date birthDate,
      Date creationDate, Date modificationDate, long phone, String profilePic, String fireUID, 
      boolean isNewUser, boolean isActive, List<String> devices) {
    this.id = id;
    this.email = email;
    this.password = password;
    this.city = city;
    this.gender = gender;
    this.name = name;
    this.birthDate = birthDate;
    this.creationDate = creationDate;
    this.modificationDate = modificationDate;
    this.phone = phone;
    this.profilePic = profilePic;
    this.fireUID = fireUID;
    this.isNewUser = isNewUser;
    this.isActive = isActive;
    this.devices = devices;
  }


  public String getFireUID() {
    return fireUID;
  }

  public void setFireUID(String fireUID) {
    this.fireUID = fireUID;
  }

  public String getId() {
    return id.toHexString();
  }

  public void setId(ObjectId id) {
    this.id = id;
  }

  public String getEmail() {
    return email;
  }

  public void setEmail(String email) {
    this.email = email;
  }

  public String getPassword() {
    return password;
  }

  public void setPassword(String password) {
    this.password = password;
  }

  public String getAddress() {
    return city;
  }

  public void setAddress(String city) {
    this.city = city;
  }

  public String getGender() {
    return gender;
  }

  public void setGender(String gender) {
    this.gender = gender;
  }

  public String getName() {
    return name;
  }

  public void setName(String name) {
    this.name = name;
  }

  public Date getBirthDate() {
    return birthDate;
  }

  public void setBirthDate(Date birthDate) {
    this.birthDate = birthDate;
  }

  public Date getCreationDate() {
    return creationDate;
  }

  public void setCreationDate(Date creationDate) {
    this.creationDate = creationDate;
  }

  public Date getModificationDate() {
    return modificationDate;
  }

  public void setModificationDate(Date modificationDate) {
    this.modificationDate = modificationDate;
  }

  public long getPhone() {
    return phone;
  }

  public void setPhone(long phone) {
    this.phone = phone;
  }

  public String getProfilePic() {
    return profilePic;
  }

  public void setProfilePic(String profilePic) {
    this.profilePic = profilePic;
  }

  public Set<String> getRoles() {
    return roles;
  }

  public void setRoles(Set<String> roles) {
    this.roles = roles;
  }

  public String getCity() {
    return city;
  }

  public void setCity(String city) {
    this.city = city;
  }

  public boolean getIsNewUser(){
    return this.isNewUser;
  }

  public void setIsNewUser(boolean isNewUser){
    this.isNewUser = isNewUser;
  }

  public boolean getIsActive(){
    return this.isActive;
  }

  public void setIsActive(boolean isActive){
    this.isActive = isActive;
  } 

  public List<String> getDevices(){
    return this.devices;
  }

  public void setDevices(List<String> devices){
    this.devices = devices;
  } 

}