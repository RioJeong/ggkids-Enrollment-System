CREATE OR REPLACE PROCEDURE S_ID_CHECK(e_sid IN STUDENT.S_ID%TYPE, result out NUMBER)
IS
   not_found_sid EXCEPTION;
   tmp_result NUMBER;
   cnt NUMBER;
   CURSOR sid_list(get_sid STUDENT.S_ID%TYPE) IS
      SELECT s_id
      FROM STUDENT 
      WHERE s_id = get_sid;
BEGIN
   result := 1;
   cnt := 0;
   FOR result_list IN sid_list(e_sid) LOOP
      tmp_result := result_list.s_id;
      cnt := cnt + 1;
   END LOOP;
   IF (cnt != 1) THEN
      RAISE not_found_sid;
   END IF;
EXCEPTION
   WHEN not_found_sid THEN
      result := 0;
END;
/