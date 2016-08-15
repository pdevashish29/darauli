package com.projectm.demo;

import java.text.ParseException;
import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class EstimateRestController {
	private static final Logger logger = LoggerFactory.getLogger(EstimateRestController.class);
	

	
	@Autowired
	private EstimateService estimateService;
	@Autowired
	private EstimateDao  estimateDao;
	
	@RequestMapping("/")
	public ResponseEntity<String> getHello(){
		logger.info("getHello Restconttoller");
		return new ResponseEntity<String>( "HELLO RAM",HttpStatus.OK);
	}
	
	@RequestMapping("/estimatePendingReportMonthly")
	public ResponseEntity<List<Estimate>> getEstimateReport(){
		logger.info("estimateReport Restconttoller");
		return new ResponseEntity<List<Estimate>>(estimateService.getEstimate(), HttpStatus.OK);
	}
	@RequestMapping("/estimatePendingReportByCriteria")
	public ResponseEntity<List<Estimate>> getEstimateReportByCriteria(
			  @RequestParam(value = "fromDate", required = false) String fromDate,
			  @RequestParam(value = "toDate", required = false) String toDate,
			  @RequestParam(value = "month", required = false) Integer month,
			  @RequestParam(value = "year", required = false) Integer year
			) throws ParseException{
		List<Estimate> list=null;
		 list=	estimateDao.getEstimateReportByCriteria(fromDate, toDate, month, year);
		return new ResponseEntity<List<Estimate>>(list, HttpStatus.OK);
	}

}
