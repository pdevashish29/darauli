package com.projectm.demo;

import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.Table;
@Entity
@Table(name="estimate")
public class Estimate {
	
	@Id
	@GeneratedValue
	@Column(name="estimate_id")
	private int estimate_id;
	@Column(name="name" ,length=20)
	private String name;
	@Column(name="labor_charge", length=20)
	private float labor_charge;
	@Column(name="part_charge",length=20)
	private float part_charge;
	@Column(name="service_tax",length=20)
	private float service_tax;
	@Column(name="discount",length=20)
	private float discount;
	@Column(name="estimate_date")
	private Date estimate_date;
	private float total;
	
	public void setTotal(float total) {
		this.total = total;
	}
	public float getTotal() {
		return total;
	}
	public Estimate() {
		// TODO Auto-generated constructor stub
	}


	public int getEstimate_id() {
		return estimate_id;
	}


	public void setEstimate_id(int estimate_id) {
		this.estimate_id = estimate_id;
	}


	public String getName() {
		return name;
	}


	public void setName(String name) {
		this.name = name;
	}


	public float getLabor_charge() {
		return labor_charge;
	}


	public void setLabor_charge(float labor_charge) {
		this.labor_charge = labor_charge;
	}


	public float getPart_charge() {
		return part_charge;
	}


	public void setPart_charge(float part_charge) {
		this.part_charge = part_charge;
	}


	public float getService_tax() {
		return service_tax;
	}


	public void setService_tax(float service_tax) {
		this.service_tax = service_tax;
	}


	public float getDiscount() {
		return discount;
	}


	public void setDiscount(float discount) {
		this.discount = discount;
	}


	public Date getEstimate_date() {
		return estimate_date;
	}


	public void setEstimate_date(Date estimate_date) {
		this.estimate_date = estimate_date;
	}
	
	
	

}
