<%@ page language="java" import="java.util.*" pageEncoding="ISO-8859-1"%>
<%@page import="com.dp.order.pojo.OrderVO"%>
<%@page import="com.dp.order.pojo.OrderItemVO"%>
<%@page import="com.dp.order.pojo.TransactionVO"%>
<%@page import="org.odhc.rainbow.bean.BusinessInformationVO"%>
<%@page import="java.text.DecimalFormat"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="org.odhc.rainbow.util.DateUtility" %>
<%@page import="java.math.BigDecimal"%>
<%@page import="com.dp.order.pojo.ItemTypeVO"%>
<%@page import="com.estimate.dao.EstimateReportsDao"%>
<%@page import="com.google.checkout.sdk.domain.RoundingMode"%>
<%@page import="java.math.*"%>
<%@page import="com.dp.util.DPUtility"%>
<%@page import="org.odhc.rainbow.dao.GenericDao"%>
<%@page import="org.odhc.rainbow.constants.AppConstants"%>
<%
		String path = request.getContextPath();
		List<Object[]> map = request.getAttribute("estimateMap")==null ? null : (List<Object[]>)request.getAttribute("estimateMap");
		Map<Object,String> vehicleName=(Map<Object,String>)request.getAttribute("vehicleName");
		Calendar calendar = Calendar.getInstance();
		int currentYear=calendar.get(Calendar.YEAR);
		int month = request.getParameter("month")==null || "".equals(request.getParameter("month"))?calendar.get(Calendar.MONTH):Integer.parseInt(request.getParameter("month"));
		int year = (request.getParameter("year")==null || "".equals(request.getParameter("year")))?currentYear:Integer.parseInt(request.getParameter("year"));
		SimpleDateFormat dateFormat =new SimpleDateFormat("MMM dd , yyyy"); 
		int temp=-1111;
		int  total_partprice=0;
		int total_labour=0;
		boolean flag=false;
		String orderDate="";
		DecimalFormat decimalFormat = new DecimalFormat("#,####0.00"); 
		decimalFormat.setGroupingSize(3);
		new DecimalFormat();
		float totalSaleSum=0;
		float totalLabourSum=0;
		float totalPartsSum=0;
		float totalTaxSum=0;
		float totalDiscountSum=0;
		float partDiscountSum=0;
		float laborDiscountSum=0;
		String firstDate=null;
		
		String toDate =request.getParameter("toDate");
		String fromDate =request.getParameter("fromDate");
		int quarter=((Integer)(request.getAttribute("quater")==null?"":request.getAttribute("quater"))).intValue();
		String toDateCheck =(String)(request.getAttribute("toDate"));
		int type=((Integer)request.getAttribute("type")).intValue();
		String req = request.getParameter("req");
%>

