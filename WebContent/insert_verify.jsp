

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>
<%
	int s_id = Integer.parseInt((String)session.getAttribute("id"));
	int c_id = Integer.parseInt((String)request.getParameter("c_id"));
	int c_id_no = Integer.parseInt((String)request.getParameter("c_id_no"));
	String result;
%>
<%
	String mySQL;
	Connection myConn = null; 
	String dbdriver = "oracle.jdbc.driver.OracleDriver";
	String dburl = "jdbc:oracle:thin:@localhost:1521:orcl";
	String user = "ggkids";
	String passwd = "ggkids";
	
	try{
		Class.forName(dbdriver);
		myConn = DriverManager.getConnection(dburl,user,passwd);
	}catch(SQLException ex){
		System.err.println("SQLException: "+ex.getMessage());
	}
	
	mySQL = "{call INSERTENROLL(?,?,?,?)}";
	CallableStatement cstmt = myConn.prepareCall(mySQL);
	cstmt.setInt(1,s_id);
	cstmt.setInt(2,c_id);
	cstmt.setInt(3,c_id_no);
	cstmt.registerOutParameter(4, java.sql.Types.VARCHAR);	
	
	try{
		cstmt.execute();
		result=cstmt.getString(4);
		System.out.println(result);
%>
<script>
	alert("<%= result%>");
	location.href="insert.jsp";
</script>
<%
	}catch(SQLException ex){
		System.err.println("SQLException: "+ex.getMessage());
	}
	finally{
		if(cstmt!=null)
			try{
				myConn.commit();
				cstmt.close();
				myConn.close();
			}catch(SQLException ex){}
	}
%>
<!DOCTYPE html>
<html>
<body>

</body>
</html>