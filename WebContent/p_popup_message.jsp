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
<title>메시지 조회</title>
<style type="text/css">
td {
   font-size:17px;
}
.content {
   padding-left:40px !important;
   text-align:left;
}
.semi_title {
   font-weight:bold;
   width:100px;
   border-right: 2px solid #dee2e6;
}
</style>
</head>
<body>
<%

	String m_sender = (String)request.getParameter("m_sender");
	String m_sendtime = (String)request.getParameter("m_sendtime");
	String m_title = (String)request.getParameter("m_title");
	String m_text = (String)request.getParameter("m_text");
	String m_p_id = (String)request.getParameter("p_id");
   
       
%>
<table class="table table" align="center" style="width:95%;" >
<br>
<tr class="table-success" style="text-align:center;">
   <th scope="row">구분</th>
   <th scope="row">내용</th>
</tr>
<tr>
   <td align="center" class = "semi_title">보낸 사람</td> 
   <td align="center" class = "content"><%= m_sender %></td> 
</tr>
<tr>
   <td align="center" class = "semi_title">시간</td> 
   <td align="center" class = "content"><%= m_sendtime %></td>
</tr>
<tr>
   <td align="center" class = "semi_title">제목</td> 
   <td align="center" class = "content"><%= m_title %></td>
</tr>
<tr>
   <td align="center" class = "semi_title">메시지<br/>내용</td> 
   <td align="center" class = "content"><%= m_text %></td>
</tr>
</table>
<center><span class="badge badge-pill badge-success" style="height:30px;width:50px;padding:8px; ">
            <a align="center" style="text-decoration:none;color:white;font-weight:bold;font-size:15px;" href="message_read_verify.jsp?m_sender=<%= m_sender %>&m_text=<%= m_text %>&m_title=<%= m_title %>&m_time=<%= m_sendtime %>&m_p_id=<%=m_p_id%>">읽음</a>
         </span></center>
</body>
</html>