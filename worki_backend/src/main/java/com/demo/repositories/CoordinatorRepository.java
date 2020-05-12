package com.demo.repositories;

import java.util.List;
import java.util.Optional;
import com.demo.model.Coordinator;

import org.bson.types.ObjectId;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.data.mongodb.repository.Query;

public interface CoordinatorRepository extends MongoRepository<Coordinator, String> {
    @Query(value = "{'email' : ?0}")
    Optional<Coordinator> findCoordinatorByEmail(String email);
    @Query(value = "{'fireUID' : ?0}")
    Optional<Coordinator> findCoordinatorByFireUid(String fireUID);
    List<Coordinator> findByCompanyId(ObjectId companyId);
}