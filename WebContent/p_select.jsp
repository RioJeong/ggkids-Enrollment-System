<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>

<!DOCTYPE html>
<html>
<head>
<title>강의조회</title>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
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
<body>
	<%@ include file="p_top.jsp"%>
	<%
		session_id = (String) session.getAttribute("id");
	%>
	<%
		if (session_id == null)
			response.sendRedirect("login.jsp");
	%>

	<div class="row"
		style="float: left; width: 50%; margin-left: 50px; margin-top: 20px; margin-bottom: 20px;">
		<div class="form-group1" style="width: 25%; display: block;">
			<select id="form_year" class="custom-select">
				<option selected="year">연도</option>
				<option value="2019">2019</option>
				<option value="2018">2018</option>
				<option value="2017">2017</option>
			</select>
		</div>
		<div class="form-group2"
			style="width: 25%; display: block; margin-left: 10px;">
			<select id="form_seme" class="custom-select">
				<option selected="sem">학기</option>
				<option value="1">1</option>
				<option value="2">2</option>
			</select>
		</div>
		<input type="button" onclick="button_click();" value="검색"
			style="display: block; margin-left: 10px;" class="btn btn-success" />
	</div>

	<script type="text/javascript">
		function button_click() {
			var target_seme = document.getElementById("form_seme");
			var tmp_target_seme = target_seme.options[target_seme.selectedIndex].value;
			var target_year = document.getElementById("form_year");
			var tmp_target_year = target_year.options[target_year.selectedIndex].value;
			if (tmp_target_year != "연도" && tmp_target_seme != "학기") {
				//location.href("insert.jsp?session_sem="+tmp_target_seme+"&session_year="+tmp_target_year);
				location.href = "p_select.jsp?session_sem=" + tmp_target_seme
						+ "&session_year=" + tmp_target_year;
			} else
				alert("입력을 확인하세요");

		}
	</script>

	<table class="table table-hover" align="center" style="width: 95%;">
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
			<th scope="row">수강생 조회</th>
		</tr>
		<%
			String get_sem = request.getParameter("session_sem");
			String get_year = request.getParameter("session_year");

			String p_id = "";
			String p_name = "";
			String mySQL = "";

			Statement stmt = null;
			Statement stmt2 = null;
			ResultSet rs = null;
			ResultSet myResultSet = null;
			CallableStatement cstmt = null;

			String period[] = { "", "9:00 ~ 10:00", "10:00 ~ 11:00", "11:00 ~ 12:00", "12:00 ~ 13:00",
					"13:00 ~ 14:00" };
			
			Class.forName(dbdriver);
			Connection myConn = DriverManager.getConnection(dburl, user, passwd);
			stmt = myConn.createStatement();
			stmt2 = myConn.createStatement();
			try {
				PreparedStatement pstmt = myConn
						.prepareStatement("select * from teach where p_id=? and c_year=? and c_semester=?");
				if (get_sem == null && get_year == null) {
					cstmt = myConn.prepareCall("{? = call Date2EnrollSemester(SYSDATE)}");
					cstmt.registerOutParameter(1, oracle.jdbc.OracleTypes.NUMBER);
				    cstmt.executeUpdate();
					get_sem = Integer.toString(cstmt.getInt(1));
					
					cstmt = myConn.prepareCall("{? = call Date2EnrollYear(SYSDATE)}");
					cstmt.registerOutParameter(1, oracle.jdbc.OracleTypes.NUMBER);
					cstmt.executeUpdate();
					get_year = Integer.toString(cstmt.getInt(1));

					pstmt.setString(1, session_id);
					pstmt.setString(2, get_year);
					pstmt.setString(3, get_sem);
					rs = pstmt.executeQuery();

				} else {
					if ((get_sem != null && get_year != null)
							|| (!get_sem.equals("null")) && !get_year.equals("null")) {
						pstmt.setString(1, session_id);
						pstmt.setString(2, get_year);
						pstmt.setString(3, get_sem);
						rs = pstmt.executeQuery();

					} else if ((get_sem != null && get_year == null)
							|| (!get_sem.equals("null")) && get_year.equals("null")) {
						mySQL = "SELECT * FROM ENROLL WHERE S_ID = '" + session_id + "' and C_SEMESTER = " + get_sem
								+ " ORDER BY C_ID ASC";
						rs = stmt.executeQuery(mySQL);
					} else if ((get_sem == null && get_year != null)
							|| (get_sem.equals("null")) && !get_year.equals("null")) {
						mySQL = "SELECT * FROM ENROLL WHERE S_ID = '" + session_id + "' and C_YEAR = " + get_year
								+ " ORDER BY C_ID ASC";
						rs = stmt.executeQuery(mySQL);
					}

				}

				while (rs.next()) {
					
					String c_id=rs.getString("c_id");
					String c_id_no=rs.getString("c_id_no");
					String c_name=rs.getString("c_name");
					String c_room=rs.getString("c_room");
					String c_unit=rs.getString("c_unit");
					String c_year=rs.getString("c_year");
					String c_semester=rs.getString("c_semester");
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
			<td align="center">
	         <span class="badge badge-pill badge-success" style="height:30px;width:50px;padding:8px; ">
	            <a align="center" style="text-decoration:none;color:white;font-weight:bold;font-size:15px;" 
	           href="p_studentselect.jsp?c_id=<%= c_id %>&c_id_no=<%= c_id_no %>&c_year=<%= c_year %>&c_semester=<%= c_semester %>">조회</a>
	         </span>
	         </td> 
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
			}
		%>
	</table>

</body>
	<div style="margin-top: 410px;"></div>
	<%@include file="footer.jsp"%>
</html>