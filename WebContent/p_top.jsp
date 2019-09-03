<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="utf-8">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">

<link href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-ggOyR0iXCbMQv3Xipma34MD+dH/1fQ784/j6cY/iJTQUOhcWr7x9JvoRxT2MZw1T" crossorigin="anonymous">
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js" integrity="sha384-JjSmVgyd0p3pXB1rRibZUAYoIIy6OrQ6VrjIEaFf/nJGzIxFDsf4x0xIM+B07jRM" crossorigin="anonymous"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.bundle.min.js" integrity="sha384-xrRywqdh3PHs8keKZN+8zzc5TX0GRTLCcmivcbNJWm2rs5C8PRhcEn3czEjhAO9o" crossorigin="anonymous"></script>
<link href="https://stackpath.bootstrapcdn.com/bootswatch/4.3.1/yeti/bootstrap.min.css" rel="stylesheet" integrity="sha384-w6tc0TXjTUnYHwVwGgnYyV12wbRoJQo9iMlC2KdkdmVvntGgzT9jvqNEF/uKaF4m" crossorigin="anonymous">

<link href="https://fonts.googleapis.com/css?family=Noto+Sans+KR:100,300,400,500,700,900&display=swap&subset=korean" rel="stylesheet">
</head>

<style type="text/css">
body{
	font-family: "Noto Sans KR";
}
.nav-link{
	color:white;
}
.nav-item{

	margin-left:40px;
	margin-right:40px;
}
.navbar{
	margin: 0px 0px 0px 0px;
	padding: 10px;
	background:#43AC6A;
}

</style>
<%
String session_id = (String) session.getAttribute("id");
String name = (String) session.getAttribute("name");
String log;
if (session_id == null)
log = "<a href=login.jsp style=\"text-decoration:none; color:black;\">로그인</a>";
else log = "<a href=logout.jsp style=\"text-decoration:none; color:black;\">로그아웃</a>"; %>
<body>
<nav class="navbar navbar-expand-lg">
  <a href="p_main.jsp"><img src="./logo.png" width="240px" height="60px" style="margin-left:30px;"/></a>

  <div class="collapse navbar-collapse" id="navbarColor01" style="margin-left:180px;" >
    <ul class="navbar-nav mr-auto" style="font-size:20px; font-weight:400;">
      <li class="nav-item">
      	<a class="nav-link" href="p_information.jsp">교수 정보</a>
      </li>
      <li class="nav-item">
      	<a class="nav-link" href="p_course_update.jsp">강의 편집</a>
      </li>
      <li class="nav-item">
        <a class="nav-link" href="p_select.jsp">강의 조회</a>
      </li>
       <li class = "nav-item">
         <a class="nav-link" href="p_message.jsp">메시지함</a>
      </li>
    </ul>
    <% if(session_id!=null){%>
  		<span style="font-size:1.5em; color:white;"><%=name %>님</span>
  	<%}%>
    <button class="btn btn-secondary" style="margin-left:30px;"><%=log %></button>
  </div>
</nav>
<%
ResultSet myResultSet3 = null;
Statement stmt3 = null;
Connection myConn3 = null;
String dbdriver = "oracle.jdbc.driver.OracleDriver";//변수 선언
String dburl = "jdbc:oracle:thin:@localhost:1521:orcl";
String user = "ggkids";
String passwd = "ggkids";
String mySQL3;
Class.forName(dbdriver);
myConn3=DriverManager.getConnection(dburl, user, passwd);
stmt3 = myConn3.createStatement();
mySQL3 = "select count (*) as count from message where m_receiver='"+session_id+"' and m_checked=0";
myResultSet3 = stmt3.executeQuery(mySQL3);
if (myResultSet3 != null) { 
    while (myResultSet3.next()) { 
   if(myResultSet3.getInt("COUNT")>0){
      %>
      <a href="p_message.jsp"><img src="p_new_message_icon.png" style="position:fixed;right:50px;bottom:30px;" width=120px height=115px></a>
      <%    
   }
   else {
   %>
   <a href="p_message.jsp"><img src="p_message_icon.png" style="position:fixed;right:50px;bottom:30px;" width=100px height=100px></a>
   <%
    }
}
}

%>
</body>
</html>
