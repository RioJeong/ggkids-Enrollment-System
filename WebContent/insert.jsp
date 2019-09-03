<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.text.SimpleDateFormat"%>
<html>
<head><title>수강신청 입력</title>
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
<div class="row" style="float:left;width:50%;margin-left:50px;margin-top:20px;margin-bottom:20px;">
   <div class="form-group1" style="width:25%; display:block;" >
       <select id="form_year" class="custom-select">
         <option selected="year">연도</option>
         <option value="2019">2019</option>
         <option value="2018">2018</option>
         <option value="2017">2017</option>
       </select>
     </div>
   <div class="form-group2" style="width:25%; display:block;margin-left:10px;" >
       <select id="form_seme" class="custom-select">
         <option selected="sem">학기</option>
         <option value="1">1</option>
         <option value="2">2</option>
       </select>
     </div>
<input type="button" onclick="button_click();" value="검색" style="display:block; margin-left:10px;" class="btn btn-primary"/>
</div>

<script type="text/javascript">
   function button_click(){ 
       var target_seme = document.getElementById("form_seme");
       var tmp_target_seme = target_seme.options[target_seme.selectedIndex].value;
       var target_year = document.getElementById("form_year");
       var tmp_target_year = target_year.options[target_year.selectedIndex].value;
       if(tmp_target_year!="연도" && tmp_target_seme!="학기") {
          //location.href("insert.jsp?session_sem="+tmp_target_seme+"&session_year="+tmp_target_year);
          location.href="insert.jsp?session_sem="+tmp_target_seme+"&session_year="+tmp_target_year;
          }
       else alert("입력을 확인하세요");
       
   }
</script>

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
   <th scope="row">정원</th>
   <th scope="row">신청</th>
   <th scope="row">여석</th>
   <th scope="row">수강신청</th>
</tr>
<%
 int i=1;
 int result;
 int result2;
 int result_length;
 Connection myConn = null;
 Statement stmt = null;
 Statement stmt2 = null;
 ResultSet myResultSet = null;
 ResultSet myResultSet2 = null;
 CallableStatement cstmt = null;
 
 String get_sem = request.getParameter("session_sem");
 String get_year = request.getParameter("session_year");
 
 String out_c_id="";
 String mySQL = "";

 String period[] = {"","9:00 ~ 10:00","10:00 ~ 11:00","11:00 ~ 12:00","12:00 ~ 13:00","13:00 ~ 14:00"}; 
 
try {
Class.forName(dbdriver); myConn =  DriverManager.getConnection (dburl, user, passwd); 
stmt = myConn.createStatement();
} catch(SQLException ex) { System.err.println("SQLException: " + ex.getMessage()); } 

PreparedStatement pstmt = myConn.prepareStatement("select * from teach where c_year=? and c_semester=? order by c_id asc");


