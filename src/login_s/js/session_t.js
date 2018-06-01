/**
 * Created by hxm on 2018/5/12.
 */
var sessionApp=angular.module("sessionApp",[]);
sessionApp.controller("sessionCtrl_s1",['$scope','$window',function(self,w){
  self.user={};
  self.user.name='hhhxxxmm';
  self.user.pass='mmmmmm';
  w.localStorage.setItem("myssn1","my name is hxm!");
  w.localStorage.setItem("myssn3",JSON.stringify(self.user));
  w.sessionStorage.setItem("myssn2","my name is hxm2!");

  self.getsession=function(){
    self.ssn1= w.localStorage.getItem("myssn1");
    self.ssn2= w.sessionStorage.getItem("myssn2");
    self.ssn3= JSON.parse(w.localStorage.getItem("myssn3"));
    console.log(self.ssn3.name);
  }
}])

