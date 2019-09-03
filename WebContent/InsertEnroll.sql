CREATE OR REPLACE PROCEDURE INSERTENROLL (e_sid IN STUDENT.S_ID%TYPE, e_cid IN TEACH.C_ID%TYPE, 
e_cidno IN TEACH.c_id_no%TYPE, result out VARCHAR2)
IS
too_many_units EXCEPTION;   /*최대학점 예외*/
same_course EXCEPTION; /*동일 과목 신청 예외*/
too_many_stduents EXCEPTION;  /*최대인원 예외*/
duplicate_time EXCEPTION; /*중복시간 예외*/
sumOfEnrollUnit NUMBER;
courseUnit NUMBER;
maxUnit NUMBER;
nCourse NUMBER;
nCnt NUMBER;
nCnt1 NUMBER;
nCnt2 NUMBER;
nCnt3 NUMBER;
nCnt4 NUMBER;
teachMax NUMBER;
enrollCnt NUMBER;
nYear NUMBER;
nSemester NUMBER;
tea TEACH%ROWTYPE;
tmp NUMBER;
BEGIN
maxUnit:=18;

/*년도, 학기 알아내기*/
nYear := Date2EnrollYear(SYSDATE);
nSemester := Date2EnrollSemester(SYSDATE);


/*최대학점 초과*/
SELECT SUM(c_unit)
INTO sumOfEnrollUnit
FROM ENROLL e
WHERE e_sid = e.s_id and nYear=e.c_year and nSemester = e.c_semester;

SELECT c_unit
INTO courseUnit
FROM TEACH t
WHERE e_cid = t.c_id and e_cidno = t.c_id_no and nYear=t.c_year and nSemester = t.c_semester;

IF (sumOfEnrollUnit+courseUnit>maxUnit)
THEN
 RAISE too_many_units;
END IF;


/*동일과목 신청 여부*/
SELECT COUNT(*)
INTO nCourse
FROM ENROLL e
WHERE e.s_id = e_sid and e.c_id = e_cid and nYear=e.c_year and nSemester = e.c_semester;
IF (nCourse>0)
THEN
 RAISE same_course;
END IF;

/*최대인원 초과*/
SELECT c_max
INTO teachMax
FROM TEACH t
WHERE e_cid = t.c_id and e_cidno = t.c_id_no and t.c_year = nYear and t.c_semester = nSemester;

SELECT COUNT(*)
INTO enrollCnt
FROM ENROLL e
WHERE e_cid = e.c_id and e_cidno = e.c_id_no and e.c_year = nYear and e.c_semester = nSemester;


IF(teachMax=enrollCnt)
THEN
   RAISE too_many_stduents;
END IF;


/*중복시간 체크*/
SELECT COUNT(*)
INTO nCnt1
FROM
(
   SELECT substr(c_time,1,2)
   FROM TEACH t
   WHERE t.c_id = e_cid and t.c_id_no = e_cidno and t.c_year = nYear and t.c_semester = nSemester
   INTERSECT
   SELECT substr(c_time,1,2)
   FROM ENROLL e
   WHERE e.s_id = e_sid and e.c_year = nYear and e.c_semester = nSemester
);


IF(nCnt1>0)
THEN
 RAISE duplicate_time;
END IF;

SELECT COUNT(*)
INTO nCnt2
FROM
(
   SELECT substr(c_time,4,5)
   FROM TEACH t
   WHERE t.c_id = e_cid and t.c_id_no = e_cidno and t.c_year = nYear and t.c_semester = nSemester
   INTERSECT
   SELECT substr(c_time,4,5)
   FROM ENROLL e
   WHERE e.s_id = e_sid and e.c_year = nYear and e.c_semester = nSemester
);

IF(nCnt2>0)
THEN
 RAISE duplicate_time;
END IF;

SELECT COUNT(*)
INTO nCnt3
FROM
(
   SELECT substr(c_time,1,2)
   FROM TEACH t
   WHERE t.c_id = e_cid and t.c_id_no = e_cidno and t.c_year = nYear and t.c_semester = nSemester
   INTERSECT
   SELECT substr(c_time,4,5)
   FROM ENROLL e
   WHERE e.s_id = e_sid and e.c_year = nYear and e.c_semester = nSemester
);

IF(nCnt3>0)
THEN
 RAISE duplicate_time;
END IF;

SELECT COUNT(*)
INTO nCnt4
FROM
(
   SELECT substr(c_time,4,5)
   FROM TEACH t
   WHERE t.c_id = e_cid and t.c_id_no = e_cidno and t.c_year = nYear and t.c_semester = nSemester
   INTERSECT
   SELECT substr(c_time,1,2)
   FROM ENROLL e
   WHERE e.s_id = e_sid and e.c_year = nYear and e.c_semester = nSemester
);

IF(nCnt4>0)
THEN
 RAISE duplicate_time;
END IF;

/*insert*/
SELECT c_name, c_unit, c_time, c_room
INTO tea.c_name, tea.c_unit, tea.c_time, tea.c_room
FROM TEACH t
WHERE t.c_id=e_cid and t.c_id_no=e_cidno and t.c_year=nYear and t.c_semester=nSemester;

INSERT INTO ENROLL (c_id, s_id, c_name, c_id_no, c_unit, c_year, c_semester, c_time, c_room)
VALUES (e_cid, e_sid, tea.c_name, e_cidno, tea.c_unit, nYear, nSemester, tea.c_time, tea.c_room);

COMMIT;
result := '수강신청을 완료하였습니다.';
tmp:=InsertSchedule(e_sid, e_cid);
EXCEPTION
 WHEN too_many_units THEN
    result:='최대 학점을 초과하였습니다.';
 WHEN same_course THEN
    result:='이미 신청된 과목입니다.';
 WHEN too_many_stduents THEN
    result:='최대인원을 초과하였습니다.';
 WHEN duplicate_time THEN
    result:='중복시간입니다.';
 WHEN OTHERS THEN
    result:=SQLERRM;
    DBMS_OUTPUT.PUT_LINE(SQLERRM||' '||SQLCODE);

END;
/