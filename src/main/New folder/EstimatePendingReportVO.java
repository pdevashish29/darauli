package com.springs.serviceNetwork.sales.VO;

public class EstimatePendingReportVO {
	
	
	/*
	 		START
			2016-04-01 10:34:28.0
			12398
			1970.0
			87.600006
			197.0
			2254.6
			lavi sneha
			2008  Acura MDX
			0.0
			0.0
			END
	  finalList[0] = estVo.getCreationTime(); str8ing
	finalList[1] = estVo.getEstimateId(); long
	finalList[2] = laborTotal; float
	finalList[3] = partTotal; float
	finalList[4] = estVo.getTotalTax(); float
	finalList[5] = estVo.getEstimateTotal(); float
	finalList[6] = customerInfo; STring
	finalList[7] = carInfo; string
	finalList[8] = discount; float
	finalList[9] = estVo.getDocId(); float*/
	
		
	
	
	private String creationTime;
	private long estimateId;
	private float laborTotal;
	private float partTotal;
	private float totalTax;
	private float estimateTotal;
	private String customerInfo;
	private float discount;
	private String carInfo;
	private float docId;
	
	public EstimatePendingReportVO() {
	}

	public String getCreationTime() {
		return creationTime;
	}

	public void setCreationTime(String creationTime) {
		this.creationTime = creationTime;
	}

	public long getEstimateId() {
		return estimateId;
	}

	public void setEstimateId(long estimateId) {
		this.estimateId = estimateId;
	}

	public float getLaborTotal() {
		return laborTotal;
	}

	public void setLaborTotal(float laborTotal) {
		this.laborTotal = laborTotal;
	}

	public float getPartTotal() {
		return partTotal;
	}

	public void setPartTotal(float partTotal) {
		this.partTotal = partTotal;
	}

	public float getTotalTax() {
		return totalTax;
	}

	public void setTotalTax(float totalTax) {
		this.totalTax = totalTax;
	}

	public float getEstimateTotal() {
		return estimateTotal;
	}

	public void setEstimateTotal(float estimateTotal) {
		this.estimateTotal = estimateTotal;
	}

	public String getCustomerInfo() {
		return customerInfo;
	}

	public void setCustomerInfo(String customerInfo) {
		this.customerInfo = customerInfo;
	}

	public String getCarInfo() {
		return carInfo;
	}

	public void setCarInfo(String carInfo) {
		this.carInfo = carInfo;
	}

	public float getDiscount() {
		return discount;
	}

	public void setDiscount(float discount) {
		this.discount = discount;
	}

	public float getDocId() {
		return docId;
	}

	public void setDocId(float docId) {
		this.docId = docId;
	}

	@Override
	public String toString() {
		return "EstimatePendingReportVO [creationTime=" + creationTime
				+ ", estimateId=" + estimateId + ", laborTotal=" + laborTotal
				+ ", partTotal=" + partTotal + ", totalTax=" + totalTax
				+ ", estimateTotal=" + estimateTotal + ", customerInfo="
				+ customerInfo + ", discount=" + discount + ", carInfo="
				+ carInfo + ", docId=" + docId + "]";
	}
	
	
}
