package com.pdp.entity;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;

import com.fasterxml.jackson.databind.annotation.JacksonStdImpl;

@Entity
public class UserRole {

	
	@Id
	@GeneratedValue
	private int id;

	
	@ManyToOne
	@JoinColumn(name = "user_id")
	private User user;

	
	
	@ManyToOne
	@JoinColumn(name="role_id")
	private Role role;



	public int getId() {
		return id;
	}



	public void setId(int id) {
		this.id = id;
	}



	public User getUser() {
		return user;
	}



	public void setUser(User user) {
		this.user = user;
	}



	public Role getRole() {
		return role;
	}



	public void setRole(Role role) {
		this.role = role;
	}
	
	
}


