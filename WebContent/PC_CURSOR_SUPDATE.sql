CREATE OR REPLACE PROCEDURE PC_CURSOR_SUPDATE
(v_id IN student. s_id%TYPE, r_name OUT VARCHAR2, r_phone OUT VARCHAR2, r_email OUT VARCHAR2, result OUT VARCHAR2)
IS
  user_id student.s_id%TYPE;
  CURSOR cr_checkpwd(user_id student.s_id%TYPE) IS
    SELECT s_name, s_pwd, s_phone, s_email 
    FROM student
    WHERE s_id = user_id;
BEGIN
  result:='';
  r_name:='';
  r_phone:='';
  r_email:='';
  FOR user_record IN cr_checkpwd(v_id) LOOP
    result:= user_record.s_pwd;
    r_name:= user_record.s_name;
    r_phone:= user_record.s_phone;
    r_email:= user_record.s_email;
  END LOOP;
  COMMIT;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    result:='';
    r_name:='';
    r_phone:='';
    r_email:='';
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('ERR MESSAGE:' || SQLERRM);
END;
/