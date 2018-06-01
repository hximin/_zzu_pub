/**
 * Created by hxm on 2018/5/18.
 */

adminApp.factory('userListService',['$http','$window',function($http,$window){
  return {getUsers:function(utb,ptopid){
    var mydata={'ptopid':ptopid};
    arandom=Math.random();//增加一个随机数据 ，防止缓存
    return $http.post('http://pub.zzu.edu.cn:8088/isapi/oauthr.exe/getregusers?t='+utb+'&ardm='+arandom,mydata);
  },
  delUser:function(uid,res,ptopid){
    var mydata={'ptopid':ptopid};
    return $http.post('http://pub.zzu.edu.cn:8088/isapi/oauthr.exe/deluser?uid='+uid+'&res='+res,mydata);
  }
  }
}])


