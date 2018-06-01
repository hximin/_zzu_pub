/**
 * Created by hxm on 2018/5/18.
 */
var adminApp=angular.module("adminApp",["ngRoute"]);
adminApp.controller("adminCtrl",['$window','$scope','$location',function(wndow,$scope,$location){
    $scope.loggedInCookie=JSON.parse(wndow.localStorage.getItem('_pub_user_ck'));
    $scope.$on("$viewContentLoaded",function() {
      console.log("ng-view content loaded!");
      });
  $scope.$on("$routeChangeStart",function(event,next,current){
    if ($location.path()==''){
      event.preventDefault();//cancel url change
    }
    console.log("route change start!");

  });
}]);
adminApp.config(['$routeProvider','$locationProvider',function($routeProvider,$locationProvider){
  $locationProvider.hashPrefix('');
  $routeProvider
    .when('/userlist/:utb',{
      templateUrl:'/admin/reguserlist.html',
      controller: 'ruserCtrl'

    })
    .when('/del/:utb',
    {
      templateUrl:'/admin/reguserlist.html',
      controller: 'ruserCtrl',
      resolve:{
        auth:['$route','$routeParams','userListService','$window',function($route,$routeParams,userListSvc,wndow){
             //var uid=$routeParams.uid;
          var uid=$route.current.params.uid;
          var res=$route.current.params.res;
          var ptopid=$route.current.params.ptopid;
          return userListSvc.delUser(uid,res,ptopid).then(
            function(response){ //alert("操作成功!");
            }),function(err){
                alert("操作失败!");
                $location.href()='/';
              }
       }]
      }
    })
    .when('/logout',{
      templateUrl:'/admin/reguserlist.html',
      controller:'ruserCtrl',
      resolve:{
        logout:['$window',function(wndow){
           wndow.localStorage.removeItem('_pub_user_ck');
           return true;
        }]
      }
    })
    .when('/courselist',{
      templateUrl:'/admin/courseList.html',
      controller:'courseAdminCtrl',
      resolve:{
        courselist:['$window',function(wndow){
          return true;
        }]
      }
    })
    .when('/xxss',{template:'这是系统管理员面'});
    //.otherwise({redirectTo:'/admin/reguserlist.html'});
}]);
