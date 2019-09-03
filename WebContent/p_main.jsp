<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="EUC-KR">
<title>데이터베이스를 활용한 교수 시스템입니다.</title>
</head>

<style type="text/css">
.title {
	text-align: center;
	font-weight: 600;
	margin-top: 30px;
	margin-bottom: 40px;
}
</style>
<body>
	<%@include file="p_top.jsp"%>
	<%
		session_id = (String) session.getAttribute("id");
	%>
	<%
		if (session_id == null)
			response.sendRedirect("login.jsp");
	%>
	<%
	String mySQL = "";
	Statement stmt = null;
	Statement stmt2 = null;
	CallableStatement cstmt = null;
	ResultSet rs = null;
	ResultSet myResultSet = null;
	Connection myConn = DriverManager.getConnection(dburl, user, passwd);
	
	Class.forName(dbdriver);
	
	stmt = myConn.createStatement();
	stmt2 = myConn.createStatement();
	String period[] = { "", "9:00 ~ 10:00", "10:00 ~ 11:00", "11:00 ~ 12:00", "12:00 ~ 13:00",
			"13:00 ~ 14:00" };

	String get_sem, get_year;
	cstmt = myConn.prepareCall("{? = call Date2EnrollSemester(SYSDATE)}");
	cstmt.registerOutParameter(1, oracle.jdbc.OracleTypes.NUMBER);
	cstmt.executeUpdate();
	get_sem = Integer.toString(cstmt.getInt(1));

	cstmt = myConn.prepareCall("{? = call Date2EnrollYear(SYSDATE)}");
	cstmt.registerOutParameter(1, oracle.jdbc.OracleTypes.NUMBER);
	cstmt.executeUpdate();
	get_year = Integer.toString(cstmt.getInt(1));
	
	%>
	<h1 class="title" style="margin: 30px;"><%=get_year %>년도
		<%=get_sem %>학기 강의표
	</h1>
	<table class="table table-hover" align="center"
		style="width: 90%; margin_top: 50px;">
		<br>
		<tr class="table-success" style="text-align: center;">

			<th scope="row">과목번호</th>
			<th scope="row">분반</th>
			<th scope="row">과목명</th>
			<th scope="row">강의시간</th>
			<th scope="row">강의실</th>
			<th scope="row">학점</th>
			<th scope="row">연도</th>
			<th scope="row">학기</th>
			<th scope="row">정원</th>
			<th scope="row">신청</th>
			<th scope="row">여석</th>

		</tr>
		<%
			
			try {
				mySQL = "select * from teach where p_id='"+session_id+"'and c_year='"+get_year+"'and c_semester='"+get_sem+"' order by c_id asc";
				rs = stmt.executeQuery(mySQL);
				while (rs.next()) {
					String c_id = rs.getString("c_id");
					String c_id_no = rs.getString("c_id_no");
					String c_name = rs.getString("c_name");
					String c_room = rs.getString("c_room");
					String c_unit = rs.getString("c_unit");
					String c_year = rs.getString("c_year");
					String c_semester = rs.getString("c_semester");
					int c_max = rs.getInt("c_max");
					
					String out_c_time = "";
					String c_time = rs.getString("c_time");
					String tmp_period[] = c_time.split("/");
					for (int z = 0; z < tmp_period.length; z++) {
						out_c_time += tmp_period[z].charAt(0);
						int tmp = Integer.parseInt(tmp_period[z].charAt(1) + "");
						out_c_time += period[tmp];
						if (tmp_period.length > 1 || z == (tmp_period.length - 1))
							out_c_time += (" \n ");
					}

					String out_c_id = "";

					if (c_id.length() == 1) {
						out_c_id = "000" + c_id;
					} else if (c_id.length() == 2) {
						out_c_id = "00" + c_id;
					} else if (c_id.length() == 3) {
						out_c_id = "0" + c_id;
					} else {
						out_c_id = c_id;
					}
					
					int student_cnt=0;
				    mySQL = "select count(*) from enroll where c_id='"+c_id+"'and c_id_no="+c_id_no+"and c_year="+c_year+"and c_semester="+c_semester;
				   	myResultSet = stmt2.executeQuery(mySQL);
				   	if(myResultSet!=null){
				   		while (myResultSet.next()){
				           student_cnt = myResultSet.getInt(1);
				       }
				   	}
		%>
		<tr>
			<td align="center"><%=out_c_id%></td>
			<td align="center"><%=c_id_no%></td>
			<td align="center"><%=c_name%></td>
			<td align="center"><%=out_c_time%></td>
			<td align="center"><%=c_room%></td>
			<td align="center"><%=c_unit%></td>
			<td align="center"><%=c_year%></td>
			<td align="center"><%=c_semester%></td>
			<td align="center"><%=c_max%></td>
			<td align="center"><%=student_cnt%></td>
			<td align="center"><%=c_max-student_cnt%></td>
		</tr>
		<%
			}
			} catch (SQLException ex) {
				out.println(ex.getMessage());
				ex.printStackTrace();
			} finally {
				if (rs != null)
					try {
						rs.close();
					} catch (SQLException ex) {
					}
				if (stmt != null)
					try {
						stmt.close();
					} catch (SQLException ex) {
					}

				if (myConn != null)
					try {
						myConn.close();
					} catch (SQLException ex) {
					}
				if(cstmt!=null)
					try{
						cstmt.close();
					}catch (SQLException ex) {
					}
			
			}
		%>
	</table>
</body>
	<div style="margin-top: 400px;"></div>
 <%@include file="footer.jsp"%>
</html>