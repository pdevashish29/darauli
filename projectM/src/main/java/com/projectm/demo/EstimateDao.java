package com.projectm.demo;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.GregorianCalendar;
import java.util.List;


import org.hibernate.criterion.DetachedCriteria;
import org.hibernate.criterion.Expression;
import org.hibernate.criterion.Order;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.orm.hibernate4.HibernateTemplate;
import org.springframework.stereotype.Repository;

@Repository
public class EstimateDao {

	
	@Autowired
	private HibernateTemplate htemplate;
	 
	public List<Estimate> getEstimateReport(){
		//List<Estimate> list=	(List<Estimate>) htemplate.findByCriteria(DetachedCriteria.forClass(Estimate.class), 1, 10);
		List<Estimate> list=	(List<Estimate>) htemplate.find("from Estimate");
	return list;
	}
	
	
	public List<Estimate> getEstimateReportByCriteria(String fromDate , String toDate, Integer month, Integer year) throws ParseException{
				
				DetachedCriteria criteria = DetachedCriteria.forClass(Estimate.class);
				 SimpleDateFormat sdf = new SimpleDateFormat("MM/dd/yyyy");
			if(fromDate!= null && toDate!=null ){
				criteria.add(Expression.ge("estimate_date", sdf.parse(fromDate)));
				criteria.add(Expression.le("estimate_date", sdf.parse(toDate)));
				}
			
			else if(fromDate==null && toDate== null && month>-1 && year>0){
				Calendar c = new GregorianCalendar(year, month, 0);
				String  frmtedToDate= sdf.format(c.getTime());
				
				
				c.set(Calendar.DAY_OF_MONTH, c.getActualMinimum(Calendar.DAY_OF_MONTH));
				String  frmtedFromDate =sdf.format(c.getTime());
				
				criteria.add(Expression.ge("estimate_date", sdf.parse(frmtedFromDate)));
				criteria.add(Expression.le("estimate_date", sdf.parse(frmtedToDate)));
				System.out.println(frmtedFromDate);
				System.out.println(frmtedToDate);
			}
			
			
			criteria.addOrder(Order.asc("estimate_date"));
			List<Estimate> list = (List<Estimate>) htemplate.findByCriteria(criteria);
		
		return list;
	}
	
}
