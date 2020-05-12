package com.demo.model;

import org.bson.types.ObjectId;

/**
 * Rating
 */
public class Rating {

    private ObjectId userId;
    private Integer value;
    private String comment;

    public Rating(ObjectId userId, Integer value,String comment) {
        this.userId = userId;
        this.value = value;
    }

    public Rating(){

    }

    public String getUserId() {
        return userId.toHexString();
    }

    public void setUserId(ObjectId userId) {
        this.userId = userId;
    }

    public Integer getValue() {
        return value;
    }

    public void setValue(Integer rating) {
        this.value = rating;
    }

    public String getComment() {
        return comment;
    }

    public void setComment(String comment) {
        this.comment = comment;
    }
    
}