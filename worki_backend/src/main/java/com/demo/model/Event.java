package com.demo.model;

import java.util.Date;
import java.util.List;

import com.demo.utils.EventType;

import org.bson.types.ObjectId;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;

@Document(collection = "events")
public class Event {
  @Id
  private ObjectId id;
  private String address;
  private String description;
  private int duration;
  private Date finalDate;
  private Date initialDate;
  private double latitude;
  private double longitude;
  private String name;
  private boolean state;
  private int totalJobs;
  private EventType type;
  private ObjectId companyId;
  private String eventPic;
  private List<String> coordinatorsId;

  // Constructors

  public Event() {
  }

  public Event(Event event) {
    this.id = event.id;
    this.address = event.address;
    this.description = event.description;
    this.duration = event.duration;
    this.finalDate = event.finalDate;
    this.initialDate = event.initialDate;
    this.latitude = event.latitude;
    this.longitude = event.longitude;
    this.name = event.name;
    this.state = event.state;
    this.totalJobs = event.totalJobs;
    this.type = event.type;
    this.companyId = event.companyId;
    this.eventPic = event.eventPic;
    this.coordinatorsId = event.coordinatorsId;
  }

  public Event(ObjectId id, String address, String description, int duration, Date finalDate, Date initialDate,
      double latitude, double longitude, String name, boolean state, int totalJobs, EventType type, ObjectId companyId,
      String eventPic, List<String> coordinatorsId) {
    this.id = id;
    this.address = address;
    this.description = description;
    this.duration = duration;
    this.finalDate = finalDate;
    this.initialDate = initialDate;
    this.latitude = latitude;
    this.longitude = longitude;
    this.name = name;
    this.state = state;
    this.totalJobs = totalJobs;
    this.type = type;
    this.companyId = companyId;
    this.eventPic = eventPic;
    this.coordinatorsId = coordinatorsId;
  }

  public String getId() {
    return this.id.toHexString();
  }

  public void setId(ObjectId id) {
    this.id = id;
  }

  public String getAddress() {
    return this.address;
  }

  public void setAddress(String address) {
    this.address = address;
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

  public double getLatitude() {
    return this.latitude;
  }

  public void setLatitude(double latitude) {
    this.latitude = latitude;
  }

  public double getLongitude() {
    return this.longitude;
  }

  public void setLongitude(double longitude) {
    this.longitude = longitude;
  }

  public String getName() {
    return this.name;
  }

  public void setName(String name) {
    this.name = name;
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

  public int getTotalJobs() {
    return this.totalJobs;
  }

  public void setTotalJobs(int totalJobs) {
    this.totalJobs = totalJobs;
  }

  public EventType getType() {
    return this.type;
  }

  public void setType(EventType type) {
    this.type = type;
  }

  public String getCompanyId() {
    return this.companyId.toHexString();
  }

  public void setCompanyId(ObjectId companyId) {
    this.companyId = companyId;
  }

  public String getEventPic() {
    return this.eventPic;
  }

  public void setEventPic(String eventPic) {
    this.eventPic = eventPic;
  }

  public List<String> getCoordinatorsId() {
    return this.coordinatorsId;
  }

  public void setCoordinatorsId(List<String> coordinatorsId) {
    this.coordinatorsId = coordinatorsId;
  }

  public ObjectId getIdObjectId(){
    return this.id;
  }

  @Override
  public String toString() {
    return "{" + " id='" + getId() + "'" + ", address='" + getAddress() + "'" + ", description='" + getDescription()
        + "'" + ", duration='" + getDuration() + "'" + ", finalDate='" + getFinalDate() + "'" + ", initialDate='"
        + getInitialDate() + "'" + ", latitude='" + getLatitude() + "'" + ", longitude='" + getLongitude() + "'"
        + ", name='" + getName() + "'" + ", state='" + isState() + "'" + ", totalJobs='" + getTotalJobs() + "'"
        + ", type='" + getType() + "'" + ", companyId='" + getCompanyId() + "'" + "}";
  }

}