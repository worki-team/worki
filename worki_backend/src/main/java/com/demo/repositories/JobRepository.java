package com.demo.repositories;

import java.util.Date;
import java.util.List;

import com.demo.model.Job;

import org.bson.types.ObjectId;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.data.mongodb.repository.Query;

public interface JobRepository extends MongoRepository<Job, String> {
    List<Job> findAllByOrderByInitialDateDesc();
    
    @Query("{'name' : {$regex: ?0}}")
    List<Job> findByName(String name);
    //@Query("{'name' : {$regex: ?0},'description':{$regex:?1}}")
    @Query("{'$or':[{'name':?0},{'description':?1},{'companyName':?2}]}")
    List<Job> findByName(String name, String description,String companyName);

    List<Job> findByCompanyId(ObjectId companyId);
    List<Job> findByEventId(ObjectId eventId);

    List<Job> findByWorkersIdContaining(String workerId);

    List<Job> findByState(boolean state);
    //@Query("{'functions':{}}")
    List<Job> findByFunctions(String function);

    @Query("{ '$or': [{ 'name': { $regex: ?0, '$options': 'i' }}, { 'description': { '$regex': ?0, '$options': 'i' }}, { 'salary': { '$regex': ?0, '$options': 'i' }} ] }")
    List<Job> findByNameOrDescription(String name);


    

}