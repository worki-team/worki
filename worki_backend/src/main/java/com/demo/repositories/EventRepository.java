package com.demo.repositories;

import java.util.List;

import com.demo.model.Event;

import org.bson.types.ObjectId;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.data.mongodb.repository.Query;

public interface EventRepository extends MongoRepository<Event, String> {
    
   List<Event> findByCompanyId(ObjectId companyId);
   
   List<Event> findByType(String type);
   
   List<Event> findByCoordinatorsIdContaining(String coordinatorId);

   @Query("{'name' : {$regex: ?0}}")
   List<Event> findByName(String name);
}