<!DOCTYPE HTML >
<html>
  <head>
  	
  	<title><%=AppConstants.APP_NAME_TITLE%></title>
  	<LINK REL="SHORTCUT ICON" HREF="<%=path%>/favicon.ico">
    <link rel="stylesheet" href="<%=path %>/css/main.css" type="text/css" />
	<link rel="stylesheet" href="<%=path%>/upm/style.css" />
	<link rel="stylesheet" href="<%=path%>/css/myForm.css">
	<link rel="stylesheet" type="text/css" href="<%=path %>/css/jquery.ui.all.css"/>
	<link rel="stylesheet" href="<%=path%>/css/estimateUI.css" type="text/css" />
	<link type="text/css" rel="stylesheet" href="<%=path %>/estimateUI/setting/ShopliteSettings.css"/>
	<link rel="stylesheet" href="<%=path%>/css/estimateUI.css" type="text/css" /> 
	<link type="text/css" rel="stylesheet" href="<%=path %>/estimateUI/setting/ShopliteSettings.css"/>
	<script type="text/javascript" src="<%=path%>/scripts/jquery.js"></script>
	<script type="text/javascript" src="<%=path%>/scripts/jquery.ui.datepicker.js"></script>
	<script type="text/javascript" src="<%=path%>/scripts/jquery.ui.core.js"></script>
	<script type="text/javascript" src="<%=path %>/js/kendo.all.min.js"></script>
	<script type="text/javascript" src="<%=path%>/scripts/estimateUI.js"></script> 
	<script type="text/javascript" src="<%=path %>/js/graps.js"></script>  
	
	

		<style type="text/css">
		
		
		.mainTableW {
		    border: 2px solid #ECECEC;
		    border-radius: 10px 10px 10px 10px;
		    margin-bottom: 7px;
		    margin-left: 3px;
		    margin-top: 10px;
		    width: 99%;
		    padding-right: 5px;
    	}
		#searchDiv{
			background-color: #e6eeff;
			padding: 3px;
		}
		#searchDiv a{
			cursor: pointer;
		}
		#searchDiv li{
			display: inline-block;
			padding: 1px;
			border: 1px solid #7FAAFF;
			margin-left: 4px;
			font-size: 12px;
		}
		.selected{
			background-color: #8DAFE2;
		}
		div.closeMe {			
			background-image: url("<%= path%>/images/close.gif");
			background-position: center bottom;
			background-repeat:no-repeat;
			cursor: pointer;
			width:30px;
			height:30px;
			margin:5px;
			position: absolute;
			right:-20px;  
			top: -20px;	
		}
		.backFrame {
			position:fixed;
			display:none;		
			z-index : 1000;		
			filter : Alpha(Opacity=50);
			opacity : 0.5;
			background:#000;
			top: 0;
			left: 0;
		}	
		div.closeMe:hover {
			background-image:url("<%= path%>/images/close.gif");
			background-position: center top;
			background-repeat: no-repeat;
			cursor: pointer;
			width: 30px;
			height: 30px;
			margin: 5px;
			position: absolute;
			right: -20px;  
			top: -20px;	
		}	
		.dataDiv{
			position:absolute;
			display:none;			
			z-index : 2000;
			margin: 0 auto;
			left: 0;
			top: 0;
			right:0;
			background-color: #fff;
			-moz-box-shadow:0px 0px 5px 5px #fff;
			-webkit-box-shadow:0px 0px 5px 5px #fff;
			border:0px #55AAFF outset;  
	 		border-radius:5px 5px 5px 5px;	
		  	padding:5px;
		}	
		
		@media print {
				#header,#print,IMG,#perpage{
					display: none;
				}
				#estimateTd{
					font-size: 11;
					
				}
				#estimateDiv{
					border:10px;
					margin-top: 50px;
					margin-left: 10px;
				}
				#text{
					
					margin-left: 2px;
					text-align: left;
				}
				#date,#invoice,#labor,#parts,#tax,#lbrdis,#prtdis,#dis,#sale{
					font-size:15px;
					font-weight: bold;
					color: black;
					font-style: normal;
				}
				th{
					border:1px;
				}
		}
		text{
			fill:white;
		}
		.dataDiv text{
			fill:black;
		}	
		.bigGraph table th{
			font-weight: normal;
			border: 1px solid #ccc;
			background-color: #3E99EE;
			color:white;
		}
		.bigGraph table td{
			font-size: 13px;
			border: 1px solid #ccc;
			padding-right:4px;
		}
		.bigGraph table{
			line-height:23px;
			border-collapse: collapse;
		}
		.more{
			cursor:pointer;
		}
		.more:hover{
			background:#ff950d ;
			color:#fff;
		}
				
	</style>
	<script type="text/javascript">
		function showSelected(month){
			$("li a").each(function (){
				if($(this).attr("id")==month){
					$(this).parent().addClass("selected");
					$(this).css("color","#fff");
				}
				else{
					$(this).parent().removeClass("selected");	
				}
			});
		}
		
		function showTrace(month){
				var year = $("#year").val();
				<%if(req==null || "".equals(req) || "null".equalsIgnoreCase(req)){ %>
					window.location.href ="<%=path%>/estimatePendingReportMonthly.action?month="+month+"&year="+year;	
				<%}else{%>
					var urlValue = "<%=path%>/estimatePendingReportMonthly.action?req=reports&month="+month+"&year="+year;
					estimateReportByFilter(urlValue);		
				<%}%>
			}
		function showTraceByYear(){
			var year = $("#year").val();
			var month = $("#searchDiv li.selected a").attr("id");
			<%if(req==null || "".equals(req) || "null".equalsIgnoreCase(req)){ %>
				window.location.href ="<%=path%>/estimatePendingReportMonthly.action?month="+<%=month%>+"&year="+year;
			<%}else{%>
				var urlValue = "<%=path%>/estimatePendingReportMonthly.action?req=reports&month="+<%=month%>+"&year="+year;
				estimateReportByFilter(urlValue);		
			<%}%>
		}
		function showTraceByQuater(quater,that){
			var year = $("#year").val();
			<%if(req==null || "".equals(req) || "null".equalsIgnoreCase(req)){ %>
				window.location.href ="<%=path%>/estimatePendingReportMonthly.action?quater="+quater+"&year="+year;
			<%}else{%>
				var urlValue = "<%=path%>/estimatePendingReportMonthly.action?req=reports&quater="+quater+"&year="+year;
				estimateReportByFilter(urlValue);		
			<%}%>
		}
		$('#report').live('click',function(){
			$('#qtr').slideToggle();
		});
		
		$(".more").live('click',function(){
			var show = $(this).attr("show");
			$("#qtr").hide();
			$("#searchDateRange").hide();
			$("#monthArea").hide();
			$("#"+show).css({'display':'inline-block'});
			$("#moreDiv").hide();
		});
		function searchRecords(){
			var fromDate = $("#fromDate").val();
			var toDate = $("#toDate").val();
			if(fromDate!='' && toDate !=''){
				<%if(req==null || "".equals(req) || "null".equalsIgnoreCase(req)){ %>
					window.location.href ="<%=path%>/estimatePendingReportMonthly.action?toDate="+toDate+"&fromDate="+fromDate;
				<%}else{%>
					var urlValue = "<%=path%>/estimatePendingReportMonthly.action?req=reports&toDate="+toDate+"&fromDate="+fromDate;
					estimateReportByFilter(urlValue);		
				<%}%>
			}
		}
		function showMore(){
			if($("#moreDiv").is(":visible")){
				$("#moreDiv").hide();
			}else{
				$("#moreDiv").show();
			}	
		}		
		$(document).ready(function(){
			var total=$("#totalSaleid").text();
			//var total1="Total Revenue :    "+total;
			$("#totalRevenue").text(total);
		});
		$(document).ready(function(){
			var quater=<%=quarter%>
			if(quater!=""){
				$('#qtr').show();
			$("div input").each(function (){
				if($(this).attr("lang")==quater){
					$(this).css("color","#FFF");
					$(this).css("background-color","#3E99EE");
				}
				
			});	
			
			}
		});
		
		
		function printSales(){
			var oldPage = document.body.innerHTML;
			var printDiv=$("#estimateTd").html();
			$(document.body).html("<html><head><title></title></head><body>"+printDiv+"</body></html>"); 
   			window.print();
    		$(document.body).html(oldPage);
		};
		
		function exportToExcel(month){
		
			var year = $("#year").val();
			var fromDate = $("#fromDate").val();
			var toDate = $("#toDate").val();
			var month=$("#month").val();
			var quarter=<%=quarter%>
			var type=<%=type%>;
			<%request.setAttribute("exportBytype",type);%>
			//alert("hello  "+type+"  "+month+"  "+year+"  "+toDate);
			if(type==1)
				window.location.href ="<%=path%>/estimatePendingExportToExcel.action?month="+month+"&year="+year+"&exportType="+type;
			else if(type==2)
				window.location.href ="<%=path%>/estimatePendingExportToExcel.action?quater="+quarter+"&year="+year+"&exportType="+type;
			else if(type==3)
				window.location.href ="<%=path%>/estimatePendingExportToExcel.action?toDate="+toDate+"&fromDate="+fromDate+"&exportType="+type;
		}
          function loadGraph(){
          	createPartNumberChart(${estimateData},"estimateGraph",${max},0);
			createPartNumberChart(${salesData},"salesGraph",${max},0);
			createPartNumberChart(${purchaseData},"purchaseGraph",${max},0);
          }
		function estimateReportByFilter(urlValue){
			$("#reportsDetailMenu").html("<div><img style='position: absolute; margin:0px auto;left:0px;right:0px;height:50px;margin-top: 60px;' src='<%=path %>/images/loading.gif'></div>")
        	$.ajax({
				url:urlValue,
				dataType:'html',
				success:function(response){
					$("#reportsDetailMenu").html(response);
						loadGraph();
				},error:function(){
					$("#reportsDetailMenu").hide();
					alert("Service is not available");
				}
			});	
		}
	</script>
  </head>
  
  <body class="pgCenter" onload="loadGraph();">
  <%if(req==null || "".equals(req) || "null".equalsIgnoreCase(req)){ %>
  	<div>
			<jsp:include page="/estimateUI/estimateMainHeader.jsp"></jsp:include>
		</div>
		<div id="wrapper" style="min-height: 870px;">
			<div id="mainContent" style="min-height: 800px;padding:0px">
			<%} %>
				<div class="mainDiv">
					<div style="border-color: 1px solid red;"></div>
						<div class="mainContent font" align="center">
							<span id='processing' style='display:none;position:absolute;margin-top:170px;margin-left:125px;' ><img src ='<%=path %>/estimateUI/images/Loading3.gif' style='height:100px;width:100px;margin-left:300px;margin-top:150px;'></span>	
							<jsp:include page="/estimateUI/graps.jsp">
								<jsp:param value="100" name="totalCustomer"/>
								<jsp:param value="500" name="totalVehicle"/>
							</jsp:include>
	<div style="margin-bottom: 50px " class="mainReport">					
		<table border="0" cellspacing="0" cellpadding="0" class="mainTableW" style="padding-bottom: 10px;">
			<tr>
				<td colspan="2">
					<table cellpadding="0" cellspacing="0" style="width: 100%;" class="tableHeader">
						<tr>
							<td class="messageHeader" style='text-align:left;' nowrap="nowrap">Estimate: Monthly Report </td><td style="text-align: right;"><%if(req!=null && !"null".equals(req) && "reports".equalsIgnoreCase(req)){ %><span onclick="backToMainReport()" style="padding:8px;background:#fff;color: #222;cursor: pointer;font-size: 13px; border-radius: 2px;">Back</span><%}else{ %><span style="font-size: 16px;color:white;margin-right:10px;cursor: pointer;" onclick="homePage();">Back</span><%} %></td>		    									
						</tr>
					</table>	
				</td>
			</tr>
			
		    <tr>
	    		<td style="width: 75%;" rowspan="2" valign="top">
					<table width="100%" border="0" cellspacing="0">  
					
				  	  <tr style="background-color: #E6EEFF;">	
							<td style="text-align:left;">
								<div id="searchDiv" style="margin-top: 10px;">
									<div style="display: inline;margin-left: 4px;font-size: 13.5px;font-weight: bold;float:left;margin-top:5px;">Year&nbsp;
										<select name="year" id="year" onchange="showTraceByYear()" style="width: 60px;">
											<option></option>
											<%for(int i = year-5 ;i <= year+5;i++){ %>
												<option value="<%=i %>" <%if(year==i){ %>selected="selected" <%} %>><%=i %></option>
											<%} %>		
										</select> 
									
									
									</div>
									<div style="display:inline-block">
									<ul id="monthArea" style="<% if(month>0 && quarter==0 && (fromDate==null || toDate==null) ){ %>display:block;<% }else{%>display:none;<%} %> margin-top: 2px;margin-bottom: 0px;">	
										<li style="width: 40px"><a id="0" onclick="showTrace('0')"><font size="3.5px" style="padding-left: 3;font-weight: bold;">Jan</font></a></li>
										<li style="width: 40px"><a id="1" onclick="showTrace('1')"><font size="3.5px" style="padding-left: 3;font-weight: bold;">Feb</font></a></li>
										<li style="width: 40px"><a id="2" onclick="showTrace('2')"><font size="3.5px" style="padding-left: 3;font-weight: bold;">Mar</font></a></li>
										<li style="width: 40px"><a id="3" onclick="showTrace('3')"><font size="3.5px" style="padding-left: 3;font-weight: bold;">Apr</font></a></li>
										<li style="width: 40px"><a id="4" onclick="showTrace('4')"><font size="3.5px" style="padding-left: 3;font-weight: bold;">May</font></a></li>
										<li style="width: 40px" ><a id="5" onclick="showTrace('5')"><font size="3.5px" style="padding-left: 3;font-weight: bold;">Jun</font></a></li>
										<li style="width: 40px"><a id="6" onclick="showTrace('6')"><font size="3.5px" style="padding-left: 3;font-weight: bold;">Jul</font></a></li>
										<li style="width: 40px"><a id="7" onclick="showTrace('7')"><font size="3.5px" style="padding-left: 3;font-weight: bold;">Aug</font></a></li>
										<li style="width: 40px"><a id="8" onclick="showTrace('8')"><font size="3.5px" style="padding-left: 3;font-weight: bold;">Sep</font></a></li>
										<li style="width: 40px"><a id="9" onclick="showTrace('9')"><font size="3.5px" style="padding-left: 3;font-weight: bold;">Oct</font></a></li>
										<li style="width: 40px" ><a id="10" onclick="showTrace('10')"><font size="3.5px" style="padding-left: 3;font-weight: bold;">Nov</font></a></li>
										<li style="width: 40px"><a id="11" onclick="showTrace('11')"><font size="3.5px" style="padding-left: 3;font-weight: bold;">Dec</font></a></li>
									</ul>
									</div>
									<div id="qtr" style="<%if(quarter ==0){ %>display:none;<%}else{ %>display:inline-block;<%} %>">
										<input type="button"  name="Q1" id="quaterly" style="background-color: #ededed;height: 33px;border-color: cornflowerblue;border-radius: 4px;width: 90px;margin-left: 7px;padding-left: 2px;padding-right: 2px;float: left;color:black;font-weight: bold;cursor: pointer;" lang="1" onclick="showTraceByQuater(1,this);" value="Q1: Jan-Mar"/>
										<input type="button"  name="Q2" id="quaterly" style="background-color: #ededed;height: 33px;border-color: cornflowerblue;border-radius: 4px;width: 90px;margin-left: 5px;padding-left: 2px;padding-right: 2px;float: left;color: black;font-weight: bold;cursor: pointer;" lang="2" onclick="showTraceByQuater(2,this);" value="Q2: Apr-Jun"/>
										<input type="button"  name="Q3" id="quaterly" style="background-color: #ededed;height: 33px;border-color: cornflowerblue;border-radius: 4px;width: 90px;margin-left: 5px;padding-left: 2px;padding-right: 2px;float: left;color: black;font-weight: bold;cursor: pointer;" lang="3" onclick="showTraceByQuater(3,this);" value="Q3: Jul-Sep"/>
										<input type="button"  name="Q4" id="quaterly" style="width: 93px;background-color: #ededed;height: 33px;border-color: cornflowerblue;border-radius: 4px;width: 90px;margin-left: 5px;padding-left: 2px;padding-right: 2px;float: left;color: black;font-weight: bold;cursor: pointer;" lang="4" onclick="showTraceByQuater(4,this);" value="Q4: Oct-Dec"/>
									</div>
									<div id="searchDateRange" style="<%if(fromDate==null || toDate==null){ %>display:none;<%} else{ %>display:inline-block;<%} %>">
						  			<script>$(function() {$( "#fromDate" ).datepicker({ minDate: "", maxDate: "", changeMonth: true,changeYear: true });});</script>
											<span style="margin-top:6px;margin-left:3px;font-size: 13.5px;background-color: #E6EEFF;color: #000;height: 24px; font-weight: bold;float:left;" >From</span>
											<input type="text" placeholder="mm/dd/yyyy" name="fromDate" style="margin-top:2px;margin-left:10px;height: 24px;margin-bottom: 10px;float:left;" id="fromDate" value="<%= fromDate==null ? "" :fromDate %>" readonly="readonly"/>
											<span style="margin-top:6px;margin-left:3px;font-size: 13.5px;background-color:#E6EEFF;color: #000;height: 24px;padding-right: 7px;padding-left: 7px;padding-top:2px;font-weight: bold;float:left;">To  </span>
											<script>$(function() {$( "#toDate" ).datepicker({ minDate: "", maxDate: "", changeMonth: true,changeYear: true });});</script>
											<input type="text" placeholder="mm/dd/yyyy" name="toDate" id="toDate" style="margin-top:2px;margin-left:5px;idth: 90px;height: 24px;float:left;" value="<%= toDate==null ? "" :toDate %>" readonly="readonly"/>
						  			<span><input type="button" onclick="searchRecords()" style="margin-left: 10px;height: 24px;margin-bottom: 10px;float:left;margin-top:4px;" class="btn" value="Search" /></span>
						  			
						  		 	</div>
									<div style="display:inline-block;vertical-align:top;margin-top:4px;">
										<span title="More..." onClick="showMore()" style="cursor:pointer;background: #fff;color:#499bea;padding:0px 7px;font-weight:bold;font-size:18px;margin-left:10px;border:1px solid #499bea;margin-top:-20px;">+</span>
										<div id="moreDiv" style="z-index:1;display:none;background:#fff;color:#222;border:1px solid #ccc;position:absolute;width:215px;margin-top:17px;">
											<div  style="border:10px solid #fff;height:10px;position:absolute;border-color:transparent transparent #fff transparent;margin-left: 18px;margin-top: -28px;"></div>
											<div show="monthArea" class="more" style="border-bottom:1px solid #ccc;height:20px;padding:10px;font-size:15px;">Month</div>
											<div show="qtr" class="more" style="border-bottom:1px solid #ccc;height:20px;padding:10px;font-size:15px;">Quarter</div>
											<div show="searchDateRange" class="more" style="border-bottom:1px solid #ccc;height:20px;padding:10px;font-size:15px;">Search by date range</div>
											<div onclick="exportToExcel();" class="more" style="border-bottom:1px solid #ccc;height:20px;padding:10px;font-size:15px;">Export</div>
											<div onclick="printSales();" class="more" style="border-bottom:1px solid #ccc;height:20px;padding:10px;font-size:15px;">Print</div>
										</div>
									</div>
									<input type="hidden" name="month" id="month" value="<%=month %>"/>
									<div style="float: left; margin-top: 5px;">
									<!-- <span><input type="button" style=" margin-left: 10px;height: 24px;margin-bottom: 10px;margin-top: -3px; float:left;" class="btn" value="Yearly" onclick="showAnalyticReport(this);"/></span> -->
									<span style="display:none;" ><input type="button"  style=" margin-left: 10px;height: 24px;margin-bottom: 10px;margin-top: -3px; float:left;" class="btn" value="Export" /></span>
									</div>
									<div id="totalRevenue" style="float: right;font-weight: bold;margin-top: 2px; margin-right: 5px;font-size: 14.5;"></div>
								</div>
								
							</td>
							
				  	  </tr>
				  	  <tr style="background-color: #E6EEFF;">
				  	  	<td>&nbsp;</td>
				  	  </tr>
				  	
					   <tr style="background-color: #E6EEFF;margin-bottom:5px;">
				  		<td >
				  			
						</td>
					 </tr>
				     <tr>
				  		<td id="estimateTd">
				  		<div id="estimateDiv">
							<table width="100%" border="0" cellspacing="0" id="table1" class="sortable" >
								<thead >
								  <tr> 
									<th width="9%" nowrap="nowrap" ><h3 style="font-size: 12px"> Date</h3></th>
									<th width="7%" nowrap="nowrap" style="text-align: right;"><h3 style="font-size: 12px">Estimate#</h3></th>
									<th width="7%" nowrap="nowrap" style="text-align: right;"><h3 style="font-size: 12px">Doc#</h3></th>
									<th width="12%" nowrap="nowrap" style="text-align: right;"><h3 style="font-size: 12px">Customer</h3></th>
									<!-- <th width="8%" nowrap="nowrap" style="text-align: right;"><h3 style="font-size: 12px">Car</h3></th> -->
									<th width="9%" nowrap="nowrap" style="text-align:right" ><h3 style="font-size: 12px">Labor($)</h3></th>
									<th width="9%" nowrap="nowrap" style="text-align:right"><h3 style="font-size: 12px">Parts($)</h3></th>
									<th width="8%" nowrap="nowrap" style="text-align:right"><h3 style="font-size: 12px">Sales Tax($)</h3></th>
									<!-- <th width="8%" nowrap="nowrap" style="text-align:right" ><h3 style="font-size: 12px">Labor Dis($)</h3></th>
									<th width="8%" nowrap="nowrap" style="text-align:right" ><h3 style="font-size: 12px">Parts Dis($)</h3></th>
									 --><th width="10%" nowrap="nowrap" style="text-align:right"><h3 style="font-size: 12px">Total Discount($)</h3></th>
									<th width="10%" nowrap="nowrap" style="text-align:right"><h3 style="font-size: 12px">Total Sale($)</h3></th>
									
								  </tr>
							  </thead>
							  <tbody id="oddrows">
							 	  
								<%
									boolean recordFlag = true;
								if(map==null || map.isEmpty()) {
									recordFlag = false;
									%>
								<tr>
								  <td colspan="11" style="background: #ffffd3; text-align: center; color: #990000;font-size: 12px;"><B>No Record Found.</B></td>
								</tr>
								<%}else{ %>	
								<%for(Object[] obj :map)
								{
										totalLabourSum +=(Float)obj[2];
										totalPartsSum +=(Float)obj[3];
										totalTaxSum +=(Float)obj[4];
										totalDiscountSum +=(Float)obj[8];
										totalSaleSum += (Float)obj[5];
										
										
								%>
									<tr style="font-size: 11px;"> 
										<td style="vertical-align: top;padding-left: 5px;font-size: 12;"><%=dateFormat.format(obj[0]) %> </td>
										<td style="padding-left: 2px; text-align: right;font-size: 12;"><%=obj[1] %> </td>
										<td style="padding-left: 2px; text-align: right;font-size: 12;"><%=obj[9] %> </td>
										<td style="padding-left: 2px; text-align: right;font-size: 12;"><%=obj[6]%></br><%=obj[7] %></td>
										<!-- <td style="padding-left: 2px; text-align: right;font-size: 12;"></td>-->
										<td style="text-align: right;padding-left: 4px;vertical-align: top;font-size: 12;"><%if(obj[2]==null){ %>0<%}else{	%>
										
										<%=decimalFormat.format(obj[2]) %>
										<%}%>
										</td>
										<td style="text-align: right;padding-left: 4px;vertical-align: top;font-size: 12;"><%if(obj[3]==null){ %>0<%}else{
										%>
										<%=decimalFormat.format(obj[3]) %>

										<%}%>
										</td>
										<td style="text-align: right;padding-left: 4px;vertical-align: top;font-size: 12;"><%=decimalFormat.format(obj[4]) %></td>
										<td style="text-align: right;padding-left: 4px;vertical-align: top;font-size: 12;"><%if(obj[5]==null){ %>0.00<%}else{%>
										<%=decimalFormat.format(obj[8]) %><%}%>
										</td>
										<td style="text-align: right;padding-left: 4px;vertical-align: top;font-size: 12;"><%if(obj[5]==null){ %>0.00<%}else{%>
										<%=decimalFormat.format(obj[5]) %><%} %></td>
									</tr>
									
							
								<%	
								}
								}
								 %>
										 
							  </tbody>
							  	<%if(recordFlag){ %>
							  	<tr>
							  	    <td  style="text-align: right;font-weight: bold;font-size: 12px;"> &nbsp;</td>   
								 	<td colspan="3" style="text-align: right;font-weight: bold; font-size: 12px;">Month Total&nbsp;</td>
								 	
									<td  style="text-align: right;font-weight: bold;font-size: 12px;"> $<%=decimalFormat.format(totalLabourSum) %></td>
									<td  style="text-align: right;font-weight: bold;font-size: 12px;"> $<%=decimalFormat.format(totalPartsSum) %></td>
									<td  style="text-align: right;font-weight: bold;font-size: 12px;"> $<%=decimalFormat.format(totalTaxSum) %></td>
									<!--<td  style="text-align: right;font-weight: bold;font-size: 12px;"> $<%//=decimalFormat.format(laborDiscountSum) %></td>
									<td  style="text-align: right;font-weight: bold;font-size: 12px;"> $<%//=decimalFormat.format(partDiscountSum) %></td>
									 --><td  style="text-align: right;font-weight: bold;font-size: 12px;"> $<%=decimalFormat.format(totalDiscountSum) %></td>
									<td id="totalSaleid" style="text-align: right;font-weight: bold;font-size: 12px;"> $<%=decimalFormat.format(totalSaleSum) %></td>
								</tr>
								  <tr>
								  	<td id="bottomRow" colspan="11" style="background: #ebebe4; height: 27px;font-size: 11px;">
										<div style="display:inline;" id="controls">
											<div id="perpage" style="margin-left: 9px;">
												<select onChange="sorter.size(this.value)">
													<option value="5">5</option>
													<option value="10" >10</option>
													<option value="20" selected="selected">20</option>
												</select>
												<span>Entries Per Page</span>
											</div><!-- EOF PREPAGE -->
											<div id="navigation">
												<img src="<%=path%>/upm/images/first.gif" alt="First Page" onClick="sorter.move(-1,true)" />
												<img src="<%=path%>/upm/images/previous.gif" alt="Previous" onClick="sorter.move(-1)" />
												<img src="<%=path%>/upm/images/next.gif" alt="Next" onClick="sorter.move(1)" />
												<img src="<%=path%>/upm/images/last.gif" alt="Last Page" onClick="sorter.move(1,true)" />
											</div><!-- EOF NAVIGATION -->
											<div id="text">
												Displaying Page 
												<b>&nbsp;<span id="currentpage"></span>&nbsp;</b> 
												of <b><span id="pagelimit"></span></b>
											</div><!-- EOF TEXT -->
										</div><!-- EOF CONTROLS -->
									</td>
								</tr>
								<%} %>
							</table>
							</div>
						</td>
					 </tr>	
		   		  </table>
   			  </td>
  			</tr>
		</table>
		
		</div>
		<div class="backFrame"></div>
		<div class="dataDiv">
			<div class="closeMe">&nbsp;</div>
			<div class="bigGraph" style=""></div>
		</div>
		</div>
		</div>
	<%if(req==null || "".equals(req) || "null".equalsIgnoreCase(req)){ %>	
	</div>
			<div style="position: relative;width: 100%;bottom: 0px;">
					<jsp:include page="/estimateUI/estimateMainFooter.jsp"></jsp:include>	
			</div>
		</div>
	<%} %>
		
 </body>    
<%if(recordFlag){ %>
<script type="text/javascript" src="<%=path%>/upm/scriptDesc.js"></script>
<script type="text/javascript">
	var sorter = new TINY.table.sorter("sorter");
	sorter.head = "head";
	sorter.asc = "asc";
	sorter.desc = "desc";
	sorter.even = "evenrow";
	sorter.odd = "oddrow";
	sorter.evensel = "evenselected";
	sorter.oddsel = "oddselected";
	sorter.paginate = true;
	sorter.currentid = "currentpage";
	sorter.limitid = "pagelimit";
	sorter.init("table1",0);
	sorter.size(20);
</script>
<%} %>
<script type="text/javascript">
	showSelected('<%= month%>');
</script>
	
</html>
