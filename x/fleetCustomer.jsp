<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
    <%
    	String path=request.getContextPath();
    %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
	<title>ServiceNetwork</title>
	<link rel="stylesheet" href="<%=path%>/resources/css/bootstrap.min.css" style="text/css">
	<script type="text/javascript" src="<%=path%>/resources/js/jquery-1.11.2.min.js"></script>
	<script type="text/javascript" src="<%=path%>/resources/js/angular.min.js"></script>
	<script type="text/javascript" src="<%=path%>/resources/js/bootstrap.min.js"></script>
	<script type="text/javascript" src="<%=path%>/resources/js/kendo.all.min.js"></script>
	<script type="text/javascript">
		var app = angular.module('fleetCustomerApp', []);
		
		app.filter('offset', function() {
			  return function(input, start) {
			    start = parseInt(start, 10);
			    if(start>0){
			    	return input.slice(start);
			    }else{
			    	return input;
			    }
			  };
		});
		
		app.filter('limitObjectFromTo', function() {
		      return function(obj, limitFrom, limitTo) {
		         var newObj = {},
		          i = 0;
		          for (var p in obj) {
		            if (i >= limitFrom) newObj[p] = obj[p];
		            if (++i === limitTo) break;
		          }
		        return newObj;
		      };
		  });
		
		app.factory('ajaxService', ['$http', function ($http) {
			 var urlBase="<%=path%>";
			return{
				getFleetCustomer: function (searchText) {
					 var uri=urlBase +'/getFleetCustomersList/'+searchText;
					 console.log(uri);
					 var promise = $http({method:'POST', url:uri,async:false})
					    .success(function (data, status, headers, config) {
					      return data;
					    })
					    .error(function (data, status, headers, config) {
					      return {"status": false};
					    });
					  return promise; 
				}
			}
		}]);
		
		var TableCtrl = app.controller('fleetCustomerCtrl', function ($scope, $filter,$http,ajaxService,graphFactory) {
			$scope.itemsPerPage = 5;
			$scope.currentPage = 0; 
			$scope.mapCreated={};
			$scope.map={};
			$scope.itemLength=0;
			$scope.orderByField = 'date';
			$scope.reverseSort = false;
			$scope.searchText="";
			$scope.getFleetCustomer=function(){
				var text=$('#searchText').val();
				if(text==""){
					text="text";
				}
				 ajaxService.getFleetCustomer(text).then(function(promise) {
					 $scope.map=promise.data;
					 $scope.currentPage = 0; 
					 $scope.mapCreated={};
					 $scope.list=[];
					 angular.forEach($scope.map, function(value,key) {
						 $scope.splitList=value.split("::");
						 $scope.list=[];
						 angular.forEach($scope.splitList, function(item) {
							 $scope.list.push(item);
						 });
						 $scope.mapCreated[key]=$scope.list;
					 });
					 $scope.itemLength=Object.keys($scope.mapCreated).length;
				 });
			};
			
			
			
	//---------------------------Code for pagination -------------------------------
			$scope.range = function() {
					var rangeSize;
					if($scope.itemLength< $scope.itemsPerPage){
						rangeSize = 1;
					}
					else if($scope.itemLength > $scope.itemsPerPage*5){
						rangeSize = 5;
					}
					else if($scope.itemLength > $scope.itemsPerPage*10){
						rangeSize=10;
					}
					else{
						rangeSize=2;
					}
				    //var rangeSize = 2;
				    var ret = [];
				    var start;

				    start = $scope.currentPage;
				    if ( start > $scope.pageCount()-rangeSize ) {
				      start = $scope.pageCount()-rangeSize+1;
				    }
					if(start<0){
						start=0;
					}
				    for (var i=start; i<start+rangeSize; i++) {
				      ret.push(i);
				    }
				    return ret;
			};

			  $scope.prevPage = function() {
			    if ($scope.currentPage > 0) {
			      $scope.currentPage--;
			    }
			  };

			  $scope.prevPageDisabled = function() {
			    return $scope.currentPage === 0 ? "disabled" : "";
			  };

			  $scope.pageCount = function() {
			    return Math.ceil($scope.itemLength/$scope.itemsPerPage)-1;
			  };

			  $scope.nextPage = function() {
			    if ($scope.currentPage < $scope.pageCount()) {
			      $scope.currentPage++;
			    }
			  };

			  $scope.nextPageDisabled = function() {
			    return $scope.currentPage === $scope.pageCount() ? "disabled" : "";
			  };

			  $scope.setPage = function(n) {
			    $scope.currentPage = n;
			  };
		 	
	//---------------------------End pagination code---------------------------------
		});
	</script>
