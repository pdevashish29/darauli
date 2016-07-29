<%@ page language="java" import="java.util.*" pageEncoding="ISO-8859-1"%>
<%@page import="java.text.SimpleDateFormat"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
String laborSheet = request.getAttribute("laborSheet") != null ? (String) request.getAttribute("laborSheet") : null;
String monthYear = request.getAttribute("monthYear") != null ? (String) request.getAttribute("monthYear") : null;
String endDate = request.getAttribute("endDate") != null ? (String) request.getAttribute("endDate") : null;
Calendar now = Calendar.getInstance();
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<base href="<%=basePath%>">
<meta http-equiv="pragma" content="no-cache">
<meta http-equiv="cache-control" content="no-cache">
<meta http-equiv="expires" content="0">
<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
<meta http-equiv="description" content="This is my page">
<script type="text/javascript" src="${pageContext.request.contextPath }/scripts/bsn.AutoSuggest_2.1.3_compOrginal.js"></script>
<link type="text/css" href="${pageContext.request.contextPath }/css/autosuggest_inquisitor.css" rel="stylesheet" />
<script src="${pageContext.request.contextPath }/scripts/jquery-1.11.2.min.js" type="text/javascript"></script>
<script src="${pageContext.request.contextPath }/bootstrap-3.3.2-dist/js/bootstrap.min.js" type="text/javascript"></script>
<script src="<%=path %>/bootstrap-3.3.2-dist/datepicker/js/bootstrap-datepicker.min.js" type="text/javascript"></script>
<link href="${pageContext.request.contextPath }/bootstrap-3.3.2-dist/css/bootstrap.min.css" rel="stylesheet" type="text/css" />
<link href="<%=path %>/bootstrap-3.3.2-dist/datepicker/css/bootstrap-datepicker.min.css" rel="stylesheet" type="text/css" />

