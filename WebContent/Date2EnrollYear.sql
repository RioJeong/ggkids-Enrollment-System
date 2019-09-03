CREATE OR REPLACE FUNCTION Date2EnrollYear(ndate IN DATE)
	RETURN NUMBER
	IS
		nYear NUMBER;
	BEGIN
	 SELECT to_number(to_char(ndate, 'YYYY')) 
	 INTO nYear
	 FROM dual;
	 RETURN nYear;
	END;
/