</head>
<body ng-app="fleetCustomerApp" ng-controller="fleetCustomerCtrl" data-ng-init="getFleetCustomer()">
<div class="fluid-container">
	<jsp:include page="customerMain.jsp"></jsp:include>
	<div class="form-group" style="margin-top: -9px;margin-left: 2px;">
			<div class="panel panel-primary" style="min-height: 500px;">
				<div class="panel-heading">
					<div class="panel-title">Customers</div>
				</div>
				<div class="panel-body">
					<div>
						<input type="text" ng-keyup="getFleetCustomer()" name="searchText" ng-modal="searchText" id="searchText"  class="form-control" style="width: 30%;" placeholder="Search by name, phone#, email, license">
					</div>
					<div id="tableContent" style="margin-top: 15px;" >
						<table class="table table-bordered" id="table">
							<thead style="background-color: #337ab7;color:white;">
								<tr style="font-size: 12px;">
									<th style="width: 30%;cursor: pointer;" class="asc" eq="0" onclick="sortColumnText(this)" >Fleet Customers<span class="glyphicon pull-right glyphicon-chevron-down" ng-class="{ 'glyphicon-chevron-down': orderProperty != '0', 'glyphicon-chevron-up' : orderProperty == '0' }"></span></th>
									<th style="width: 20%;cursor: pointer;" class="asc" eq="1" onclick="sortColumn(this)">Count<span class="glyphicon pull-right glyphicon-chevron-down" ng-class="{ 'glyphicon-chevron-down': orderProperty != '0', 'glyphicon-chevron-up' : orderProperty == '0' }"></span></th>
									<th style="width: 50%;cursor: pointer;" class="asc" eq="2" onclick="sortColumnText(this)">Vehicles<span class="glyphicon pull-right glyphicon-chevron-down" ng-class="{ 'glyphicon-chevron-down': orderProperty != '0', 'glyphicon-chevron-up' : orderProperty == '0' }"></span></th>
								</tr>
							</thead>
							<tbody>
								<tr ng-if="mapCreated!=null" ng-repeat="(key,value) in mapCreated  | limitObjectFromTo: currentPage*itemsPerPage:(currentPage+1)*itemsPerPage ">
									<td id="0">
										<b>{{key.split("~")[9]}}</b>
										<div>{{key.split("~")[3]}}
										{{key.split("~")[4]}}
										{{key.split("~")[5]}}</div>
										<div>{{key.split("~")[6]}}</div>
										<div>{{key.split("~")[7]}}</div>
									</td>
									<td id="1">{{value.length}}</td>
									<td>
										<p ng-repeat="item in value">
											<b>{{item.split("~")[0]}}</b><br>
											{{item.split("~")[1]}}<br>
											{{item.split("~")[2]}}
										</p>
									</td>
								</tr>
							</tbody>
							<tfoot>
								<tr id="paginationRow" ng-if="itemLength!='0'">
						          <td colspan="15">
							          <div  style="text-align: center;">
							            <ul class="pagination pagination-lg">
							              <li ng-class="prevPageDisabled()">
							                <a href ng-click="prevPage()">« Prev</a>
							              </li>
							              <li ng-repeat="n in range()" ng-class="{active: n == currentPage}" ng-click="setPage(n)">
							                <a href="#" {{count=n+1}}>{{n+1}}</a>
							              </li>
							              <li ng-class="nextPageDisabled()">
							                <a href ng-click="nextPage()">Next »</a>
							              </li>
							              
							            </ul>
							          </div>
						          </td>
						        </tr>
							 </tfoot>
						</table>
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
	$(".headerMenu").find("li").each(function(){
		var id=$(this).attr('id');
		//alert(id);
		if(id == "customers"){
			$(this).addClass("active");
			$(this).find("a").css("background-color","#0088cc");
		}else{
			$(this).removeClass("active");
			$(this).find("a").css("background-color","");
		}
	});
	
	$(".customerMenu").find("li").each(function(){
		var id=$(this).attr('id');
		//alert(id);
		if(id == "fleetCustomer"){
			$(this).addClass("active");
			$(this).find("a").css("background-color","#0088cc");
		}else{
			$(this).removeClass("active");
			$(this).find("a").css("background-color","");
		}
	});