if(get_sem==null && get_year==null) {
   cstmt = myConn.prepareCall("{? = call Date2EnrollSemester(SYSDATE)}");
   cstmt.registerOutParameter(1, oracle.jdbc.OracleTypes.NUMBER);
   cstmt.executeUpdate();
   get_sem = Integer.toString(cstmt.getInt(1));
  
   cstmt = myConn.prepareCall("{? = call Date2EnrollYear(SYSDATE)}");
   cstmt.registerOutParameter(1, oracle.jdbc.OracleTypes.NUMBER);
   cstmt.executeUpdate();
   get_year = Integer.toString(cstmt.getInt(1));
   
   pstmt.setString(1,get_year);
   pstmt.setString(2, get_sem);
   myResultSet = pstmt.executeQuery();
}
else {

   if((get_sem!=null && get_year!=null) || (!get_sem.equals("null")) && !get_year.equals("null")){
	   pstmt.setString(1,get_year);
	   pstmt.setString(2, get_sem);
	   myResultSet = pstmt.executeQuery();
         }
   else if((get_sem!=null && get_year==null)|| (!get_sem.equals("null")) && get_year.equals("null")) {
      mySQL = "SELECT * FROM TEACH WHERE C_SEMESTER = "+get_sem+" ORDER BY C_ID ASC";
      myResultSet = stmt.executeQuery(mySQL);
   }
   else if((get_sem==null && get_year!=null) || (get_sem.equals("null")) && !get_year.equals("null")){
      mySQL = "SELECT * FROM TEACH WHERE C_YEAR = "+get_year+" ORDER BY C_ID ASC";
      myResultSet = stmt.executeQuery(mySQL);
   }
   
}
   if (myResultSet != null) { 
      while (myResultSet.next()) { 
         String c_id = myResultSet.getString("c_id"); 
         int p_id = myResultSet.getInt("p_id");
         int c_id_no = myResultSet.getInt("c_id_no"); 
         String c_time = myResultSet.getString("c_time");
         String c_name = myResultSet.getString("c_name"); 
         int c_unit = myResultSet.getInt("c_unit"); 
         int c_year = myResultSet.getInt("c_year");
         int c_semester = myResultSet.getInt("c_semester");
         String c_room = myResultSet.getString("c_room");
         int c_max =  myResultSet.getInt("c_max");
       result_length = c_id.length();
       cstmt = myConn.prepareCall("{? = call Date2EnrollYear(SYSDATE)}");
       cstmt.registerOutParameter(1, oracle.jdbc.OracleTypes.NUMBER);
       cstmt.executeUpdate();
       result = cstmt.getInt(1);
       
       
       cstmt = myConn.prepareCall("{? = call Date2EnrollSemester(SYSDATE)}");
       cstmt.registerOutParameter(1, oracle.jdbc.OracleTypes.NUMBER);
       cstmt.executeUpdate();
       result2 = cstmt.getInt(1);
       
       if(result_length==1) {out_c_id="000"+c_id;}
       else if(result_length==2) {out_c_id = "00"+c_id;}
       else if(result_length==3) {out_c_id = "0"+c_id;}
       else {out_c_id = c_id;}
       
       stmt2 = myConn.createStatement();
       String mySQL2 = "SELECT P_NAME FROM PROFESSOR WHERE P_ID = "+p_id;
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
       
       int student_cnt=0;
       mySQL2 = "select count(*) from enroll where c_id='"+c_id+"'and c_id_no="+c_id_no+"and c_year="+c_year+"and c_semester="+c_semester;
   	   myResultSet2 = stmt2.executeQuery(mySQL2);
   	   if(myResultSet2!=null){
   		while (myResultSet2.next()){
            student_cnt = myResultSet2.getInt(1);
         }
   	   }
   %>
   <tr> 
   <td align="center"><%= out_c_id %></td> 
   <td align="center"><%= c_id_no %></td> 
   <td align="center"><%= c_name %></td>
   <td align="center"><%= out_p_id %></td>
   <td align="center"><%= out_c_time %></td>
   <td align="center"><%= c_room %></td>
   <td align="center"><%= c_unit %></td>
   <td align="center"><%= c_year %></td>
   <td align="center"><%= c_semester %></td>
   <td align="center"><%= c_max %></td>
   <td align="center"><%= student_cnt %></td>
   <td align="center"><%= c_max-student_cnt %></td>
   <%
      if(c_year == result && c_semester == result2) {
   %> 
      <td align="center">
         <span class="badge badge-pill badge-info" style="height:30px;width:50px;padding:8px; ">
            <a align="center" style="text-decoration:none;color:white;font-weight:bold;font-size:15px;" href="insert_verify.jsp?c_id=<%= c_id %>&c_id_no=<%= c_id_no %>">신청</a>
         </span>
         </td> 
         </tr>
   <%
      }
   
      
   }
} 
   if(cstmt!=null)
      try{
         myConn.commit();
         cstmt.close();
         myConn.close();
         stmt.close();
         stmt2.close();
      }catch(SQLException ex){}

%> </table>
<h4 style="position:absolute;right:150px;top:100px;font-weight:bold;font-size:30px;"> <%=get_year%> 년 <%=get_sem%> 학기</h4>
 <div style="margin-top: 100px;"></div>
 <%@include file="footer.jsp"%>
</body></html> 