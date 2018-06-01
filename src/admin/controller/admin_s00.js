/**
 * Created by hxm on 2018/5/18.
 */


loginApp.controller("loginCtrl_oooo",['$http','$scope','$cookieStore',function($http,$scope,cookieStore){
    var self=this;
    self.user={};
//供退出按钮调用
  $scope.removeCookie=function(cookiename){
      cookieStore.remove(cookiename);
      self.user={};
      self.my_incfile1 = 'log_inc.html';
  };
// init first page
  $scope.loggedInCookie=cookieStore.get('_pub_user_ck');
  if ($scope.loggedInCookie==null){
    self.my_incfile1 = 'log_inc.html';
  }
  else
  {
    if ($scope.loggedInCookie._isLoggedIn) {
      self.my_incfile1='userinfo_inc.html';
    }else
    {
      self.my_incfile1 = 'log_inc.html';
    }
  }//以上是loginCtrl

  self.submit=function() {
      console.log(self.user);
      $http.post('http://202.197.190.99:8088/isapi/Oauthr.exe/login',self.user).then(function(resp){
        console.log(resp.data);
        if (resp.data.code==0){
          self.isLoggedIn=true;
          self.ptopid=resp.data.ptopid;
        }else{
          self.isLoggedIn=false;
        }
        if (self.isLoggedIn){
          self.my_incfile1='userinfo_inc.html';
          self.user._isLoggedIn=true;
          self.user._usertype=resp.data.userType;
          self.user._nickname=resp.data.nickName;
          self.user._grade=resp.data.userGrade;
          self.user._logintimes=resp.data.loginTimes;
          self.user._myurl=resp.data.myurl;
          self.user._myurlname=resp.data.myurlname;
          self.user._msg='0';
          self.user._money=resp.data.money;
          self.user._photo='images/user_1.png';
          cookieStore.put('_pub_user_ck',self.user);
          $scope.loggedInCookie=cookieStore.get('_pub_user_ck');
        }
        else
        {
          self.user={};
          alert('登录失败！')

        }
      });
    }
}]);
loginApp.component("loginCom", {
    templateUrl: "log_inc.html",
    controller: function ($scope) {

    }
});

loginApp.factory("loginService",['$http',function($http){
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

loginApp.controller("regCtrloooo",['$http',function($http){
  var self=this;
  var isExist=false;
  var notSame=false;
  self.user={};

  self.addaUser=function(){
    if (self.user.mobile==null) {self.user.mobile="";};
    $http.post('http://202.197.190.99:8088/isapi/oauthr.exe/addAUsr',self.user).then(function(resp){
      switch(resp.data.code)
      {
        case '0':
          self.user={};
          alert('恭喜您，注册成功，请完善详细信息！');
          break;
        default:
          alert(resp.data.errmsg);
          console.log(resp);
      }
    })
  }
  self.regSubmit=function(){
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
  }
}]);


