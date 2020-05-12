package com.demo.repositories;



import java.util.Optional;

import com.demo.model.User;

import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.data.mongodb.repository.Query;

public interface UserRepository extends MongoRepository<User, String> {
    @Query(value = "{'email' : ?0}")
    Optional<User> findUserByEmail(String email);
    User findUserByFireUID(String fireUID);
}