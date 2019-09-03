CREATE OR REPLACE FUNCTION Date2EnrollSemester(ndate IN DATE)
	RETURN NUMBER
	IS
		nMonth NUMBER;
		nSemester NUMBER;
	BEGIN
	 SELECT to_number(to_char(ndate, 'MM')) 
	 INTO nMonth
	 FROM dual;
	 IF(nMonth>6) THEN nSemester:=2;
	 ELSE nSemester:=1;
	 END IF;
	 RETURN nSemester;
	END;
/

