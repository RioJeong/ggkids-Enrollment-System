<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>

<html>
<body>
<% 
	String sender_id = (String)session.getAttribute("sender_id");
 	
	request.setCharacterEncoding("UTF-8");
	String m_title = (String)request.getParameter("m_title");
	String m_text= (String)request.getParameter("m_text");
	String m_time= (String)request.getParameter("m_time");
	int m_p_id = Integer.parseInt((String)request.getParameter("m_p_id"));

	if(sender_id == null) response.sendRedirect("login.jsp"); 
	
	%>

<%

try{
	String dbdriver = "oracle.jdbc.driver.OracleDriver";
	String dburl = "jdbc:oracle:thin:@localhost:1521:orcl";
	String user = "ggkids";
	String passwd = "ggkids";

	Class.forName(dbdriver);
	Connection myConn = DriverManager.getConnection(dburl, user, passwd);

	Statement stmt = myConn.createStatement();
	String mySQL = "UPDATE MESSAGE SET M_CHECKED = 1 WHERE M_TITLE='"+m_title;
	mySQL = mySQL + "' and M_TEXT='"+m_text+"' and M_SENDTIME='"+m_time+"' and M_SENDER='"+m_p_id+"'";
	System.err.println("&&&&&"+mySQL);
	stmt.executeQuery(mySQL);
	%>
<script>
	alert("메시지를 읽음 처리하였습니다.");
	window.close();
</script>	
<%	
	
	myConn.commit();
	stmt.close();
	myConn.close();
}catch(SQLException ex){
	%>
<script>
	alert("메시지 읽음 처리에 실패하였습니다. \n 제목이나 내용의 길이를 확인하세요.");
	window.close();
</script>
<% 
	System.err.println("SQLException: "+ex.getMessage());
}

%>
</body>
</html>