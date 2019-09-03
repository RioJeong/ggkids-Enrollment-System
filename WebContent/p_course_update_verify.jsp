<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<%@page import="java.sql.*"%>

<%    
   request.setCharacterEncoding("UTF-8");
   String update_cmax = (String)request.getParameter("update_cmax");
   System.out.println(update_cmax);
   String c_id = (String)session.getAttribute("cid");
   String c_id_no = (String)session.getAttribute("cidno");
   String c_year = (String)session.getAttribute("cyear");
   String c_sem = (String)session.getAttribute("csem");
%>

<%
try{
   if(Integer.parseInt(update_cmax)<0){%>
      <script>
         alert('정원이 음수입니다. 다시입력하세요.')
         location.href ="p_course_update.jsp";
      </script><% 
   }
   else{
      String dbdriver = "oracle.jdbc.driver.OracleDriver";
      String dburl = "jdbc:oracle:thin:@localhost:1521:orcl";
      String user = "ggkids";
      String passwd = "ggkids";
      String mySQL = null;
      ResultSet rs=null;
      Class.forName(dbdriver);
      Connection myConn = DriverManager.getConnection(dburl, user, passwd);
   
      Statement stmt = myConn.createStatement();
      
      if(update_cmax!=null && update_cmax!="" ){
         mySQL = "update teach set c_max="+update_cmax+ "where c_id='" + c_id + "' and c_id_no='" + c_id_no + "' and c_year='"
               + c_year + "' and c_semester='" + c_sem + "'";
         
         stmt.execute(mySQL);
         
         
      }
      response.sendRedirect("p_course_update.jsp");
      myConn.commit();
      stmt.close();
      myConn.close();
   }
}catch(SQLException ex){%>
   <script>
      alert(ex.getMessage());
      location.href ="p_course_update_exe.jsp";
   </script>
   <%
   System.err.println("SQLException: "+ex.getMessage());
}finally{
   
}

%>
</body>
</html>