<script type="text/javascript">
   <%String month11=monthYear.split(" ")[0];
   String year11 =monthYear.split(" ")[2];
   String date=month11+" "+year11;%>
   
   
    function getExcelData(){
    <%--  var laborSheet=<%=laborSheet%>; --%>
      $('#exportHid').val(JSON.stringify(laborList));
      var month = '<%=monthYear.split(" ")[0]%>';
			var year = '<%=monthYear.split(" ")[2]%>';
			var reqForMonth = month+' '+year;
	  $('#reqForMonth').val(reqForMonth);		
		var from = $('.fromDate').val();
		var to = $('.toDate').val();
	  $('#reqForMonthFrom').val(from);
	  $('#reqForMonthTo').val(to);
       return true;
    }
   
 

    var laborSheet = <%=laborSheet%>;
    console.log(laborSheet);
	var monthsArr = ["Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"];
	$(function(){
	    $("#fromDate").datepicker({
					autoclose: true,
				    minViewMode: 0,
				    format: 'M dd, yyyy',
				    endDate: new Date()
				}).change(function(){
					$('.postBtn').addClass('disabled');
					$('#toDate').val('');
					if ($('#toDate').data("datepicker")) {
						$('#toDate').datepicker('remove');
					}
					var date = new Date($('#fromDate').val());
					var lastDay = new Date(date.getFullYear(), date.getMonth() + 1, 0);
					$("#toDate").datepicker({
						autoclose: true,
						format: 'M dd, yyyy',
						orientation: "right auto",
						startDate: date,
						endDate: lastDay
					});
				});
				generateMonths();
				printSheet();
			}); 
   function printSheet(){

				var html ="";
				var html1="";
				if(laborSheet != null){
				  
					$(laborSheet["laborList"]).each(function(){
						html+="<tr>"+
				        "<td id='"+this.parts+"style='cursor:pointer;' title='View Detail'><span style='float:left;'>"
				        +this.tech+"</span></td>"
				        +"<td><span style='float:right;'>"+this.totalHr+"</span></td>"
				        +"<td><span style='float:right;'>"+this.day+"</span></td>"
				     
						"</tr>";
						
					});
					html1+="<tr><th colspan='14' style='text-align:center;></th></tr>";
				} else {
					html+="<tr><th colspan='14' style='text-align:center;'>No Record Found</th></tr>";
				}
					$('.table tbody').append(html);	
					$('.table tfoot').append(html1);
   }
   function generateMonths(){
				var html = "";
				<%if(endDate!=null){ %>
					var month = "<%=monthYear.split(" ")[0]%>";
					//var year = "<%=monthYear.split(" ")[2]%>";
				 <%}else{%>	
					var month = "<%=monthYear.split(" ")[0]%>";
				 <%}%>
				 var year = "<%=now.get(Calendar.YEAR)%>";
				 var monthname=monthsArr["<%=now.get(Calendar.MONTH)%>"];
				$(monthsArr).each(function(){
					html+="<a href='<%=path%>/laborAnalysis.action?monthYear="+this+" 01, "+year+"' class='list-group-item list-group-item-default month "+(month == this ? "active":"")+"'>"+this+"</a>";
				});
				$('.month-group').append(html);
				<%-- after current month next month info disabled --%>
				$('.month-group').find('a').each(function(){
				   if(monthname===$(this).text()){
				     $(this).nextAll().addClass('disabled');
				     $(this).nextAll().removeAttr('href');
				     }
				});
			}
   
			function searchDates(){
			 	var from = $('.fromDate').val();
				var to = $('.toDate').val();
			 	if(from != null && from != "" && to != null && to != "")
					window.location.href='<%=path%>/partAnalysis.action?monthYear='+from+'&endDate='+to;
				else
					alert("From / To date required");	
			}
				
			function showDetails(that){
				 $('#ajaxDiv').show();
				var partsid=$(that).attr('id');
				 var partdetail=$(that).text();
				var previousCount=$(that).parent().find('td:eq(1)').find('span').text();
				 $.ajax({
						type : "POST",
						url:"<%=path%>/getPartsInfo.action",
						dataType:"json",
						data:{partId : partsid},
						async: true,
					success : function(response){
						html7 = "";
		                 html1="";	
							if (response.status == "success") {
								
								var totalprice=0;
								$.each(response.partlist,function() {
									html7 += "<tr><td>"
										+ this.partno
										+ "</td>";
									if(this.year!='' && this.make!='' && this.model!='' && this.submodel!='' && this.CYL_LIT_HEAD!=''){	
										html7 +="<td>"
										+ this.year+"&nbsp;"+this.make+"&nbsp;"+this.model+"&nbsp;"+this.submodel+"&nbsp;"
										+this.CYL_LIT_HEAD
										+ "</td>";
									}
									else{
										html7 +="<td>N/A</td>";
									}
								html7 += "<td><span style='float:right'>"
										+ this.count
										+ "</span></td>"
										+"<td><span style='float:right'>$"+this.price.toFixed(2)+"</span>";
									
									
								html7+="</td><td><span style='float:right'>$"+(this.price*this.count).toFixed(2)+"</span></td>";
	     									html7 += "</tr>";
	     						totalprice=totalprice+(this.price*this.count);	
														});
											
								html1 += "<tr><th colspan='14' style='text-align:right;'>Total</th><th colspan='4' style='text-align:right;'>$"+(totalprice).toFixed(2)+"</th></tr>";
								var html="";
								html+='<span><h4>'+partdetail+'&nbsp;('+previousCount+')&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<p style="float: right;margin-right: 4%;"><%=new SimpleDateFormat("MMMM yyyy").format(new SimpleDateFormat("MMM yyyy").parse(date))%></p></h4></span>';
								 $('#service').html(html);
								  $('#partDetail').find('.table tbody').empty().html(html7);
								  $('#partDetail').find('.table tfoot').html(html1);
								 $('.mainTable').hide();
								 $('#detail').show();
								 $('#ajaxDiv').hide();
							} 
								else{
								       html7+="<tr><th  colspan='14' style='text-align:center;'>No Record Found</th></tr>";
								       var html="";
										html+='<span><h4>'+partdetail+'&nbsp;('+previousCount+')&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<p style="float: right;margin-right: 4%;"><%=new SimpleDateFormat("MMMM yyyy").format(new SimpleDateFormat("MMM yyyy").parse(date))%></p></h4></span>';
										$('#service').html(html);
										$('#partDetail').find('.table tfoot').empty();
										$('#partDetail').find('.table tbody').empty().html(html7);
										$('.mainTable').hide();
										$('#detail').show();
										$('#ajaxDiv').hide();
						}
					},
					error : function(response) {
						alert('error');
					}
				});
	}
	function previous() {
		$('.mainTable').show();
		$('#detail').hide();
	}
	function printTab() {
		$('.printTab').css("height", "auto");
		window.print();
		$('.printTab').css({
			"height" : "500px"
		}, {
			"overflow-y" : "auto"
		});
	}
