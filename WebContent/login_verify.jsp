<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>
<%
String userID=request.getParameter("userID");
String userPassword=request.getParameter("userPassword");
int i=1;
String mySQL;
String mySQL2;
String dbdriver = "oracle.jdbc.driver.OracleDriver";
String dburl = "jdbc:oracle:thin:@localhost:1521:orcl";
String user = "ggkids";
String passwd = "ggkids";
Connection myConn;

Boolean prof=false;

Class.forName(dbdriver);
myConn=DriverManager.getConnection(dburl, user, passwd);

Statement stmt = myConn.createStatement();
if(userID.length()==4){
	prof=true;
	mySQL="select p_id, p_name from professor where p_id='"+userID+"'and p_pwd='"+userPassword+"'";
}else{
	mySQL="select s_id, s_name from student where s_id='" + userID + "'and s_pwd='" + userPassword + "'";
}

ResultSet rs = stmt.executeQuery(mySQL);

if(rs.next()){
	session.setAttribute("id", userID);
	session.setAttribute("userPassword",userPassword);
	if(!prof){
		session.setAttribute("name", rs.getString("s_name"));
		response.sendRedirect("main.jsp");
	}else{
		session.setAttribute("name", rs.getString("p_name"));
		response.sendRedirect("p_main.jsp");
	}
}else{%>
<script>
	alert("아이디나 비밀번호가 틀렸습니다.");
	location.href ="login.jsp";
</script>
	
<%
}
stmt.close();
myConn.close();
%>