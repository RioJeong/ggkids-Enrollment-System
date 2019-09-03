<%@ page language="java" contentType="text/html; charset=UTF-8"
   pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="EUC-KR">

<head>
<link href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-ggOyR0iXCbMQv3Xipma34MD+dH/1fQ784/j6cY/iJTQUOhcWr7x9JvoRxT2MZw1T" crossorigin="anonymous">
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js" integrity="sha384-JjSmVgyd0p3pXB1rRibZUAYoIIy6OrQ6VrjIEaFf/nJGzIxFDsf4x0xIM+B07jRM" crossorigin="anonymous"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.bundle.min.js" integrity="sha384-xrRywqdh3PHs8keKZN+8zzc5TX0GRTLCcmivcbNJWm2rs5C8PRhcEn3czEjhAO9o" crossorigin="anonymous"></script>
<link href="https://stackpath.bootstrapcdn.com/bootswatch/4.3.1/yeti/bootstrap.min.css" rel="stylesheet" integrity="sha384-w6tc0TXjTUnYHwVwGgnYyV12wbRoJQo9iMlC2KdkdmVvntGgzT9jvqNEF/uKaF4m" crossorigin="anonymous">
<title>시간표 과목 조회</title>
<style type="text/css">
td {
   font-size:17px;
}
.content {
   padding-left:40px !important;
   text-align:left;
}
.semi_title {
   font-weight:bold;
   border-right: 2px solid #dee2e6;
}
</style>
</head>
<body>
<%
   ResultSet myResultSet = null;
   Connection myConn = null;
   Statement stmt = null;
   ResultSet myResultSet2 = null;
   Statement stmt2 = null;
   
 
   String c_id = null; 
    int c_id_no =0; 
    String c_time = null;
    int c_unit =0;
    int p_id = 0;
    String c_room=null;
    String period[] = {"","9:00 ~ 10:00","10:00 ~ 11:00","11:00 ~ 12:00","12:00 ~ 13:00","13:00 ~ 14:00"}; 
   
   int year = Integer.parseInt((String)session.getAttribute("c_year"));
   int semester = Integer.parseInt((String)session.getAttribute("c_semester"));
   String classname = (String)request.getParameter("classname");
   int id = Integer.parseInt((String)session.getAttribute("id"));
   String dbdriver = "oracle.jdbc.driver.OracleDriver";//변수 선언
      String dburl = "jdbc:oracle:thin:@localhost:1521:orcl";
      String user = "ggkids";
      String passwd = "ggkids";
      String mySQL;
      Class.forName(dbdriver);
      myConn=DriverManager.getConnection(dburl, user, passwd);
      stmt = myConn.createStatement();
      mySQL = "SELECT * FROM ENROLL WHERE S_ID = "+id+"AND C_YEAR = "+year+" AND C_SEMESTER = "+semester;
      mySQL = mySQL + " AND C_NAME = '"+classname+"'";
      myResultSet = stmt.executeQuery(mySQL);
      if(myResultSet!=null){
         while (myResultSet.next()) { 
               c_id = myResultSet.getString("c_id"); 
               c_id_no = myResultSet.getInt("c_id_no"); 
               c_time = myResultSet.getString("c_time");
               c_unit = myResultSet.getInt("c_unit");
               c_room=myResultSet.getString("c_room");
         }
      }
      System.out.println(c_time);
      stmt2 = myConn.createStatement();
       String mySQL2 = "select p_name from professor where p_id = (select p_id from teach where c_id = ";
       mySQL2 = mySQL2 + c_id+" and c_year = "+year+" and c_semester = "+semester+" and c_id_no = "+c_id_no+")";
       myResultSet2 = stmt2.executeQuery(mySQL2);
       String out_p_id="";
       if(myResultSet2!=null){
          while (myResultSet2.next()){
             out_p_id = myResultSet2.getString("p_name");
          }
       }
       String out_c_time="";
       String tmp_period[] = c_time.split("/");
       for(int z=0;z<tmp_period.length;z++){
          out_c_time += tmp_period[z].charAt(0);
          int tmp = Integer.parseInt(tmp_period[z].charAt(1)+"");
          out_c_time += period[tmp];
          if(tmp_period.length>1 || z == (tmp_period.length-1)) out_c_time += (" \n ");
       }
       String tmp_c_id = c_id+"";
       String out_c_id = null;
       int len_c_id = tmp_c_id.length();
       if(len_c_id==1) {out_c_id="000"+c_id;}
       else if(len_c_id==2) {out_c_id = "00"+c_id;}
       else if(len_c_id==3) {out_c_id = "0"+c_id;}
       else {out_c_id = c_id;}
       
%>
<table></table>
<!--<h4><%=year %>,<%=semester %>,<%=id %></h4>  -->
<table class="table table" align="center" style="width:95%;" >
<br>
<h3 style="text-align:center;font-weight:bold;"><%=classname%></h3>
<tr class="table-info" style="text-align:center;">
   <th scope="row">구분</th>
   <th scope="row">내용</th>
</tr>
<tr>
   <td align="center" class = "semi_title">과목번호</td> 
   <td align="center" class = "content"><%=out_c_id%></td> 
</tr>
<tr>
   <td align="center" class = "semi_title">담당교수</td> 
   <td align="center" class = "content"><%=out_p_id%></td>
</tr>
<tr>
   <td align="center" class = "semi_title">강의시간</td> 
   <td align="center" class = "content"><%=out_c_time%></td>
</tr>
<tr>
   <td align="center" class = "semi_title">연도</td> 
   <td align="center" class = "content"><%=year%></td>
</tr>
<tr>
   <td align="center" class = "semi_title">학기</td> 
   <td align="center" class = "content"><%=semester%></td>
</tr>
<tr>
   <td align="center" class = "semi_title">분반</td> 
   <td align="center" class = "content"><%=c_id_no%></td>
</tr>
<tr>
   <td align="center" class = "semi_title">학점</td> 
   <td align="center" class = "content"><%=c_unit%></td>
</tr>
<tr>
   <td align="center" class = "semi_title">강의실</td> 
   <td align="center" class = "content"><%=c_room%></td>
</tr>
</body>
</html>