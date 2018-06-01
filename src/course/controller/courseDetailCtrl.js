/**
 * Created by hxm on 2018/5/18.
 */
loginApp.config(['$locationProvider', function($locationProvider) {
  //$locationProvider.html5Mode(true);
  $locationProvider.html5Mode({
    enabled: true,
    requireBase: false//必须配置为false，否则<base href=''>这种格式带base链接的地址才能解析
  });
}]);

loginApp.controller("courseDetailCtrl",['$scope', '$location', function($scope, $location) {
  if ($location.search().courseid) {
    $scope.courseid = $location.search().courseid;
  }
}]);

