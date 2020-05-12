package com.demo.repositories;

import java.util.Optional;

import com.demo.model.Administrator;

import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.data.mongodb.repository.Query;

public interface AdministratorRepository extends MongoRepository<Administrator, String> {
    @Query(value = "{'email' : ?0}")
    Optional<Administrator> findAdministratorByEmail(String email);
    @Query(value = "{'fireUID' : ?0}")
    Optional<Administrator> findAdministratorByFireUid(String fireUID);
    @Query(value = "{'companyId' : ?0}")
    Optional<Administrator> findAdministratorByCompanyId(String companyId);
}