package com.projectm.demo;

import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.GregorianCalendar;

import org.hibernate.criterion.Expression;

public class Test {

	
	public static void main(String[] args) throws ParseException {
		

		/*Calendar cal = new GregorianCalendar(2013, 1, 0);
		Date date = cal.getTime();
		DateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		System.out.println("Date : " + sdf.format(date));
		*/
		
		/*String date ="08/15/2016";
		SimpleDateFormat dateFormat = new SimpleDateFormat("MM/dd/yyyy");
		Date convertedDate = dateFormat.parse(date);
		Calendar c = Calendar.getInstance();
		c.setTime(convertedDate);*/
		SimpleDateFormat sdf = new SimpleDateFormat("MM/dd/yyyy");
		Calendar c = new GregorianCalendar(2016, 5, 0);
		Date frmtedToDate= sdf.parse(sdf.format(c.getTime()));
		c.set(Calendar.DAY_OF_MONTH, c.getActualMinimum(Calendar.DAY_OF_MONTH));
		Date frmtedFromDate =sdf.parse(sdf.format(c.getTime()));
		
		System.out.println(sdf.format(c.getTime()));
		System.out.println(frmtedToDate);
	}
}
