package com.demo.repositories;
import java.util.List;
import java.util.Optional;

import com.demo.model.Applicant;

import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.data.mongodb.repository.Query;

public interface ApplicantRepository extends MongoRepository<Applicant, String> {

    @Query("{'jobId':?0}")
    Optional<Applicant> findByJobId(String jobId);

    List<Applicant> findByWorkersIdContaining(String workerId);

}

