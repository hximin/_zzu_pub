/**
 * Created by hxm on 2018/5/4.
 */

var loginApp=angular.module("loginApp",[]);
loginApp.controller("loginCtrl",['$http',function($http){
    var self=this;
    self.user={};
    self.my_incfile1='log_inc.html';
    self.submit=function() {

      console.log(self.user);
      $http.post('http://202.197.190.99:8088/isapi/Oauthr.exe/login',self.user).then(function(resp){
        if (resp.data.code==0){
          self.isLoggedIn=true;
          self.ptopid=resp.data.ptopid;
          console.log(self.ptopid);
        }else{

          self.isLoggedIn=false;
        }
        console.log(self.isLoggedIn);
        if (self.isLoggedIn){
          self.my_incfile1='userinfo_inc.html';
        }
      });
    }
}]);
loginApp.component("loginCom", {
    templateUrl: "log_inc.html",
    controller: function ($scope) {

    }
});

loginApp.factory('loginService',['$http',function($http){
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

loginApp.controller("regCtrl",['$http',function($http){
  var self=this;
  var isExist=false;
  var notSame=false;
  self.user={};
  self.addaUser=function(){
    $http.post('http://202.197.190.99:8088/isapi/oauthr.exe/addAUsr',self.user).then(function(resp){
      if (resp.data.code==0){
        self.user={};
        alert('恭喜您，注册成功，请完善详细信息！')
      }else{
        alert(resp);
        console.log(resp);
        self.user={};
      }
    })
  }

  self.submit=function(){
    if (self.user.passwd1==self.user.passwd2) {
      self.notSame=false;
      $http.get('http://202.197.190.99:8088/isapi/oauthr.exe/lookausr?usrid='+self.user.userid).then(function(response){
          if (response.data.code==0) {
            self.isExist = false;
            console.log(response.data);
            self.addaUser();
            return true;
          }
          else
          { self.isExist=true;
            console.log(response.data);
            return false;
          }
        }
        ,function(errResponse) {
          console.error('error!');
        });
    }
    else{
      self.notSame=true;
      console.log(self.user);
    }

    //$http.jsonp('http://202.197.190.99:8088/isapi/oauthr.exe/lookausr?jsonp=JSON_CALLBACK&usrid='+self.user.userid).success(function(data){
    //console.log(data.code);
  }
}]);


