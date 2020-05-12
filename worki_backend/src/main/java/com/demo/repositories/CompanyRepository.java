package com.demo.repositories;

import java.util.Optional;

import com.demo.model.Company;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.data.mongodb.repository.Query;

public interface CompanyRepository extends MongoRepository<Company, String> {
    @Query(value = "{'email' : ?0}")
    Optional<Company> findCompanyByEmail(String email);
}