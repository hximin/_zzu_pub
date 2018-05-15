/**
 * Created by hxm on 2018/5/12.
 */
var sessionApp=angular.module("sessionApp",[]);
sessionApp.controller("sessionCtrl",['$scope','$window',function(self,w){
  w.localStorage.setItem("myssn1","my name is hxm!");
  w.sessionStorage.setItem("myssn2","my name is hxm2!");

  self.getsession=function(){
    self.ssn1= w.localStorage.getItem("myssn1");
    self.ssn2= w.sessionStorage.getItem("myssn2");
  }
}])

