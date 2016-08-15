package com.projectm.demo;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class EstimateService {

	
	@Autowired
	private EstimateDao estimateDao;
	
	public List<Estimate> getEstimate(){
		return estimateDao.getEstimateReport();
	}
}
