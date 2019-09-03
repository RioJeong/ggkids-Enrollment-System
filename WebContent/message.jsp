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
<meta charset="utf-8">

<title>메시지함</title>
</head>
<body>
   <%@include file="top.jsp"%>
   <%
   ResultSet myResultSet = null;
   ResultSet myResultSet2 = null;
   Statement stmt2 = null;
   Connection myConn = null;
   Statement stmt = null;
   session_id=(String)session.getAttribute("id");
   session.setAttribute("sender_id",session_id);
   
   //String dbdriver = "oracle.jdbc.driver.OracleDriver";//변수 선언
   //String dburl = "jdbc:oracle:thin:@localhost:1521:orcl";
   //String user = "ggkids";
   //String passwd = "ggkids";
   String mySQL;
   Class.forName(dbdriver);
   myConn=DriverManager.getConnection(dburl, user, passwd);
   stmt = myConn.createStatement();   
   %>
   <!--center><h1 style="margin:50px;font-weight:bold;">메시지 전송</h1></center-->
<center style="margin:60px;">
<div class="card border-primary mb-3" style="max-width: 50rem; text-align:left;margin:60px; margin-bottom:70px;">
  <div class="card-header" style="font-size:25px;font-weight:bold; text-align:center;">메시지 전송</div>
  <div class="card-body">
<form method="post" action="message_verify.jsp">
<fieldset>
   <div class="form-group" >
      <label for="exampleSelect2" style="font-size:20px;font-weight:bold;">수신자 선택</label>
      <select multiple="" class="form-control" id="exampleSelect2" height="60px" name="receiver">
      <%
      	mySQL = "select p_id, p_name from professor order by p_name asc";
      	myResultSet = stmt.executeQuery(mySQL);
      	while(myResultSet.next()){
      		int p_id = myResultSet.getInt(1);
      		String p_name = myResultSet.getString(2);
      	
      %>
      	<option value="<%= p_id%>"><%=p_name%></option>
      	<%} %>
      </select>
    </div>
    <div class="form-group">
    	<label class="col-form-label" for ="inputDefault" style="font-size:20px;font-weight:bold;">
    	제목</label>
    	<input type="text" name="title" class="form-control" placeholder="제목을 입력하세요" id="inputDefault">
    </div>
    <div class="form-group">
      <label for="exampleTextarea" style="font-size:20px;font-weight:bold;">보낼 메시지</label>
      <textarea class="form-control" name="text" id="exampleTextarea" rows="6" placeholder="내용을 입력하세요"></textarea>
    </div>
  </fieldset>
  <center><button type="submit" class="btn btn-primary" align="center" style="font-weight:bold;width:60px;">전송</button></center>
</form>
<%
	
%>
   </center>

<center><h1 style="font-weight:bold;">메시지 보관함</h1></center>   
<table class="table table-hover" align="center" style="width:95%;" >
<br>
<tr class="table-info" style="text-align:center;">
	<th scope="row">읽음</th>
   <th scope="row">보낸사람</th>
   <th scope="row">시간</th>
   <th scope="row">제목</th>
   </tr>
   <%
   mySQL = "SELECT * FROM MESSAGE WHERE M_RECEIVER = "+session_id +"ORDER BY M_SENDTIME DESC";
   myResultSet = stmt.executeQuery(mySQL);
   if (myResultSet != null) { 
      while (myResultSet.next()) { 
    	 int m_checked = myResultSet.getInt("m_checked");
         int m_sender = myResultSet.getInt("m_sender"); 
         String m_sendtime = myResultSet.getString("m_sendtime");
         String m_title = myResultSet.getString("m_title");
         String m_text = myResultSet.getString("m_text");
         String str_m_checked = "안읽음";
         if(m_checked!=0) str_m_checked="읽음"; 
         
         stmt2 = myConn.createStatement();
         String mySQL2 = "SELECT P_NAME FROM PROFESSOR WHERE P_ID = "+m_sender;
         myResultSet2 = stmt2.executeQuery(mySQL2);
         String out_p_id="";
         if(myResultSet2!=null){
            while (myResultSet2.next()){
               out_p_id = myResultSet2.getString("p_name");
            }
         }
         
         %>

         <tr onclick="func('<%=out_p_id%>','<%=m_sendtime%>','<%=m_title%>','<%=m_text%>','<%=m_sender%>');">
         <td align="center"><%= str_m_checked %></td> 
         <td align="center"><%= out_p_id %></td>
         <td align="center"><%= m_sendtime %></td> 
         <td align="center"><%= m_title %></td> 
         <%
      }
   }
   %>
   </table>
   <script>
      var window=null;
      function func(sender,time,title,text,p_id){
    	  window.open("popup_message.jsp?m_sender="+sender+"&m_sendtime="+time+"&m_title="+title+"&m_text="+text+"&p_id="+p_id,"a","width=500, height=250, left=500, top=50");
      }
      
   </script>
</body>
<%@include file="footer.jsp"%>
</html>