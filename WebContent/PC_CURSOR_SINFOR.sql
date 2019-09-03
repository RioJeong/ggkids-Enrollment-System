CREATE OR REPLACE PROCEDURE PC_CURSOR_SINFOR
(v_id IN student. s_id%TYPE, r_name OUT VARCHAR2, r_phone OUT VARCHAR2, r_email OUT VARCHAR2)
IS
  CURSOR cr_information(user_id student.s_id%TYPE) IS
    SELECT s_name, s_phone, s_email
    FROM student
    WHERE s_id = user_id;
BEGIN
  r_name:='';
  r_phone:='';
  r_email:='';
  FOR user_record IN cr_information(v_id) LOOP
    r_name:= user_record.s_name;
    r_phone:= user_record.s_phone;
    r_email:= user_record.s_email;
  END LOOP;
  COMMIT;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    r_name:='';
    r_phone:='';
    r_email:='';
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('ERR MESSAGE:' || SQLERRM);
END;
/