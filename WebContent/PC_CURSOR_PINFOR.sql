CREATE OR REPLACE PROCEDURE PC_CURSOR_PINFOR
(v_id IN professor. p_id%TYPE, r_name OUT VARCHAR2, r_phone OUT VARCHAR2, r_email OUT VARCHAR2)
IS
  CURSOR cr_information(user_id professor.p_id%TYPE) IS
    SELECT p_name, p_phone, p_email
    FROM professor
    WHERE p_id = user_id;
BEGIN
  r_name:='';
  r_phone:='';
  r_email:='';
  FOR user_record IN cr_information(v_id) LOOP
    r_name:= user_record.p_name;
    r_phone:= user_record.p_phone;
    r_email:= user_record.p_email;
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