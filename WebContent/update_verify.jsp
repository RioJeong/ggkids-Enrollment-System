<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<%@page import="java.sql.*"%>

<%    
   request.setCharacterEncoding("UTF-8");
   String userID = (String)session.getAttribute("id");
   String userPhoneNumber = request.getParameter("userPhone");
   String userPassword = request.getParameter("userPassword");
   String userEmail = request.getParameter("userEmail");
   
%>
<% if(userID == null) response.sendRedirect("login.jsp"); %>

<%
int len=userID.length();
try{
   String dbdriver = "oracle.jdbc.driver.OracleDriver";
   String dburl = "jdbc:oracle:thin:@localhost:1521:orcl";
   String user = "ggkids";
   String passwd = "ggkids";
   
   
   Class.forName(dbdriver);
   Connection myConn = DriverManager.getConnection(dburl, user, passwd);

   Statement stmt = myConn.createStatement();
   
   if(userPassword!=""&& userPhoneNumber!= ""&& userEmail!=""){
      
      if(len!=4){
         String mySQL = "update student set s_pwd='" + userPassword + "', s_phone='"+userPhoneNumber+"', s_email='"+userEmail+"' where s_id='" + userID + "'";
         stmt.executeUpdate(mySQL);
         response.sendRedirect("s_information.jsp");
      }else{
         String mySQL = "update professor set p_pwd='" + userPassword + "', p_phone='"+userPhoneNumber+"', p_email='"+userEmail+"' where p_id='" + userID + "'";
         stmt.executeUpdate(mySQL);
         response.sendRedirect("p_information.jsp");
      }
   }else{
      if(len!=4){%>
         <script>
         alert("정보수정에 실패했습니다.");
         location.href ="s_information.jsp";
         </script>
      <% }else{%>
         <script>
         alert("정보수정에 실패했습니다.");
         location.href ="p_information.jsp";
         </script>
   <%    } 
    }
   myConn.commit();
   stmt.close();
   myConn.close();
}catch(SQLException ex){
   //System.err.println("SQLException: "+ex.getMessage());
   String errorMessage = ex.getMessage();
   errorMessage = errorMessage.split(":")[0];
   errorMessage = errorMessage.substring(4);
   String error;
   if(errorMessage.equals("20007")){
      if(len!=4){%>
      <script>
         alert("전화번호 형식이 맞지 않습니다");
         location.href ="update.jsp";
      </script>
      <%}else{ %>
      <script>
         alert("전화번호 형식이 맞지 않습니다");
         location.href ="p_update.jsp";
      </script>
      <%
      }
   }else if(errorMessage.equals("20006")){
      if(len!=4){%>
      <script>
         alert("이메일에 공란은 없어야 합니다");
         location.href ="update.jsp";
      </script>
      <%}else{ %>
      <script>
         alert("이메일에 공란은 없어야 합니다");
         location.href ="p_update.jsp";
      </script>
      <%
      }
   }else if(errorMessage.equals("20005")){
      if(len!=4){%>
      <script>
         alert("이메일의 형식이 맞지 않습니다(.가 없습니다)");
         location.href ="update.jsp";
      </script>
      <%}else{ %>
      <script>
         alert("이메일의 형식이 맞지 않습니다(.가 없습니다)");
         location.href ="p_update.jsp";
      </script>
      <%
      }
   }else if(errorMessage.equals("20004")){
      if(len!=4){%>
      <script>
         alert("이메일의 형식이 맞지 않습니다(@가 없습니다)");
         location.href ="update.jsp";
      </script>
      <%}else{ %>
      <script>
         alert("이메일의 형식이 맞지 않습니다(@가 없습니다)");
         location.href ="p_update.jsp";
      </script>
      <%
      }
   }else if(errorMessage.equals("20003")){
      if(len!=4){%>
      <script>
         alert("암호에 공란은 없어야 합니다");
         location.href ="update.jsp";
      </script>
      <%}else{ %>
      <script>
         alert("암호에 공란은 없어야 합니다");
         location.href ="p_update.jsp";
      </script>
      <%
      }
   }else if(errorMessage.equals("20002")){
      if(len!=4){%>
      <script>
         alert("암호는 4자리 이상이어야 합니다");
         location.href ="update.jsp";
      </script>
      <%}else{ %>
      <script>
         alert("암호는 4자리 이상이어야 합니다");
         location.href ="p_update.jsp";
      </script>
      <%
      }
   }
   
    
   //System.out.println(errorMessage);
}
%>
</body>
</html>