</script>
<script type="text/javascript">
	 function sortColumn(that){
		var eq=$(that).attr('eq');
		var ascDesc=$(that).attr('class');
		$(that).parent().parent().next().find('tr').each(function(){ 
		    var tdold = $(this).find('td:eq("'+eq+'")').text().trim(); 
		    var parentThis=$(this);
		    $(that).parent().parent().next().find('tr').each(function(){ 
			    var tdnew = $(this).find('td:eq("'+eq+'")').text().trim(); 
			       if(ascDesc=='asc'){
			    	   if(tdold!=""){
					       if(Number(tdold) > Number(tdnew)){
					    	   var newRow= $(this).html();
					    	   var oldRow= parentThis.html();
					    	   parentThis.html(newRow);
					    	   $(this).html(oldRow);
					       }
			    	   }
			       }
			       if(ascDesc=='desc'){
			    	   if(tdold!=""){
				    	   if(Number(tdold) < Number(tdnew)){
					    	   var newRow= $(this).html();
					    	   var oldRow= parentThis.html();
					    	   parentThis.html(newRow);
					    	   $(this).html(oldRow);
					    	   
					       }
			    	   }
			       }
		    });
		});
		if(ascDesc=='asc'){
			$(that).addClass('desc');
			$(that).removeClass('asc');
		}else{
			$(that).addClass('asc');
			$(that).removeClass('desc');
		}
	} 
	 
	 function sortColumnText(that){
			var eq=$(that).attr('eq');
			var ascDesc=$(that).attr('class');
			$(that).parent().parent().next().find('tr').each(function(){ 
			    var tdold = $(this).find('td:eq("'+eq+'")').find('b').text().trim().toUpperCase(); 
			    var parentThis=$(this);
			    $(that).parent().parent().next().find('tr').each(function(){ 
				    var tdnew = $(this).find('td:eq("'+eq+'")').find('b').text().trim().toUpperCase(); 
				       if(ascDesc=='asc'){
				    	   if(tdold!=""){
						       if(tdold > tdnew){
						    	   var newRow= $(this).html();
						    	   var oldRow= parentThis.html();
						    	   parentThis.html(newRow);
						    	   $(this).html(oldRow);
						       }
				    	   }
				       }
				       if(ascDesc=='desc'){
				    	   if(tdold!=""){
					    	   if(tdold < tdnew){
						    	   var newRow= $(this).html();
						    	   var oldRow= parentThis.html();
						    	   parentThis.html(newRow);
						    	   $(this).html(oldRow);
						    	   
						       }
				    	   }
				       }
			    });
			});
			if(ascDesc=='asc'){
				$(that).addClass('desc');
				$(that).removeClass('asc');
			}else{
				$(that).addClass('asc');
				$(that).removeClass('desc');
			}
		} 
	 
	
</script>
</html>