package com.demo.repositories;

import java.util.Date;
import java.util.List;

import com.demo.model.Payroll;

import org.bson.types.ObjectId;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.data.mongodb.repository.Query;

public interface PayrollRepository extends MongoRepository<Payroll, String> {
    
   List<Payroll> findByEventId(ObjectId eventId);
   List<Payroll> findByDate(Date date);

}