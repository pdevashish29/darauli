<%@page import="java.util.Calendar"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
    <%
    	String path=request.getContextPath();
   	 	Calendar calendar=Calendar.getInstance();
    	int month=calendar.get(Calendar.MONTH);
   		 int year=calendar.get(Calendar.YEAR);
    
    %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>ServiceNetwork</title>
<link rel="stylesheet" href="<%=path%>/resources/css/bootstrap.min.css" style="text/css">
<style type="text/css">
	td, tfoot tr th{
		text-align: right;
	}
	thead tr th{
		text-align: center;
	}
	.table-bordered tbody tr:nth-child(even){
		background: #ddd;
	}
	[id$=show]{
		display: none;
	}
</style>
<script type="text/javascript" src="<%=path%>/resources/js/jquery-1.11.2.min.js"></script>
<script type="text/javascript" src="<%=path%>/resources/js/angular.min.js"></script>
<script type="text/javascript" src="<%=path%>/resources/js/bootstrap.min.js"></script>

<link rel="stylesheet" href="<%=path%>/resources/css/bootstrap-datetimepicker.css" style="text/css">
<script type="text/javascript" src="<%=path%>/resources/js/moment-with-locales.js"></script>
<script type="text/javascript" src="<%=path%>/resources/js/bootstrap-datetimepicker.js"></script>
<script type="text/javascript">
var app=angular.module('dailySumaryApp', []);

app.factory('dailySumaryFac',function($q, $http){
	return{
		'getDailySummary':function(fromDate, toDate, month, year){//alert(JSON.stringify({fromDate:fromDate, toDate:toDate, month:month, year:year}))
			return $http({
				method: 'post',
				url:'<%=path %>/getDailyCloseSummary',
				data:{'fromDate':fromDate, 'toDate':toDate, 'month':month, 'year':year}
			}).then(
				function(response){
					return response.data;
				},
				function(errResponse){
					return $q.reject(errResponse);
				}
			);
		}
	}
});

