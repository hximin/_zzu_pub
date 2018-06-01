adminApp.factory('courseListService',['$http','$window',function($http,$window){
  return {getNewCourses:function(){
    //var mydata={'ptopid':ptopid};
    arandom=Math.random();//增加一个随机数据 ，防止缓存
    return $http.get('http://pub.zzu.edu.cn:8080/pubTeacherA/servlet/NewCourseServlet?select=n'+'&ardm='+arandom);
    //return $http.jsonp('http://pub.zzu.edu.cn:8080/pubTeacherA/servlet/TchCourseServlet?userno=C54730ECED9444F58462C3B6F4E02178');
    //return [{"coursename":"ooooo"},{"coursename":"olllllo"}];
  },
    getHottttCourses:function(){
      arandom=Math.random()
      //var mydata={'ptopid':ptopid};
      return $http.post('http://pub.zzu.edu.cn:8080/pubTeacherA/servlet/NewCourseServlet?select=h&ardm='+arandom,mydata);
    }
  }
}])
