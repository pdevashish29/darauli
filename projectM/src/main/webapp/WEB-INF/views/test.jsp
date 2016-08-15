<%@page import="java.util.Calendar"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page session="false" %>
<% 

	String path = request.getContextPath();
	Calendar cal = Calendar.getInstance();
	int year = cal.get(Calendar.YEAR);

%>
<!DOCTYPE html>
<html lang="en">
<head>
  <title>Estimates</title>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <link rel="stylesheet" href="http://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
  <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.12.4/jquery.min.js"></script>
  <script src="http://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
<script src="http://ajax.googleapis.com/ajax/libs/angularjs/1.4.8/angular.min.js"></script>
<script type="text/javascript">

var app=angular.module('myApp', []);

app.filter('startFrom', function() {
    return function(input, start) {
        start = +start; //parse to int
        return input.slice(start);
    }
});

// end of Controllrvar 

// alternate - https://github.com/michaelbromley/angularUtils/tree/master/src/directives/pagination
// alternate - http://fdietz.github.io/recipes-with-angular-js/common-user-interface-patterns/paginating-through-client-side-data.html

app.controller('MyCtrl', ['$scope', '$filter', function ($scope, $filter) {
    $scope.currentPage = 0;
    $scope.pageSize = 10;
    $scope.data = [];
    $scope.q = '';
    
    $scope.getData = function () {
      // needed for the pagination calc
      // https://docs.angularjs.org/api/ng/filter/filter
      return $filter('filter')($scope.data, $scope.q)
     /* 
       // manual filter
       // if u used this, remove the filter from html, remove above line and replace data with getData()
       
        var arr = [];
        if($scope.q == '') {
            arr = $scope.data;
        } else {
            for(var ea in $scope.data) {
                if($scope.data[ea].indexOf($scope.q) > -1) {
                    arr.push( $scope.data[ea] );
                }
            }
        }
        return arr;
       */
    }
    
    $scope.numberOfPages=function(){
        return Math.ceil($scope.getData().length/$scope.pageSize);                
    }
    
    for (var i=0; i<65; i++) {
        $scope.data.push("Item "+i);
    }
}]);

//We already have a limitTo filter built-in to angular,
//let's make a startFrom filter


</script>




</head>
<body>
<div ng-app="myApp" ng-controller="MyCtrl">

<div class="row">
  <div class="col-sm-3"></div>
  <div class="col-sm-6">
  
      <input ng-model="q" id="search" class="form-control" placeholder="Filter text">
    <select ng-model="pageSize" id="pageSize" class="form-control">
        <option value="5">5</option>
        <option value="10">10</option>
        <option value="15">15</option>
        <option value="20">20</option>
     </select>
    <ul>
        <li ng-repeat="item in data | filter:q | startFrom:currentPage*pageSize | limitTo:pageSize">
            {{item}}
        </li>
    </ul>
    <button ng-disabled="currentPage == 0" ng-click="currentPage=currentPage-1">
        Previous
    </button>
    {{currentPage+1}}/{{numberOfPages()}}
    <button ng-disabled="currentPage >= getData().length/pageSize - 1" ng-click="currentPage=currentPage+1">
        Next
    </button>
  
  
  
  
  </div>
  <div class="col-sm-3"></div>
</div>

</div>
</body>
</html>

