/**
 * Created by hxm on 2018/5/12.
 */
var sessionApp=angular.module("sessionApp",[]);
sessionApp.controller("sessionCtrl",['$http','$scope','$window',function($http,$scope,w){
  $scope.ssn1="";
  $scope.$watch('ssn1',function(newssn1,oldssn1){
    $scope.newssn1=newssn1;
    $scope.oldssn1=oldssn1;
  });
  $scope.getsession=function(){
    var hash = CryptoJS.SHA256("appkey=5f03a35d00ee52a21327ab048186a2c4&random=7226249334&time=1457336869&mobile=13788888888");
    alert(hash);
    $scope.ssn1= w.localStorage.getItem("myssn1");
    $scope.ssn2= w.sessionStorage.getItem("myssn2");

  };

    $scope.smspkg2={
    "ext": "hhhh",
    "extend": "",
    "params": ["1111"],
    "sig": "ecab4881ee80ad3d76bb1da68387428ca752eb885e52621a3129dcf4d9bc4fd4",
    "sign": "",
    "tel": {
      "mobile": "13203881161",
      "nationcode": "86"
    },
    "time": 1457336869,
    "tpl_id": 120578
  };
  $scope.smspkg2.time=Math.ceil(new Date().valueOf()/1000);
  $scope.sendsms=function(){
    var arandom=Math.ceil(Math.random()*100000);
    var strrandom="random="+arandom+"&";
    var strappid="appkey=1ad520885f2aa08102a39951b593f8ed&";
    var strtime="time="+$scope.smspkg2.time+"&";
    var strmobile="mobile="+$scope.myphoneNum;
    var qstr=strappid+strrandom+strtime+strmobile;
    $scope.smspkg2.sig= CryptoJS.SHA256(qstr).toString();
    alert(qstr);
    console.log(qstr);
    alert($scope.smspkg2.sig);
    $http.post("https://yun.tim.qq.cofm/v5/tlssmssvr/sendsms?sdkappid=1400090894&random="+arandom,$scope.smspkg2).then(function(response){
      console.log($scope.smspkg2.sig);
      console.log(response.data);
    },function(errresponse){
      console.log("pp");
      console.log(errresponse);
    });
  };
  $scope.sms={};
  $scope.sms.ext="hello hh!";
  $scope.sms.userkey="LFTAPP01_38FC87EA23";
  $scope.sms.phonenum='15515937309';
  $scope.sms.time=Math.ceil(new Date().valueOf()/1000);
  $scope.sendsms2=function(){
    console.log($scope.sms);
    $http.post("http://pub.zzu.edu.cn:8088/isapi/oauthr.exe/sendsms",$scope.sms).then(function(response){
      console.log($scope.sms);
      console.log(response.data);
    },function(errresponse){
      console.log("pp");
      console.log(errresponse);
    });
  };

  $scope.mobileUser={};
  $scope.mobileUser.userkey="LFTAPP01_38FC87EA23";
  $scope.mobileUser.mobile="13203881161";
  $scope.mobileUser.vcode="1320";
  $scope.reg_login=function(){
    console.log($scope.mobileUser);
    $http.post("http://pub.zzu.edu.cn:8088/isapi/oauthr.exe/appReg",$scope.mobileUser).then(function(response){
      console.log(response.data);
    },function(errresponse){
      console.log("appReg");
      console.log(errresponse);
    });
  }
}])

