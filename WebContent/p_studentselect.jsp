<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="EUC-KR">
<title>수강생조회</title>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link
	href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css"
	rel="stylesheet"
	integrity="sha384-ggOyR0iXCbMQv3Xipma34MD+dH/1fQ784/j6cY/iJTQUOhcWr7x9JvoRxT2MZw1T"
	crossorigin="anonymous">
<script
	src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js"
	integrity="sha384-JjSmVgyd0p3pXB1rRibZUAYoIIy6OrQ6VrjIEaFf/nJGzIxFDsf4x0xIM+B07jRM"
	crossorigin="anonymous"></script>
<script
	src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.bundle.min.js"
	integrity="sha384-xrRywqdh3PHs8keKZN+8zzc5TX0GRTLCcmivcbNJWm2rs5C8PRhcEn3czEjhAO9o"
	crossorigin="anonymous"></script>
<link
	href="https://stackpath.bootstrapcdn.com/bootswatch/4.3.1/yeti/bootstrap.min.css"
	rel="stylesheet"
	integrity="sha384-w6tc0TXjTUnYHwVwGgnYyV12wbRoJQo9iMlC2KdkdmVvntGgzT9jvqNEF/uKaF4m"
	crossorigin="anonymous">
</head>
</head>
<style type="text/css">

</style>
<body>
	<%@ include file="p_top.jsp"%>
	<%
	Statement stmt = null;
	ResultSet rs = null;
	String mySQL=null;
	
	Class.forName(dbdriver);
	Connection myConn = DriverManager.getConnection(dburl, user, passwd);
	stmt = myConn.createStatement();
	
	String c_id=request.getParameter("c_id");
	String c_id_no=request.getParameter("c_id_no");
	String c_year=request.getParameter("c_year");
	String c_sem=request.getParameter("c_semester");
	
	%>
	
	<div style="margin-top:50px;">
	
	<h2 style="font-weight:bold; margin-left:190px;">수강생 정보</h2>
	<table class="table table-hover" align="center"
		style="width: 80%; margin-top:20px;">
		<tr class="table-success" style="text-align: center;">
			<th scope="row">학번</th>
			<th scope="row">이름</th>
		</tr>
		<%
		mySQL="select s.s_id, s.s_name from student s inner join enroll e on e.s_id=s.s_id and e.c_id='"+c_id+"'and e.c_id_no='"+c_id_no+"'and e.c_year='"+c_year+"'and e.c_semester='"+c_sem+"'";
		rs = stmt.executeQuery(mySQL);
		
		while(rs.next()){
			String s_id = rs.getString(1);
			String s_name = rs.getString(2);
		
		%>
		<tr>
		<td align="center"><%=s_id %></td>
		<td align="center"><%=s_name%></td>
		</tr>
		<%} %>
	</table>
	
	<center>
	<span class="badge badge-pill badge-success"
		style="height: 35px; width: 100px; padding: 8px;""> <a style="text-decoration: none; color: white; font-weight: bold; font-size: 15px; "
		href="p_select.jsp">뒤로가기</a>
	</span>
	</center>
	</div>
</body>
	<div style="margin-top: 500px;"></div>
	<%@include file="footer.jsp"%>
</html>