package com.springs.serviceNetwork.sales.controller;

import java.util.ArrayList;
import java.util.Calendar;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.springs.serviceNetwork.bean.DateUtility;
import com.springs.serviceNetwork.constant.AppConstants;
import com.springs.serviceNetwork.sales.BO.SalesBO;
import com.springs.serviceNetwork.sales.DAO.SalesDAO;
import com.springs.serviceNetwork.sales.VO.DailyCloseSummaryVO;
import com.springs.serviceNetwork.sales.VO.EstimatePendingReportVO;
import com.springs.serviceNetwork.sales.VO.EstimateReportVO;
import com.springs.serviceNetwork.vo.RegistrationVO;

@RestController
public class SalesRestController {
	
	@Autowired
	private SalesBO salesBO;
	
	@Autowired
	private SalesDAO salesDAO;

	@RequestMapping(value="getDailyCloseSummary")
	public DailyCloseSummaryVO getDailyCloseSummary(HttpSession session,@RequestBody Map<String, String> map){
		Calendar calendar = Calendar.getInstance();
			int month = map.get("month")==null || "".equals(map.get("month"))?calendar.get(Calendar.MONTH):Integer.parseInt(map.get("month"));
			int year = (map.get("year")==null || "".equals(map.get("year")))?calendar.get(Calendar.YEAR):Integer.parseInt(map.get("year"));
			String toDate=map.get("toDate"),fromDate=map.get("fromDate");
		if("".equals(map.get("toDate")) || map.get("toDate") == null){
			calendar.set(Calendar.MONTH,month);
			calendar.set(Calendar.YEAR,year);
			toDate = DateUtility.formateDate(calendar.getTime(),"MM/dd/yyyy");
		}
		if("".equals(map.get("fromDate")) || map.get("fromDate") == null){
			fromDate = DateUtility.formateDate(calendar.getTime(),"MM/dd/yyyy");
		}
		DailyCloseSummaryVO vo=new SalesBO().dailyCloseSummaryReport(session, fromDate, toDate, month, year);
		
		return vo;
	}
	
	
	
	
	@RequestMapping("/estimatePendingReportMonthly")
	public EstimateReportVO estimatePendingReportMonthly(HttpServletRequest request, HttpSession session,
			@RequestParam(value = "month", required = false, defaultValue = "-1") int month,
			@RequestParam(value = "year", required = false, defaultValue = "0") int year,
			@RequestParam(value = "quater", required = false , defaultValue = "0")   int quater,
			@RequestParam(value = "fromDate", required = false ) String fromDate,
			@RequestParam(value = "toDate", required = false)   String toDate){
			System.out.println("estimatePendingReportMonthly");
			// year
			// month
			//quater
			// fromDate
			// toDate
			//request.setAttribute("type", 1);
			Calendar calendar=Calendar.getInstance();
			RegistrationVO sessionVO =null;
	   	    if(session != null){
		            sessionVO =(RegistrationVO)session.getAttribute(AppConstants.USER_SESSION_BEAN);
	   	    }
	   	    if(month==-1 && quater==0){
				month=calendar.get(Calendar.MONTH)+1;
	   	    }else if(quater==0){
	   	    	month +=1;
	   	    }
			if(year==0)
				year=calendar.get(Calendar.YEAR);
			
			if(quater !=0){
				if(quater ==1){
					fromDate = "01/01/"+year;
					toDate = "03/31/"+year;
					
				}else if(quater ==2){
					fromDate = "04/01/"+year;
					toDate =  "06/30/"+year;
				}else if(quater ==3){
					fromDate = "07/01/"+year;
					toDate ="09/30/"+year;
				}else {
					fromDate ="10/01/"+year; 
					toDate ="12/31/"+year;
				}
				
			}
			List<Object[]> list=salesBO.estimatePendingReportMonthly(sessionVO.getId(), fromDate, toDate, month, year);
			EstimateReportVO reportVO = new EstimateReportVO();
			reportVO.setEstimateList(list);
		return reportVO;
	}
}
