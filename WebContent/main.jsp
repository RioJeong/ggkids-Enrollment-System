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

<style type="text/css">
.title{
   text-align:center;
   font-weight: 600;
   margin-top: 30px; 
   margin-bottom: 40px;
}
th {
   font-weight: bold;
   font-size: 20px;
   width:150px;
}
td {
   width:150px;
   height:100px;
   font-size:17px;
   text-align:center;
   vertical-align:middle !important;
   border-right: 2px solid #dee2e6;
}
table {
}
.period {
   font-weight:bold;
   font-size:17px;
}
</style>
<meta charset="utf-8">

<title>데이터베이스를 활용한 수강신청 시스템입니다.</title>
</head>
<body>
   <%@include file="top.jsp"%>
   <%String sname = (String)session.getAttribute("name"); 
   ResultSet myResultSet = null;
   Connection myConn = null;
   Statement stmt = null;
   session_id=(String)session.getAttribute("id");
   

   String mySQL;
   Class.forName(dbdriver);
   myConn=DriverManager.getConnection(dburl, user, passwd);
   stmt = myConn.createStatement();
   CallableStatement cstmt = null;
   cstmt = myConn.prepareCall("{? = call Date2EnrollYear(SYSDATE)}");
    cstmt.registerOutParameter(1, oracle.jdbc.OracleTypes.NUMBER);
    cstmt.executeUpdate();
    int year = cstmt.getInt(1);
    String str_year = year+"";
    
    
    cstmt = myConn.prepareCall("{? = call Date2EnrollSemester(SYSDATE)}");
    cstmt.registerOutParameter(1, oracle.jdbc.OracleTypes.NUMBER);
    cstmt.executeUpdate();
    int sem = cstmt.getInt(1);
    String str_sem = sem+"";
   
    
    session.setAttribute("c_year",str_year);
   session.setAttribute("c_semester",str_sem);
   session.setAttribute("id",session_id);
   %>
   <h1 class="title" style="margin:30px;"><%=year %>년도 <%=sem %>학기 시간표</h1>
   <table class="table table-hover" align="center" style="width: 90%; margin-top: 50px;">
      <tr class="table-active" style="text-align: center;">
         <th sc="row">시간표</th>
         <th>월</th>
         <th>화</th>
         <th>수</th>
         <th>목</th>
         <th>금</th>
      </tr>

      <%
  
   
   String tmp_class="";
   String []random_color = new String[24];
   %>
      <%
   
   String []day = {"S_MON","S_TUE","S_WEN","S_THU","S_FRI"};
   String []time={"9:00~10:00","10:00~11:00","11:00~12:00","12:00~13:00","13:00~14:00"};
   String []color={"red","green","blue","yellow"};
   for(int i_per=1;i_per<=5;i_per++){
      %>
      <tr>
         <td align="center" class="period"><%=i_per%>교시 (<%=time[i_per-1]%>)</td>
         <%int c=0;
       for(int i_day=0;i_day<5;i_day++) {
        tmp_class="";
         mySQL = "SELECT "+day[i_day]+" FROM SCHEDULE WHERE S_ID = "+session_id+" and C_YEAR = "+year
               +"and C_SEMESTER = "+sem+"and S_PERIOD = "+i_per+"and "+day[i_day]+" IS NOT NULL";
         mySQL = "SELECT C_NAME FROM TEACH WHERE C_YEAR="+year+" and C_SEMESTER="+sem+
        		 " and C_ID_NO=1 and C_ID = ("+mySQL+")";
         myResultSet = stmt.executeQuery(mySQL);
         if (myResultSet != null) { 
               while (myResultSet.next()) {
                  tmp_class = myResultSet.getString("C_NAME");
                  if(tmp_class==null) tmp_class="";
               }
         }
         %>
      
      
         <td align="center" id="row" onclick="func('<%=tmp_class %>');"><%=tmp_class%></td>
         <%   
         
         }%>
      </tr>

      <%
   }
%>
   </table>
   <script>
      var window=null;
      function func(tmp){
         if(tmp=="") alert("강의가 없습니다.");
         else window.open("popup.jsp?classname="+tmp,"a","width=400, height=350, left=500, top=50");
      }
      
   </script>
   <div style="margin-top:250px;"></div>
</body>
<%@include file="footer.jsp"%>
</html>