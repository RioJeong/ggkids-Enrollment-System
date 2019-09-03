<%@ page language="java" contentType="text/html; charset=UTF-8"
   pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<!DOCTYPE>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=EUC-KR">
<title>교수 정보 수정</title>
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link href="../plugin/bootstrap/css/bootstrap.min.css" rel="stylesheet">
<link
   href="//netdna.bootstrapcdn.com/font-awesome/4.0.3/css/font-awesome.css"
   rel="stylesheet">
<link rel="stylesheet" href="../plugin/bootstrap/css/style.css"
   media="screen" title="no title" charset="utf-8">
<script
   src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.3/jquery.min.js"></script>
<script src="../plugin/bootstrap/js/bootstrap.min.js"></script>
<script src="../config/js/join.js"></script>
</head>
<style type="text/css">
.container {
   border: 5px double #43ac6a4a;
   width: 800px;
   height: 540px;
   display: float;
   margin: 40px auto;
}
.form-horizontal{
   margin:40px 0px 0px 210px;
}
.control-label{
   font-size:1rem !important;
   font-weight:bold;
}
</style>
<body>
   <%@ include file="p_top.jsp"%>
   <% session_id = (String)session.getAttribute("id"); %>
   <%
      Connection myConn = null;
      Statement stmt = null;
      String mySQL = "";
      String result, r_name, r_phone, r_email;

      try {
         Class.forName(dbdriver);
         myConn = DriverManager.getConnection(dburl, user, passwd);
         stmt = myConn.createStatement();
      } catch (SQLException ex) {
         System.err.println("SQLException: " + ex.getMessage());
      }
      mySQL = "{call PC_CURSOR_PUPDATE(?,?,?,?,?)}"; 
      CallableStatement cstmt = myConn.prepareCall(mySQL);
      cstmt.setString(1, session_id);
      cstmt.registerOutParameter(2, java.sql.Types.VARCHAR);
      cstmt.registerOutParameter(3, java.sql.Types.VARCHAR); 
      cstmt.registerOutParameter(4, java.sql.Types.VARCHAR);
      cstmt.registerOutParameter(5, java.sql.Types.VARCHAR); 
            
      try{
         cstmt.execute(); 
         r_name = cstmt.getString(2);
         r_phone = cstmt.getString(3);
         r_email = cstmt.getString(4);
         result = cstmt.getString(5);
   %>
   <script type="text/javascript">
   var input = prompt("교수정보를 수정하려면 비밀번호를 입력하세요");
   if( input != "<%=result%>") {
            alert("비밀번호가 틀렸습니다");
            history.go(-1);
         }
   </script>
   <div class="container">
      <table class="table table-success" style="width: 60%; margin-top:20px;" align="center">
            <tr><td align="center" style="color: white; font-size: 18px;">교수 정보 수정</td></tr>
      </table>
      <form class="form-horizontal" name="updateform" method="post" action="update_verify.jsp">
         <fieldset>
            <div class="form-group">
               <label for="p_id" class="col-sm-1 control-label">교번</label><%=session_id%>
            </div>
            <div class="form-group">
               <label for="p_name" class="col-sm-1 control-label">이름</label><%=r_name%>
            </div>
            <div class="form-group">
               <label for="p_pwd" class="col-sm-2 control-label">패스워드</label>
               <div class="col-sm-6">
                  <input type="text" name="userPassword" class="form-control"
                     placeholder="비밀번호를 입력하세요">
               </div>
            </div>
            <div class="form-group">
               <label for="p_phone" class="col-sm-2 control-label">전화번호</label>
               <div class="col-sm-6">
                  <input type="text" name="userPhone" class="form-control" value="<%=r_phone%>">
               </div>
            </div>
            <div class="form-group">
               <label for="p_email" class="col-sm-2 control-label">이메일</label>
               <div class="col-sm-6">
                  <input type="text" name="userEmail" class="form-control" value="<%=r_email%>">
               </div>
            </div>
            <div class="form-group">
               <div class="col-sm-offset-2 col-sm-10">
                  <input class="btn btn-success" type="submit" value="변경 사항 저장"
                     onclick="javascript:location.href='update_verify.jsp';">
               </div>
            </div>
         </fieldset>
      </form>
   </div>
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
   <div style="margin-top: 150px;"></div>
   <%@include file="footer.jsp"%>
</html>