</script>
<style type="text/css">
#ajaxDiv {
	position: fixed;
	top: 0px;
	text-align: center;
	width: 100%;
	vertical-align: middle;
	height: 100%;
	padding-top: 110px;
	background-color: #fff;
	filter: Alpha(Opacity =   3);
	opacity: 0.3;
	z-index: 10;
	display: none;
}
.outer {
	margin-top: 1.5%;
}
.container-fluid {
	padding-left: 0px !important;
	padding-right: 0px !important;
}
.table>thead>tr>th:not(:first-child):not(:nth-child(2)){
vertical-align:middle;
text-align:right;
}
thead,tfoot {
	background-color: #e8f2fe;
}
.table td {
	font-size: 14px;
	vertical-align: middle !Important;
}
.table td {
	text-align: left;
}
tfoot th {
	text-align: right;
}
a {
	float: left;
	padding: 6px 10px !Important;
}
a:first-child {
	border-top-left-radius: 0px !Important;
	border-top-right-radius: 0px !Important;
}
a:last-child {
	border-bottom-left-radius: 0px !Important;
	border-bottom-right-radius: 0px !Important;
}
a:not(:last-child)
{
border-right: none !Important;
}
.topRow {
	margin-left: 0;
	margin-bottom: 6px;
}

.month-group {
	margin-bottom: 0 !Important;
	padding-right: 0 !Important;
}

@media print {
	.printBtn {
		display: none !important;
	}
	.month {
		display: none !important;
	}
	.postRow {
		display: none !important;
	}
	.month.active {
		display: block !important;
		 //text-align: left !important;
		border-right: 1px solid #337ab7 !important;
	}
	#export {
		display: none !important;
	}
	#datesdiv {
		float: right !important;
		width: 60% !important;
		margin-right: -12% !important;
	}
	a[href]:after {
		content: none !important;
	}
	#close {
		display: none;
	}
}

.close {
	opacity: 1;
}

.close:focus,.close:hover {
	opacity: 1;
}

.close>img {
	width: 30px;
	height: 30px;
}

.table {
	margin-bottom: 0px !important;
}

.modal-content {
	margin-top: 8% !important;
}

.modal-header {
	padding: 5px;
}
</style>

</head>

