/**
 * Created by hxm on 2018/5/18.
 */
//var adminApp=angular.module("adminApp",["ngRoute"]);
adminApp.controller('courseAdminCtrl',['$scope','$routeParams','$location','$window','courseListService',function($scope,rpms,$location,wndow,courseListSvc){
  $scope.loggedInCookie=JSON.parse(wndow.localStorage.getItem('_pub_user_ck'));
  if ($scope.loggedInCookie==null){
    wndow.location.href="/";
  } else
  {
    var ppid=$scope.loggedInCookie._ptopid;

    if (ppid==null){
      wndow.location.href="/";
    }
    else {
      $scope.utb = rpms.utb;
      $scope.courses = {};
      //$scope.courses =courseListSvc.getCourses($scope.utb, ppid);
     courseListSvc.getNewCourses().then(function(resp) {
        $scope.courses = resp.data;
      })
    }
  }
}]);
adminApp.controller("sessionCtrl",['$scope','$location','$window',function($scope,$location,wndow){
  $scope.loggedInCookie = JSON.parse(wndow.localStorage.getItem('_pub_user_ck'));
}]);
