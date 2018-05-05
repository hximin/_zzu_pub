/**
 * Created by hxm on 2018/5/4.
 */

angular.module("loginApp",[])
  .controller("loginCtrl",['loginService',function(ls){
    var self=this;
    self.user={};
    self.loginService=ls;
    self.submit=function() {
      console.log(self.user);
      self.ptopid=ls.login(self.user);
      console.log(self.ptopid);
      //self.user.userid=self.ptopid;
    }
}])
.component("loginCom", {
    templateUrl: "login_com.html",
    controller: function ($scope) {
    }
})
.factory('loginService',['$http',function($http){
    var service={
      isLoggedIn:false,
      login:function(usr){
        return $http.post('http://202.197.190.99:8088/isapi/Oauthr.exe/login',usr)
          .then(function(response){
            service.isLoggedIn=true;
            console.log(response);
            console.log(response.code2);
            return response.code2;

          });
      }
    };
    return service;
  }]);


