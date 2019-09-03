CREATE OR REPLACE FUNCTION INSERTSCHEDULE(s_sid IN STUDENT.S_ID%TYPE, s_cid IN TEACH.C_ID%TYPE)
RETURN NUMBER
IS
per NUMBER;
day ENROLL.c_time%TYPE;
per2 NUMBER;
day2 ENROLL.c_time%TYPE;
id NUMBER;
nYear NUMBER;
nSemester NUMBER;
en ENROLL%ROWTYPE;

m NUMBER;
tu NUMBER;
w NUMBER;
th NUMBER;
f NUMBER;

BEGIN
  nYear := Date2EnrollYear(SYSDATE);
  nSemester := Date2EnrollSemester(SYSDATE);

  per:=-1;
  per2:=-1;
  m:=null;
  tu:=null;
  w:=null;
  th:=null;
  f:=null;
 

  SELECT substr(c_time, 2,1), substr(c_time, 1,1),substr(c_time, 5,1), substr(c_time, 4,1), c_id
  INTO per, day, per2, day2, id
  FROM Enroll e
  WHERE s_sid = e.s_id and s_cid = e.c_id and nYear = e.c_year and nSemester=e.c_semester;
  case day
       when '월' then 
       m:= id;
       when '화' then 
       tu:= id;
       when '수' then 
       w:= id;
       when '목' then 
       th:= id;
       else
       f:= id;
  end case;
  INSERT INTO SCHEDULE (s_id, c_year, c_semester, s_period, s_mon, s_tue, s_wen, s_thu, s_fri)
  VALUES (s_sid, nYear, nSemester, per, m,tu,w,th,f);


  IF(per2!=-1) 
  THEN
  m:=null;
  tu:=null;
  w:=null;
  th:=null;
  f:=null;
  case day2
      when '월' then 
      m:= id;
      when '화' then 
      tu:= id;
      when '수' then 
      w:= id;
      when '목' then 
      th:= id;
      else
      f:= id;
  end case;
  INSERT INTO SCHEDULE (s_id, c_year, c_semester, s_period, s_mon, s_tue, s_wen, s_thu, s_fri)
  VALUES (s_sid, nYear, nSemester, per2, m,tu,w,th,f);
  END IF;

  RETURN 0;
END;
/
