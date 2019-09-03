
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>
<%
	int s_id = Integer.parseInt((String)session.getAttribute("id"));
	int c_id = Integer.parseInt((String)request.getParameter("c_id"));
	int c_id_no = Integer.parseInt((String)request.getParameter("c_id_no"));
	String result;
%>
<%
	String []day = {"S_MON","S_TUE","S_WEN","S_THU","S_FRI"};
	String mySQL, mySQL2="";
	Connection myConn = null; 
	String dbdriver = "oracle.jdbc.driver.OracleDriver";
	String dburl = "jdbc:oracle:thin:@localhost:1521:orcl";
	String user = "ggkids";
	String passwd = "ggkids";
	Statement stmt=null;
	
	try{
		Class.forName(dbdriver);
		myConn = DriverManager.getConnection(dburl,user,passwd);
	}catch(SQLException ex){
		System.err.println("SQLException: "+ex.getMessage());
	}
	CallableStatement cstmt, cstmt2 = null;
	cstmt = myConn.prepareCall("{? = call Date2EnrollYear(SYSDATE)}");
    cstmt.registerOutParameter(1, oracle.jdbc.OracleTypes.NUMBER);
    cstmt.executeUpdate();
    int year = cstmt.getInt(1);
    
    
    cstmt = myConn.prepareCall("{? = call Date2EnrollSemester(SYSDATE)}");
    cstmt.registerOutParameter(1, oracle.jdbc.OracleTypes.NUMBER);
    cstmt.executeUpdate();
    int sem = cstmt.getInt(1);
    
	mySQL = "delete from enroll where s_id ='"+s_id+"' and c_id= '"+c_id+"' and c_id_no = '"+c_id_no+"'";
	for(int i=0;i<5;i++){
		mySQL2 = "delete from schedule where s_id="+s_id+" and c_year="+year+" and c_semester="+sem+" and "+day[i]+"="+c_id;
		cstmt2 = myConn.prepareCall(mySQL2);
		cstmt2.execute();
	}
	//stmt = myConn.createStatement();
	//stmt.execute(mySQL);
	cstmt = myConn.prepareCall(mySQL);
	
	try{
		cstmt.execute();
		
%>
<script>
	location.href="delete.jsp";
</script>
<%
	}catch(SQLException ex){
		System.err.println("SQLException: "+ex.getMessage());
		
	}
	finally{
		if(cstmt!=null)
			try{
				cstmt.close();
				cstmt2.close();
				myConn.close();
			}catch(SQLException ex){}
	}
%>
<!DOCTYPE html>
<html>
<body>

</body>
</html>
