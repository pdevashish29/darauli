package com.pdp.repository;

import org.springframework.data.jpa.repository.JpaRepository;

import com.pdp.entity.User;

public interface UserRepository extends JpaRepository<User, Integer>{

}
