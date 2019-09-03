<%@ page language="java" contentType="text/html; charset=UTF-8"
   pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<!DOCTYPE>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=EUC-KR">
<title>학생 정보 조회</title>

<link
   href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css"
   rel="stylesheet"
   integrity="sha384-ggOyR0iXCbMQv3Xipma34MD+dH/1fQ784/j6cY/iJTQUOhcWr7x9JvoRxT2MZw1T"
   crossorigin="anonymous">
<script
   src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js"
   integrity="sha384-JjSmVgyd0p3pXB1rRibZUAYoIIy6OrQ6VrjIEaFf/nJGzIxFDsf4x0xIM+B07jRM"
   crossorigin="anonymous"></script>
<script
   src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.bundle.min.js"
   integrity="sha384-xrRywqdh3PHs8keKZN+8zzc5TX0GRTLCcmivcbNJWm2rs5C8PRhcEn3czEjhAO9o"
   crossorigin="anonymous"></script>
<link
   href="https://stackpath.bootstrapcdn.com/bootswatch/4.3.1/yeti/bootstrap.min.css"
   rel="stylesheet"
   integrity="sha384-w6tc0TXjTUnYHwVwGgnYyV12wbRoJQo9iMlC2KdkdmVvntGgzT9jvqNEF/uKaF4m"
   crossorigin="anonymous">
</head>
<style type="text/css">
.container {
   border: 5px double #436dac4a;
   width: 800px;
   height: 420px;
   display: float;
   margin: 40px auto;
}

.table {
   width: 75% !important;
   display: float;
}

.table-primary{
   margin: 40px auto 10 auto;
}

.table-striped {
   margin: 0 auto;
}

.td-class {
   width: 150px;
}
</style>
<body>
   <%@ include file="top.jsp"%>
    <% session_id = (String) session.getAttribute("id");%>
   <%
      Connection myConn = null;
      Statement stmt = null;
      String mySQL = "";
      String r_name, r_phone, r_email;

      try {
         Class.forName(dbdriver);
         myConn = DriverManager.getConnection(dburl, user, passwd);
         stmt = myConn.createStatement();
      } catch (SQLException ex) {
         System.err.println("SQLException: " + ex.getMessage());
      }
      mySQL = "{call PC_CURSOR_SINFOR (?,?,?,?)}"; 
      CallableStatement cstmt = myConn.prepareCall(mySQL);
      cstmt.setString(1, session_id);
      cstmt.registerOutParameter(2, java.sql.Types.VARCHAR);
      cstmt.registerOutParameter(3, java.sql.Types.VARCHAR); 
      cstmt.registerOutParameter(4, java.sql.Types.VARCHAR);
            
      try{
         cstmt.execute(); 
         r_name = cstmt.getString(2);
         r_phone = cstmt.getString(3);
         r_email = cstmt.getString(4);
   %>
   <div class="container">
      <table class="table table-primary">
         <tr><td align="center" style="color: white; font-size: 18px;">학생 정보</td></tr>
      </table>
      <table class="table table-striped" frame=void border>
         <form name="infor_form" method="post" action="update.jsp">
            <tr>
               <td class="td-class"><div align="center">학번</div></td>
               <td align="center"><%=session_id%></td>
            </tr>
         <tr>
            <td><div align="center">이름</div></td>
            <td align="center"><%=r_name%></td>
         </tr>
         <tr>
            <td><div align="center">패스워드</div></td>
            <td><div align="center" name="userPassword">****</div></td>
         </tr>
         <tr>
            <td><div align="center">전화번호</div></td>
            <td><div align="center" name="userPhone"><%=r_phone%></div></td>
         </tr>
         <tr>
            <td><div align="center">이메일</div></td>
            <td><div align="center" name="uesrEmail"><%=r_email%></div></td>
         </tr>
         <tr>
            <td colspan=2>
               <div align="center">
                  <input class="btn btn-primary" type="button" name="btn1"
                     value=" 수정  " onclick="javascript:location.href='update.jsp'" ;/>
                  <input class="btn btn-primary" type="button" name="btn2"
                     value=" 확인  " onclick="javascript:location.href='main.jsp'" ; />
               </div>
            </td>
         </tr>
         </form>
      </table>
   </div>
   <script type="text/javascript">
    function gomain(){
       location.href="main.jsp";
    }
    function update(){
       location.href="update.jsp";
    }
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
   <div style="margin-top: 255px;"></div>
   <%@include file="footer.jsp"%>
</html>