app.controller('dailySumaryCtrl', function($scope, dailySumaryFac){
	$scope.fromDate='';
	$scope.toDate='';
	$scope.month='<%=month%>';
	$scope.year='<%=year%>';
	$scope.revenue='';
	$scope.inventory='';
	$scope.purchase='';
	$scope.financialTotal=0;
	
	dailySumaryFac.getDailySummary($scope.fromDate, $scope.toDate, $scope.month, $scope.year).then(
		function(data){
			$scope.revenue=data.revenue;
			$scope.inventory=data.inventory;
			$scope.purchase=data.purchase;
		}		
	);
	
	$scope.totalPurchaseAmount=0;
	$scope.viewbyDate=function(){
		$scope.fromDate=$('#fromDate').val();
		$scope.toDate=$('#fromDate').val();
		
		dailySumaryFac.getDailySummary($scope.fromDate, $scope.toDate, $scope.month, $scope.year).then(
				function(data){
					
					$scope.revenue=data.revenue;
					$scope.inventory=data.inventory;
					$scope.purchase=data.purchase;
					$scope.financialTotal=$scope.revenue[8]+$scope.revenue[9]+$scope.revenue[10]+$scope.revenue[11]+$scope.revenue[12]+$scope.revenue[13]+$scope.revenue[19]-$scope.revenue[20]-$scope.revenue[21];
					
					angular.forEach($scope.purchase, function(value, key){
						$scope.totalPurchaseAmount +=value[0];
					});
				}		
			);
	}
	
	$scope.toggleView=function(refren){
		if(refren.split('_')[1]=='show'){
			/* $('[id$=show]').show();
			$('[id^=table]').hide(); */
			var contentVal=refren.replace('show', 'hide');
			$('[id$='+contentVal+']').hide();
			$('[id$='+refren+']').show();
		}else{
			var contentVal=refren.replace('hide', 'show');
			/* $('[id$=show]').show();
			$('[id^=table]').hide(); */
			$('[id$='+contentVal+']').hide();
			$('[id$='+refren+']').show();
		}
		
	}
});
</script>
</head>
<body ng-app="dailySumaryApp" ng-controller="dailySumaryCtrl">
<div class="fluid-container">
	<jsp:include page="salesMain.jsp"></jsp:include>
	<div class="form-group" style="margin-top: -9px;margin-left: 2px;">
			<div class="panel panel-primary" style="min-height: 500px;">
				<div class="panel-heading">
					<div class="panel-title">Sales</div>
				</div>
				<div class="panel-body">
					<div class="form-group">
						<div class="input-group  date" id="fromDueDate" style="margin-right: 8px; width: 20%;float: left;" >
							<input type="text" class="form-control" placeholder="MM/DD/YYYY" name="fromDate" id="fromDate" ng-model="fromDate" >
					   		<span class="input-group-addon"><span class="glyphicon glyphicon-calendar"></span>
					   		</span>
						</div>
						
						<div class="form-group">
							<button class="btn btn-primary" data-ng-click="viewbyDate()">View</button>
						</div>
					</div>
					<div class="form-group">
						<div class="panel panel-info" id="div_revenue" style="margin-left: -15px;margin-right: -15px;">
							<div class="panel-heading" style="background: rgb(0, 136, 204);border: rgb(0, 136, 204);color: #fff;">
								<div class="panel-title">Revenue</div>
								<div style="float: right;margin-top: -29px;font-size: 35px;margin-right: -10px;cursor: pointer;">
									<span class="glyphicon glyphicon-plus-sign" id="revenue_show" data-ng-click="toggleView('revenue_hide')"></span>
									<span class="glyphicon glyphicon-minus-sign" id="revenue_hide" data-ng-click="toggleView('revenue_show')"></span>
								</div>
								
							</div>
							<div class="panel-body" id="table_revenue_hide">
								<table class="table table-bordered" >
									<tbody>
										
											<tr><td style="text-align: left;">Total Sales</td><td>{{revenue[0] |currency}}</td><td>{{100| number:2}}%</td></tr>
											<tr><td style="text-align: left;">Labor</td><td>{{revenue[2] |currency}}</td><td><span ng-if="revenue[0]>0">{{revenue[2]*100/revenue[0]| number:2}}</span></span><span  ng-if="revenue[0]==0">{{0| number:2}}</span>%</td></tr>
											<tr><td style="text-align: left;">Parts</td><td>{{revenue[3] |currency}}</td><td><span ng-if="revenue[0]>0">{{revenue[3]*100/revenue[0]| number:2}}</span><span  ng-if="revenue[0]==0">{{0| number:2}}</span>%</td></tr>
											<tr><td style="text-align: left;">Sales Tax</td><td>{{revenue[1] |currency}}</td><td><span ng-if="revenue[0]>0">{{revenue[1]*100/revenue[0]| number:2}}</span></span><span  ng-if="revenue[0]==0">{{0| number:2}}</span>%</td></tr>
											<tr><td style="text-align: left;">Discount: Labor</td><td>{{revenue[4] |currency}}</td><td><span ng-if="revenue[0]>0">{{revenue[4]*100/revenue[0]| number:2}}</span></span><span  ng-if="revenue[0]==0">{{0| number:2}}</span>%</td></tr>
											<tr><td style="text-align: left;">Discount: Parts</td><td>{{revenue[5] |currency}}</td><td><span ng-if="revenue[0]>0">{{revenue[5]*100/revenue[0]| number:2}}</span></span><span  ng-if="revenue[0]==0">{{0| number:2}}</span>%</td></tr>
											<tr><td style="text-align: left;">Total Discount: Labor and Parts</td><td>{{revenue[4]+revenue[5] |currency}}</td><td><span ng-if="revenue[0]>0">{{(revenue[4]+revenue[5])*100/revenue[0]| number:2}}</span><span  ng-if="revenue[0]==0">{{0| number:2}}</span>%</td></tr>
											<tr><td style="text-align: left;">Total Estimates including Invoices</td><td>{{revenue[6] |currency}}</td><td>{{100|number:2}}%</td></tr>
											<tr><td style="text-align: left;border-bottom :1px solid #000;">Total Invoices</td><td style="border-bottom :1px solid #000;"><span ng-if="revenue[7]>0">{{revenue[7] |currency}}</span><span ng-if="revenue[7]==null || revenue[7]==0">{{0|currency}}</span></td><td style="border-bottom :1px solid #000;"><span ng-if="revenue[6]>0">{{revenue[7]*100/revenue[6]| number:2}}%</span><span  ng-if="revenue[6]==0">{{0| number:2}}</span>%</td></tr>
										
									</tbody>
									<tfoot>
										<tr >
											<th>Average Sales</th><th><span ng-if="revenue[7]>0">{{revenue[0]/revenue[7]|currency}}</span><span ng-if="revenue[7]==0 || revenue[7]==null">{{0|currency}}</span></th><th></th>
										</tr>
									</tfoot>
								</table>
							</div>
						</div><!-- End panel-info div_revenue -->	
						
						<div class="panel panel-info" id="div_cash_collection" style="margin-left: -15px;margin-right: -15px;">
							<div class="panel-heading" style="background: rgb(0, 136, 204);border: rgb(0, 136, 204);color: #fff;">
								<div class="panel-title">Cash Collection</div>
								<div style="float: right;margin-top: -29px;font-size: 35px;margin-right: -10px;cursor: pointer;">
									<span class="glyphicon glyphicon-plus-sign" id="cash_show" data-ng-click="toggleView('cash_hide')"></span>
									<span class="glyphicon glyphicon-minus-sign" id="cash_hide" data-ng-click="toggleView('cash_show')"></span>
								</div>
								
							</div>
							<div class="panel-body" id="table_cash_hide">
								<table class="table table-bordered">
									<tbody >
										
											<tr><td style="text-align: left;">Cash</td><td><span ng-if="revenue[8]>0">{{revenue[8] |currency}}</span><span ng-if="revenue[8]==null || revenue[8]==0">{{0|currency}}</span></td><td><span ng-if="financialTotal>0">{{revenue[8]*100/financialTotal| number:2}}</span><span  ng-if="financialTotal==0">{{0| number:2}}</span>%</td></tr>
											<tr><td style="text-align: left;">Check</td><td><span ng-if="revenue[9]>0">{{revenue[9] |currency}}</span><span ng-if="revenue[9]==null || revenue[9]==0">{{0|currency}}</span></td><td><span ng-if="financialTotal>0">{{revenue[9]*100/financialTotal| number:2}}</span><span  ng-if="financialTotal==0">{{0| number:2}}</span>%</td></tr>
											 <tr><td style="text-align: left;">Visa</td><td><span ng-if="revenue[10]>0">{{revenue[10] |currency}}</span><span ng-if="revenue[10]==null || revenue[10]==0">{{0|currency}}</span></td><td><span ng-if="financialTotal>0">{{revenue[10]*100/financialTotal| number:2}}</span><span  ng-if="financialTotal==0">{{0| number:2}}</span>%</td></tr>
											<tr><td style="text-align: left;">Master Card</td><td><span ng-if="revenue[11]>0">{{revenue[11] |currency}}</span><span ng-if="revenue[11]==null || revenue[11]==0">{{0|currency}}</span></td><td><span ng-if="financialTotal>0">{{revenue[11]*100/financialTotal| number:2}}</span></span><span  ng-if="financialTotal==0">{{0| number:2}}</span>%</td></tr>
											<tr><td style="text-align: left;">AMEX</td><td><span ng-if="revenue[12]>0">{{revenue[12] |currency}}</span><span ng-if="revenue[12]==null || revenue[12]==0">{{0|currency}}</span></td><td><span ng-if="financialTotal>0">{{revenue[12]*100/financialTotal| number:2}}</span></span><span  ng-if="financialTotal==0">{{0| number:2}}</span>%</td></tr>
											<tr><td style="text-align: left;">Discover</td><td><span ng-if="revenue[13]>0">{{revenue[13] |currency}}</span><span ng-if="revenue[13]==null || revenue[13]==0">{{0|currency}}</span></td><td><span ng-if="financialTotal>0">{{revenue[13]*100/financialTotal| number:2}}</span></span><span  ng-if="financialTotal==0">{{0| number:2}}</span>%</td></tr>
											<tr><td style="text-align: left;">Credit Sales or PO, Paid with Cash, Check, or Credit Card</td><td><span ng-if="revenue[19]>0">{{revenue[19] |currency}}</span><span ng-if="revenue[19]==null || revenue[19]==0">{{0|currency}}</span></td><td><span ng-if="financialTotal>0">{{(revenue[13])*100/financialTotal| number:2}}</span><span  ng-if="financialTotal==0">{{0| number:2}}</span>%</td></tr>
											<tr><td style="text-align: left;">Return</td><td><span ng-if="revenue[20]>0">{{revenue[20] |currency}}</span><span ng-if="revenue[20]==null || revenue[20]==0">{{0|currency}}</span></td><td><span ng-if="financialTotal>0">{{revenue[20]*100/financialTotal|number:2}}</span><span  ng-if="financialTotal==0">{{0| number:2}}</span>%</td></tr>
											<tr><td style="text-align: left;border-bottom :1px solid #000;" >Refund</td><td style="border-bottom :1px solid #000;"><span ng-if="revenue[21]>0">{{revenue[21] |currency}}</span><span ng-if="revenue[21]==null || revenue[21]==0">{{0|currency}}</span></td><td style="border-bottom :1px solid #000;"><span ng-if="financialTotal>0">{{revenue[21]*100/financialTotal| number:2}}</span><span  ng-if="financialTotal==0">{{0| number:2}}</span>%</td></tr>
										
									</tbody>
									<tfoot>
										<tr >
											<th>Total</th><th><span ng-if="financialTotal>0">{{financialTotal|currency}}</span><span ng-if="financialTotal==0 || financialTotal==null">{{0|currency}}</span></th><th></th>
										</tr>
									</tfoot>
								</table>
							</div>
						</div><!-- End panel-info div_cash_collection -->
						
						<div class="panel panel-info" id="div_recievable" style="margin-left: -15px;margin-right: -15px;">
							<div class="panel-heading" style="background: rgb(0, 136, 204);border: rgb(0, 136, 204);color: #fff;">
								<div class="panel-title">Receivables</div>
								<div style="float: right;margin-top: -29px;font-size: 35px;margin-right: -10px;cursor: pointer;">
									<span class="glyphicon glyphicon-plus-sign" id="recieve_show" data-ng-click="toggleView('recieve_hide')"></span>
									<span class="glyphicon glyphicon-minus-sign" id="recieve_hide" data-ng-click="toggleView('recieve_show')"></span>
								</div>
								
							</div>
							<div class="panel-body" id="table_recieve_hide">
								<table class="table table-bordered">
									<tbody >
										
											<tr><td style="text-align: left;">Total Fleet Sales</td><td><span ng-if="revenue[14]>0">{{revenue[14] |currency}}</span><span ng-if="revenue[14]==null || revenue[14]==0">{{0|currency}}</span></td><td><span ng-if="revenue[0]>0">{{revenue[14]*100/revenue[0]| number:2}}</span><span ng-if="revenue[14]==null || revenue[14]==0 || revenue[0]==0">{{0|number:2}}</span>%</td></tr>
											<tr><td style="text-align: left;">Paid</td><td><span ng-if="revenue[15]>0">{{revenue[15] |currency}}</span><span ng-if="revenue[15]==null || revenue[15]==0">{{0|currency}}</span></td><td></td></tr>
											 <tr><td style="text-align: left;">Pending</td><td><span ng-if="revenue[16]>0">{{revenue[16] |currency}}</span><span ng-if="revenue[16]==null || revenue[16]==0">{{0|currency}}</span></td><td></td></tr>
											
									</tbody>
								</table>
							</div>
						</div><!-- End panel-info div_recievable -->
						
						<div class="panel panel-info" id="div_logic_statistics" style="margin-left: -15px;margin-right: -15px;">
							<div class="panel-heading" style="background: rgb(0, 136, 204);border: rgb(0, 136, 204);color: #fff;">
								<div class="panel-title">Labor Statistics</div>
								<div style="float: right;margin-top: -29px;font-size: 35px;margin-right: -10px;cursor: pointer;">
									<span class="glyphicon glyphicon-plus-sign" id="statistics_show" data-ng-click="toggleView('statistics_hide')"></span>
									<span class="glyphicon glyphicon-minus-sign" id="statistics_hide" data-ng-click="toggleView('statistics_show')"></span>
								</div>
								
							</div>
							<div class="panel-body" id="table_statistics_hide">
								<table class="table table-bordered">
									<tbody >
										
											<tr><td style="text-align: left;">Billable Hours</td><td><span ng-if="revenue[17]>0">{{revenue[17] |currency}}</span><span ng-if="revenue[17]==0 || revenue[17]==null">{{0|number:2}}</span></td><td>{{100| number:2}}%</td></tr>
											<tr><td style="text-align: left;">Actual Hours</td><td><span ng-if="revenue[18]>0">{{revenue[18] |currency}}</span><span ng-if="revenue[18]==0 || revenue[18]==null">{{0|number:2}}</span></td><td><span ng-if="revenue[17] >0">{{revenue[18]*100/revenue[17] |number:2}}</span><span ng-if="revenue[17]==null || revenue[17]==0">{{0|number:2}}</span>%</td></tr>
									</tbody>
								</table>
							</div>
						</div><!-- End panel-info div_logic_statistics -->
						
						<div class="panel panel-info" id="div_inventory_consume_sales" style="margin-left: -15px;margin-right: -15px;">
							<div class="panel-heading" style="background: rgb(0, 136, 204);border: rgb(0, 136, 204);color: #fff;">
								<div class="panel-title">Inventory Consumed/Stock Sales</div>
								<div style="float: right;margin-top: -29px;font-size: 35px;margin-right: -10px;cursor: pointer;">
									<span class="glyphicon glyphicon-plus-sign" id="inventory_show" data-ng-click="toggleView('inventory_hide')"></span>
									<span class="glyphicon glyphicon-minus-sign" id="inventory_hide" data-ng-click="toggleView('inventory_show')"></span>
								</div>
								
							</div>
							<div class="panel-body" id="table_inventory_hide">
								<table class="table table-bordered">
									<thead style="background: #337ab7;border: #337ab7;color: #fff;">
										<tr>
											<th>Part Description</th>
											<th>Part#</th>
											<th>My Price</th>
											<th>Qty</th>
											<th>Total</th>
											<th>QOH</th>
										</tr>
									</thead>
									<tbody >
											<tr data-ng-repeat="item in inventory track by $index">
												<td style="text-align: left;">{{item[0]}}</td>
												<td style="text-align: center;">{{item[1]}}</td>
												<td>{{item[4]|currency}}</td>
												<td>{{item[2]}}</td>
												<td>{{item[4]*item[2]|currency}}</td>
												<td>{{item[3]|number:2}}</td> 
											</tr>
											<!-- <tr ng-if="inventory.length==0">
												<td colspan="6" style="color: red;font-size: 16px;font-weight: bold;text-align: center;">No record found</td>
											</tr> -->
									</tbody>
									
								</table>
							</div>
						</div><!-- End panel-info div_inventory_consume_sales -->
						
						<div class="panel panel-info" id="div_inventory_consume_sales" style="margin-left: -15px;margin-right: -15px;">
							<div class="panel-heading" style="background: rgb(0, 136, 204);border: rgb(0, 136, 204);color: #fff;">
								<div class="panel-title">Parts Purchases</div>
								<div style="float: right;margin-top: -29px;font-size: 35px;margin-right: -10px;cursor: pointer;">
									<span class="glyphicon glyphicon-plus-sign" id="part_show" data-ng-click="toggleView('part_hide')"></span>
									<span class="glyphicon glyphicon-minus-sign" id="part_hide" data-ng-click="toggleView('part_show')"></span>
								</div>
								
							</div>
							<div class="panel-body" id="table_part_hide">
								<table class="table table-bordered">
									<thead style="background: #337ab7;border: #337ab7;color: #fff;">
										<tr>
											<th>Vendor</th>
											<th>My Price</th>
											<th></th>
											
										</tr>
									</thead>
									<tbody xyx="{{totalPurchaseAmount}}">
											<tr data-ng-repeat="item in purchase" ng-if="purchase.length>0">
											<td style="text-align: left;">{{item[1]}}</td>
											<td >{{item[0]|number:2}}</td>
											<td>{{item[0]*100/totalPurchaseAmount|number:2}}%</td>
											
											</tr>
											<tr ng-if="purchase.length==0">
												<td colspan="6" style="color: red;font-size: 16px;font-weight: bold;text-align: center;">No record found</td>
											</tr>
									</tbody>
								</table>
							</div>
						</div><!-- End panel-info div_inventory_consume_sales -->
					</div>
				</div>	
			</div>
		</div>
		<div class="form-group">
			<jsp:include page="/footer.jsp"></jsp:include>
		</div>
</div>
</body>
<script type="text/javascript">
	$(function(){
		$('#fromDueDate')
	    .datetimepicker({
	    	format: 'MM/DD/YYYY'
	    });
		$('#toDueDate')
	    .datetimepicker({
	    	format: 'MM/DD/YYYY'
	    });
	});
	$(".headerMenu").find("li").each(function(){
		var id=$(this).attr('id');
		//alert(id);
		if(id == "sales"){
			$(this).addClass("active");
			$(this).find("a").css("background-color","#0088cc");
		}else{
			$(this).removeClass("active");
			$(this).find("a").css("background-color","");
		}
	});
	$(".salesMenu").find("li").each(function(){
		var id=$(this).attr('id');
		//alert(id);
		if(id == "dailySummary"){
			$(this).addClass("active");
			$(this).find("a").css("background-color","#0088cc");
		}else{
			$(this).removeClass("active");
			$(this).find("a").css("background-color","");
		}
	});
</script>
</html>