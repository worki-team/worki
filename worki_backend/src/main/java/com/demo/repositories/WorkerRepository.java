package com.demo.repositories;

import java.util.Optional;

import com.demo.model.Worker;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.data.mongodb.repository.Query;

public interface WorkerRepository extends MongoRepository<Worker, String> {
    @Query(value = "{'email' : ?0}")
    Optional<Worker> findWorkerByEmail(String email);
    @Query(value = "{'fireUID' : ?0}")
    Optional<Worker> findWorkerByFireUid(String fireUID);
}