<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="EUC-KR">
<title>강의 편집</title>
</head>
<style type="text/css">
.container {
	border: 5px double #43ac6a4a;
	width: 800px;
	height: 700px;
	display: float;
	margin: 40px auto;
}

.form-horizontal {
	margin: 40px 0px 0px 210px;
}

.control-label {
	font-size: 1rem !important;
	font-weight: bold;
}
</style>
<body>
	<%@include file="p_top.jsp"%>
	<%
		try {
			Statement stmt;
			Statement stmt2;
			ResultSet rs;
			ResultSet myResultSet;
			String mySQL;
			Connection myConn = DriverManager.getConnection(dburl, user, passwd);
			Class.forName(dbdriver);
			stmt = myConn.createStatement();
			stmt2 = myConn.createStatement();
			String period[] = { "", "9:00 ~ 10:00", "10:00 ~ 11:00", "11:00 ~ 12:00", "12:00 ~ 13:00",
					"13:00 ~ 14:00" };

			String c_id = (String) request.getParameter("c_id"); session.setAttribute("cid",c_id);
			String c_id_no = (String) request.getParameter("c_id_no"); session.setAttribute("cidno",c_id_no);
			String c_year = (String) request.getParameter("c_year"); session.setAttribute("cyear",c_year);
			String c_sem = (String) request.getParameter("c_semester"); session.setAttribute("csem",c_sem);

			mySQL = "select * from teach where c_id='" + c_id + "' and c_id_no='" + c_id_no + "' and c_year='"
					+ c_year + "' and c_semester='" + c_sem + "'";
			rs = stmt.executeQuery(mySQL);

			if (rs != null) {
				if (rs.next()) {
					String c_name = rs.getString("c_name");
					String c_room = rs.getString("c_room");
					String c_unit = rs.getString("c_unit");
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
					int student_cnt = 0;
					mySQL = "select count(*) from enroll where c_id='" + c_id + "'and c_id_no=" + c_id_no
							+ "and c_year=" + c_year + "and c_semester=" + c_sem;
					myResultSet = stmt2.executeQuery(mySQL);
					if (myResultSet != null) {
						while (myResultSet.next()) {
							student_cnt = myResultSet.getInt(1);
						}
					}
	%>

	<div class="container">
		<table class="table table-success"
			style="width: 60%; margin-top: 20px;" align="center">
			<tr>
				<td align="center" style="color: white; font-size: 18px;">강의 정보
					수정</td>
			</tr>
		</table>
		<form class="form-horizontal" name="updateform" method="post"
			action="p_course_update_verify.jsp">
			<fieldset>
				<div class="form-group">
					<label for="c_id" class="col-sm-3 control-label">과목번호</label><%=c_id%>
				</div>
				<div class="form-group">
					<label for="c_id_no" class="col-sm-3 control-label">분반</label><%=c_id_no%>
				</div>
				<div class="form-group">
					<label for="c_name" class="col-sm-3 control-label">과목명</label><%=c_name%>
				</div>
				<div class="form-group">
					<label for="c_time" class="col-sm-3 control-label">강의시간</label><%=out_c_time%>
				</div>
				<div class="form-group">
					<label for="c_room" class="col-sm-3 control-label">강의실</label><%=c_room%>
				</div>
				<div class="form-group">
					<label for="c_unit" class="col-sm-3 control-label">학점</label><%=c_unit%>
				</div>
				<div class="form-group">
					<label for="c_year_sem" class="col-sm-3 control-label">년도/학기</label><%=c_year%>/<%=c_sem%>
				</div>
				<div class="form-group">
					<label for="c_max_cnt" class="col-sm-3 control-label">현재정원/신청/여석</label><%=c_max%>/<%=student_cnt%>/<%=c_max - student_cnt%>
				</div>
				<div class="form-group">
					<label for="s_pwd" class="col-sm-2 control-label">정원 수 수정</label>
					<div class="col-sm-2">
						<input type="text" name="update_cmax" class="form-control">
					</div>
				</div>
				<div class="form-group">
					<div class="col-sm-offset-2 col-sm-10">
						<input class="btn btn-success" type="submit" value="변경 사항 저장">
					</div>
				</div>
			</fieldset>
		</form>
	</div>
	<%
		}
			}
			myConn.commit();
			stmt.close();
			stmt2.close();
			myConn.close();
		} catch (Exception ex) {
			out.println(ex.getMessage());
			ex.printStackTrace();
		}
	%>
</body>
<div style="margin-top: 250px;"></div>
 <%@include file="footer.jsp"%>
</html>