<body>
	<div
		style="border-color: #FFF; margin-top: -1.5% !important; padding-bottom: 10px !important; width: 98% !important; margin-left: 1% !important;"
		class="mainTable">
		<div class="container-fluid outer">
			<div class="topRow">
				<div style="margin-left: 0;" class="row">
					<div class="list-group month-group col-sm-6"></div>
					<div id="datesdiv" class="col-sm-5">
						<div class="form-group datePickersDiv" style="width: 39%; float: left; margin-bottom: 9px;">
							<div class='input-group date'>
								<input type='text' class="form-control fromDate" id='fromDate' style="padding-left: 6px !Important;" placeholder="From" value="<%=endDate != null ? monthYear : ""%>" /> 
								<span class="input-group-addon" style="padding: 6px 10px; cursor: pointer; border-top-right-radius: 0px !Important; border-bottom-right-radius: 0px !Important; background-color: #e8f2fe;">
									<span class="glyphicon glyphicon-calendar"></span>
								</span>
							</div>
						</div>
						<div class="form-group datePickersDiv" style="width: 40%; float: left; margin-bottom: 9px;">
							<div class='input-group date'>
								<input autocomplete="off" type='text' class="form-control toDate" id='toDate' style="padding-left: 6px !Important; border-top-left-radius: 0px !Important; border-bottom-left-radius: 0px !Important; border-left: none !Important;" placeholder="To" value="<%=endDate != null ? endDate : ""%>" />
								<span class="input-group-addon" style="cursor: pointer; background-color: #e8f2fe;" onclick="searchDates()"> 
								<span	class="glyphicon glyphicon-search"></span>
								</span>
							</div>
						</div>
						<div style="width: 16%; float: left; text-align: right; cursor: pointer;">
							<img onclick='printTab()' title="Print" style="width: 38px; height: 38px;" class="printBtn" src="<%=path%>/estimateUI/images/System-config-printer-icon.png">
						</div>
					</div>
					<div class='col-sm-1' style='padding-left: 0px !important;'>
						<div style="width: 20%; float: left; text-align: left; margin-left: -7%; cursor: pointer;">
							<form action="getPartsExport.action" method="post" onsubmit="getExcelData();">
								<input type="hidden" name="PartsSheet" id="exportHid" value="" />
								<input type="hidden" name="reqForMonth" id="reqForMonth" value="" /> 
								<input type="hidden" name="reqForMonthFrom" id="reqForMonthFrom" value="" /> 
								<input type="hidden" name="reqForMonthTo" id="reqForMonthTo" value="" />
								<button title="Export" type="submit" id="export" style="width: 80px;" class="btn btn-primary postBtn">
									<i class="glyphicon glyphicon-export"></i>&nbsp;&nbsp;Export
								</button>
							</form>
						</div>
					</div>
				</div>
			</div>
		</div>
		<div class="printTab" style='height: 500px; overflow-y: auto;'>
			<table class="table table-bordered table-hover">
				<thead>
					<tr>
						<th  rowspan="2" style="width: 10% !important; " ><center><i class="glyphicon glyphicon-user"></i>Technician</center></th>
						<th  colspan="2" style="width: 5% !important;"><center>Mon</center></a></th>
						<th colspan="2" style="width: 5% !important;"><center>Tue</center></a></th>
						<th colspan="2" style="width: 5% !important;"><center>Wed</center></a></th>
						<th colspan="2" style="width: 5% !important;"><center>Thr</center></a></th>
						<th colspan="2" style="width: 5% !important;"><center>Fri</center></a></th>
						<th rowspan="2" style="width: 5% !important;"><center>Total</center></th>
						<th rowspan="2" style="width: 5% !important;"><center>Actual</center></th>
						<th rowspan="2" style="width: 5% !important;"><center>Performance</center></th>
					</tr>
					<tr>
						<th style="width:1.25% !important;"><center>Nor</center></th>
						<th style="width:1.25% !important;"><center>Act</center></th>
						<th style="width:1.25% !important;"><center>Nor</center></th>
						<th style="width:1.25% !important;"><center>Act</center></th>
						<th style="width:1.25% !important;"><center>Nor</center></th>
						<th style="width:1.25% !important;"><center>Act</center></th>
						<th style="width:1.25% !important;"><center>Nor</center></th>
						<th style="width:1.25% !important;"><center>Act</center></th>
						<th style="width:1.25% !important;"><center>Nor</center></th>
						<th style="width:1.25% !important;"><center>Act</center></th>
				   </tr>
				</thead>
				<tbody>
				
				
				
				</tbody>
				<tfoot>
				</tfoot>
			</table>
		</div>
	</div>
	<div id="ajaxDiv">
		<img src="<%=path%>/images/ajaxLoadbig1.gif">
	</div>
		<!-- 
		<div class="container" id="detail"
		style='border: 1px solid #ddd; width: 99% !important;'>
		<div class="container-fluid outer">
			<div class="topRow">
				<div style="margin-left: -16px;" class="row">
					<div class="col-sm-11">
						<div id="service"></div>
					</div>
					<div style="width: 3%; float: left; text-align: right; cursor: pointer;">
						<img onclick='printTab()' title="Print" style="width: 38px; height: 38px;" class="printBtn" src="<%=path%>/estimateUI/images/System-config-printer-icon.png">
					</div>
					 <div id="close" style="width: 5%; float: left; text-align: right; cursor: pointer;">
						<img src="<%=path%>/images/DeleteRed.png" onclick="previous();" style="width: 36px;">
					</div> 
				</div>
			</div>
		</div>
	<div id="partDetail" class="printTab"
			style='padding-bottom: 20px; height: 500px; overflow-y: auto;'>
			 <table class="table table-bordered table-hover">
				<thead>
					<tr>
						<th rowspan="2" style="width: 10% !important; " ><center><i class="glyphicon glyphicon-user"></i>Technician</center></th>
						<th colspan="2" style="width: 5% !important;"><center>Mon</center></a></th>
						<th colspan="2" style="width: 5% !important;"><center>Tue</center></a></th>
						<th colspan="2" style="width: 5% !important;"><center>Wed</center></a></th>
						<th colspan="2" style="width: 5% !important;"><center>Thr</center></a></th>
						<th colspan="2" style="width: 5% !important;"><center>Fri</center></a></th>
						<th rowspan="2" style="width: 5% !important;"><center>Total</center></th>
						<th rowspan="2" style="width: 5% !important;"><center>Aactual</center></th>
						<th rowspan="2" style="width: 5% !important;"><center>Performance</center></th>
					</tr>
					<tr>
						<th style="width:1.25% !important;"><center>Nor</center></th>
						<th style="width:1.25% !important;"><center>Act</center></th>
						<th style="width:1.25% !important;"><center>Nor</center></th>
						<th style="width:1.25% !important;"><center>Act</center></th>
						<th style="width:1.25% !important;"><center>Nor</center></th>
						<th style="width:1.25% !important;"><center>Act</center></th>
						<th style="width:1.25% !important;"><center>Nor</center></th>
						<th style="width:1.25% !important;"><center>Act</center></th>
						<th style="width:1.25% !important;"><center>Nor</center></th>
						<th style="width:1.25% !important;"><center>Act</center></th>
					</tr>
				</thead>
				<tbody>
				
				
				</tbody>
				<tfoot></tfoot>
			</table> -->
		</div> 
	</div>
</body>
</html>
