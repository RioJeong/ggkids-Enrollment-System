<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head> <meta charset="UTF-8"> 
<title>수강신청 시스템 로그인</title> 
<link href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-ggOyR0iXCbMQv3Xipma34MD+dH/1fQ784/j6cY/iJTQUOhcWr7x9JvoRxT2MZw1T" crossorigin="anonymous">
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js" integrity="sha384-JjSmVgyd0p3pXB1rRibZUAYoIIy6OrQ6VrjIEaFf/nJGzIxFDsf4x0xIM+B07jRM" crossorigin="anonymous"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.bundle.min.js" integrity="sha384-xrRywqdh3PHs8keKZN+8zzc5TX0GRTLCcmivcbNJWm2rs5C8PRhcEn3czEjhAO9o" crossorigin="anonymous"></script>
<link href="https://stackpath.bootstrapcdn.com/bootswatch/4.3.1/yeti/bootstrap.min.css" rel="stylesheet" integrity="sha384-w6tc0TXjTUnYHwVwGgnYyV12wbRoJQo9iMlC2KdkdmVvntGgzT9jvqNEF/uKaF4m" crossorigin="anonymous">

</head>
<style type="text/css">
.btn {
	background-color:#008cbaad; 
	color:white;
	margin:10px;
	font-weight:bold;
}

</style>
<body style="background-color: #d7ebf1;" >

<center>
	<div class="benter-clock" style="float: none; margin: 100px auto; ">
	<img src="./symbol.png" width="150px" height="150px"/>
	<div class="card border-info mb-3" style="max-width: 25rem; ">
	  <div class="card-header" style="font-weight:bold;">로그인</div>
	  <div class="card-body col-sm-12 my-auto">
	  	<form method="post" action="login_verify.jsp">
		  <fieldset>
		    <div class="form-group">
			  <label class="col-form-label" for="inputDefault">ID</label>
			  <input type="text" name="userID" class="form-control" id="inputID" placeholder="아이디를 입력하세요" >
			</div>
		    <div class="form-group">
		      <label for="exampleInputPassword1">Password</label>
		      <input type="password" name="userPassword" class="form-control" id="exampleInputPassword1" placeholder="비밀번호">
		    </div>
		    <div class="text-center">
			    <INPUT class="btn" TYPE="SUBMIT" NAME="Submit" VALUE="로그인" > 
			    <INPUT class="btn"TYPE="RESET" VALUE="취소">
		    </div>
		  </fieldset>
		</form>
	  </div>
	  </div>
	</div>
</center>
</body>
</html>