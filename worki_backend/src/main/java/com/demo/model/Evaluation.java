package com.demo.model;

import java.util.List;

import org.bson.types.ObjectId;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;


public class Evaluation {
    @Id
    private ObjectId id;
    private String comment;
    private String workerId;
    private int value;



 

}