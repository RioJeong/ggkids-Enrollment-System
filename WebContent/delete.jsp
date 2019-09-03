<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.text.SimpleDateFormat"%>
<!DOCTYPE html>
<html>
<head>
<title>수강 신청 삭제</title>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-ggOyR0iXCbMQv3Xipma34MD+dH/1fQ784/j6cY/iJTQUOhcWr7x9JvoRxT2MZw1T" crossorigin="anonymous">
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js" integrity="sha384-JjSmVgyd0p3pXB1rRibZUAYoIIy6OrQ6VrjIEaFf/nJGzIxFDsf4x0xIM+B07jRM" crossorigin="anonymous"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.bundle.min.js" integrity="sha384-xrRywqdh3PHs8keKZN+8zzc5TX0GRTLCcmivcbNJWm2rs5C8PRhcEn3czEjhAO9o" crossorigin="anonymous"></script>
<link href="https://stackpath.bootstrapcdn.com/bootswatch/4.3.1/yeti/bootstrap.min.css" rel="stylesheet" integrity="sha384-w6tc0TXjTUnYHwVwGgnYyV12wbRoJQo9iMlC2KdkdmVvntGgzT9jvqNEF/uKaF4m" crossorigin="anonymous">
</head>
<body>
<%@ include file="top.jsp" %>
<% 
session_id = (String)session.getAttribute("id"); %>
<% if(session_id == null) response.sendRedirect("login.jsp"); %>

<table class="table table-hover" align="center" style="width:95%;" >
<br>
<tr class="table-info" style="text-align:center;">

   <th scope="row">과목번호</th>
   <th scope="row">분반</th>
   <th scope="row">과목명</th>
   <th scope="row">담당교수</th>
   <th scope="row">강의시간</th>
   <th scope="row">강의실</th>
   <th scope="row">학점</th>
   <th scope="row">연도</th>
   <th scope="row">학기</th>
   <th scope="row">삭제</th>
</tr>
<%
String queryEnroll = "";
String queryTeach = "";
String queryProfessor = "";
String p_id = "";
String p_name = "";
Statement stmt = null;
Statement stmtTeach = null;
Statement stmtProfessor = null;
ResultSet rs = null;
ResultSet rsTeach = null;
ResultSet rsProfessor = null;
CallableStatement cstmt = null;

int result, result2;

String period[] = {"","9:00 ~ 10:00","10:00 ~ 11:00","11:00 ~ 12:00","12:00 ~ 13:00","13:00 ~ 14:00"}; 

Class.forName(dbdriver);
Connection myConn = DriverManager.getConnection(dburl, user, passwd);

try{
   cstmt = myConn.prepareCall("{? = call Date2EnrollYear(SYSDATE)}");
    cstmt.registerOutParameter(1, oracle.jdbc.OracleTypes.NUMBER);
    cstmt.executeUpdate();
    result = cstmt.getInt(1);
    
    
    cstmt = myConn.prepareCall("{? = call Date2EnrollSemester(SYSDATE)}");
    cstmt.registerOutParameter(1, oracle.jdbc.OracleTypes.NUMBER);
    cstmt.executeUpdate();
    result2 = cstmt.getInt(1);
   
   queryEnroll = "SELECT * FROM ENROLL WHERE S_ID = '"+session_id+"' and C_YEAR = "+Integer.toString(result)+" and C_SEMESTER = "+Integer.toString(result2)+"ORDER BY C_ID ASC";
   stmt = myConn.createStatement();
   rs = stmt.executeQuery(queryEnroll);
   
   while(rs.next()){
      
      queryTeach = "select p_id from teach where c_id = '"+rs.getString("c_id")+"' and c_id_no = '"+rs.getString("c_id_no")+"' and c_year = '" + rs.getString("c_year")+"' and c_semester = '"+rs.getString("c_semester")+"'";
      stmtTeach = myConn.createStatement();
      rsTeach = stmtTeach.executeQuery(queryTeach);
      
      while(rsTeach.next()){
         p_id = rsTeach.getString("p_id");
      }
      queryProfessor = "select p_name from professor where p_id = '"+p_id+"'";
      stmtProfessor = myConn.createStatement();
      rsProfessor = stmtProfessor.executeQuery(queryProfessor);
      while(rsProfessor.next()){
         p_name = rsProfessor.getString("p_name");
      }
      
      String out_c_time="";
      String c_time = rs.getString("c_time");
         String tmp_period[] = c_time.split("/");
       for(int z=0;z<tmp_period.length;z++){
          out_c_time += tmp_period[z].charAt(0);
            int tmp = Integer.parseInt(tmp_period[z].charAt(1)+"");
            out_c_time += period[tmp];
          if(tmp_period.length>1 || z == (tmp_period.length-1)) out_c_time += (" \n ");
       }
       
       String out_c_id="";
       if(rs.getString("c_id").length() == 1 ) {out_c_id="000"+rs.getString("c_id");}
       else if(rs.getString("c_id").length() == 2) {out_c_id = "00"+rs.getString("c_id");}
       else if(rs.getString("c_id").length() == 3) {out_c_id = "0"+rs.getString("c_id");}
       else {out_c_id = rs.getString("c_id");}
      
%>

   <tr>
      <td align="center"><%=out_c_id %></td>
      <td align="center"><%=rs.getString("c_id_no") %></td>
      <td align="center"><%=rs.getString("c_name") %></td>
      <td align="center"><%=p_name %></td>
      <td align="center"><%=out_c_time %></td>
      <td align="center"><%=rs.getString("c_room") %></td>
      <td align="center"><%=rs.getString("c_unit") %></td>
      <td align="center"><%=rs.getString("c_year") %></td>
      <td align="center"><%=rs.getString("c_semester") %></td>
      <td align="center">
         <span class="badge badge-pill badge-info" style="height:30px;width:50px;padding:8px; ">
            <a align="center" style="text-decoration:none;color:white;font-weight:bold;font-size:15px;" href="delete_execute.jsp?c_id=<%= rs.getString("c_id") %>&c_id_no=<%=rs.getString("c_id_no") %>">삭제</a>
         </span>
         </td> 
   </tr>
<%
   }
}catch(SQLException ex){
   out.println(ex.getMessage());
   ex.printStackTrace();
}finally{
   if(rs!=null) try{rs.close();}catch(SQLException ex){}
   if(stmt!=null)try{stmt.close();}catch(SQLException ex){}
   if(rsTeach!=null)try{rsTeach.close();}catch(SQLException ex){}
   if(stmtTeach!=null)try{stmtTeach.close();}catch(SQLException ex){}
   if(rsProfessor!=null) try{rsProfessor.close();}catch(SQLException ex){}   
   if(stmtProfessor!=null)try{stmtProfessor.close();}catch(SQLException ex){}
   if(myConn!=null) try{myConn.close();}catch(SQLException ex){}
}
%>
</table>
<div style="margin-top: 580px;"></div>
 <%@include file="footer.jsp"%>
</body>
</html>