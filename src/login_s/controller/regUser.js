/**
 * Created by hxm on 2018/5/2.
 */

angular.module("regApp",[])
  .controller("regCtrl",['$http',function($http){
    var self=this;
    self.isExist=false;
    self.notagree=true;
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
  }])


