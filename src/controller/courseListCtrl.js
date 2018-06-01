/**
 * Created by hxm on 2018/5/18.
 */
loginApp.controller("courseHotCtrl",['$scope','$location','$window','courseListService',function($scope,$location,wndow,courseListSvc){
  $scope.courses = {};
  courseListSvc.getHotCourses().then(function(resp) {
    $scope.courses = resp.data;
  })
}]);
loginApp.controller("courseYueCtrl",['$scope','$location','$window','courseListService',function($scope,$location,wndow,courseListSvc){
  $scope.courses = {};
  courseListSvc.getYueCourses().then(function(resp) {
    $scope.courses = resp.data;
  })
}]);

loginApp.controller("sessionCtrl",['$scope','$location','$window',function($scope,$location,wndow){
  $scope.loggedInCookie = JSON.parse(wndow.localStorage.getItem('_pub_user_ck'));

  //供退出按钮调用
  $scope.removeCookie=function(cookiename){
    wndow.localStorage.removeItem(cookiename);
    $scope.loggedInCookie._isLoggedIn=false;
    wndow.location.reload();
    //self.my_incfile1 = 'log_inc.html';
  };
  }]);



