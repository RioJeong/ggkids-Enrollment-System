<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>

<html>
<body>
<% 
   String sender_id = (String)session.getAttribute("sender_id");
   int len = sender_id.length();
   session.setAttribute(sender_id,"sender_id");
   request.setCharacterEncoding("UTF-8");
   String message_title = request.getParameter("title");
   String message_text= request.getParameter("text");
   String message_receiver = (String)request.getParameter("receiver");
   
    java.text.SimpleDateFormat formatter = new java.text.SimpleDateFormat("yyyy년MM월dd일.HH시mm분ss초");
    String today = formatter.format(new java.util.Date());
   
   String message_time = today;

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
   

   if(len!=4){ //학생일 때
      if(message_receiver!=null){
      if(message_receiver.length()==4){
         Statement stmt = myConn.createStatement();
         String mySQL = "INSERT INTO MESSAGE VALUES("+sender_id+","+message_receiver+",";
         mySQL = mySQL + "0,'"+message_time+"','"+message_title+"','"+message_text+"')";
         System.err.println("&&&&&"+mySQL);
         stmt.executeQuery(mySQL);%>
         <script>
         alert("메시지를 전송하였습니다.");
         location.href ="message.jsp";
      </script>   <%
      }}
      else {
         %>
         <script>
            alert("메시지 전송에 실패하였습니다.");
            location.href ="message.jsp";
         </script>
         <%
         
      }
   }
   else {
	   int result=0;
	   if(message_receiver.length()!=0){
      CallableStatement cstmt = null;
      cstmt = myConn.prepareCall("{call S_ID_CHECK(?,?)}");
      int tmp_number = Integer.parseInt(message_receiver);
      cstmt.setInt(1,tmp_number);
      cstmt.registerOutParameter(2, oracle.jdbc.OracleTypes.NUMBER);
      cstmt.executeUpdate();
      result=cstmt.getInt(2);
      System.err.println("SQLException: "+result);
	   }
	   else result=0;
      if(result==0) {
         %>
         <script>
            alert("해당 학번의 학생이 존재하지 않습니다.");
            location.href ="p_message.jsp";
         </script>
         <%
      }
      else {
         Statement stmt = myConn.createStatement();
         String mySQL = "INSERT INTO MESSAGE VALUES("+sender_id+","+message_receiver+",";
         mySQL = mySQL + "0,'"+message_time+"','"+message_title+"','"+message_text+"')";
         System.err.println("&&&&&"+mySQL);
         stmt.executeQuery(mySQL);%>
         <script>
         alert("메시지를 전송하였습니다.");
         location.href ="p_message.jsp";
      </script>   <%
      }
   }

}catch(SQLException ex){
   if(len!=4){
   %>
<script>
   alert("메시지 전송에 실패하였습니다. \n 제목이나 내용의 길이를 확인하세요.");
   location.href ="message.jsp";
</script>
<% }else{%>
<script>
   alert("메시지를 전송에 실패하였습니다.");
   location.href ="p_message.jsp";
</script>
<% }
   System.err.println("SQLException: "+ex.getMessage());
}

%>
</body>
</html>