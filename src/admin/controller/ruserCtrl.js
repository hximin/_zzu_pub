/**
 * Created by hxm on 2018/5/18.
 */
//var adminApp=angular.module("adminApp",["ngRoute"]);
adminApp.controller('ruserCtrl',['$scope','$routeParams','$location','$window','userListService',function($scope,rpms,$location,wndow,userListSvc){
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
      $scope.users = {};
      userListSvc.getUsers($scope.utb, ppid).then(function (resp) {
        $scope.users = resp.data;
      })
    }
  }
}]);

adminApp.filter('sexfilter',[function() {
  return function(text) {
      if (text==1){
      return 'Boy'
      }else
      if (text==2){
      return 'Girl'
      } else {
      return '未知'
    }
  }
  }]);
