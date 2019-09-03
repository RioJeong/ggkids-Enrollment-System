CREATE OR REPLACE TRIGGER triggerTest
BEFORE UPDATE ON student
FOR EACH ROW

DECLARE

underflow_length EXCEPTION;
invalid_value EXCEPTION;
newPWD STUDENT.s_pwd%TYPE;
nLength NUMBER;
blankLength NUMBER;
nBlank NUMBER;

no_at EXCEPTION;
no_dot EXCEPTION;
blank_e_mail EXCEPTION;
newEMAIL STUDENT.s_email%TYPE;
isAt NUMBER;
isDot NUMBER;
nMailBlank NUMBER;

phone_length_under EXCEPTION;
phoneLength NUMBER;

BEGIN
blankLength := 0;
nLength := LENGTH(:new.s_pwd);

newPWD := :new.s_pwd;
newPWD := REPLACE(newPWD, ' ', '');
blankLength := nLength - LENGTH(newPWD);

isAt := 0;
isDot := 0;
nMailBlank := 0;
newEMAIL := :new.s_email;

newEMAIL := :new.s_email;
newEMAIL := REPLACE(newEMAIL, '@', '');
isAt := LENGTH(:new.s_email) - LENGTH(newEMAIL);

newEMAIL := :new.s_email;
newEMAIL := REPLACE(newEMAIL, '.', '');
isDot := LENGTH(:new.s_email) - LENGTH(newEMAIL);

newEMAIL := :new.s_email;
newEMAIL := REPLACE(newEMAIL, ' ', '');
nMailBlank := LENGTH(:new.s_email) - LENGTH(newEMAIL);

phoneLength := LENGTH(:new.s_phone);

IF ( nLength < 4 ) THEN
    :new.s_pwd := :old.s_pwd; 
    RAISE underflow_length;
END IF;

IF ( blankLength > 0 ) THEN
    :new.s_pwd := :old.s_pwd;
    RAISE invalid_value;
END IF;

IF ( isAt = 0 ) THEN
    :new.s_email := :old.s_email;
    RAISE no_at;
END IF;

IF ( isDot = 0 ) THEN
    :new.s_email := :old.s_email;
    RAISE no_dot;
END IF;

IF ( nMailBlank > 0 ) THEN
    :new.s_email := :old.s_email;
    RAISE blank_e_mail;
END IF;

IF ( phoneLength < 8 ) THEN
    :new.s_phone := :old.s_phone;
    RAISE phone_length_under;
END IF;

EXCEPTION
WHEN underflow_length THEN
    RAISE_APPLICATION_ERROR(-20002, '암호는 4자리 이상이어야 합니다.');
WHEN invalid_value THEN
    RAISE_APPLICATION_ERROR(-20003, '암호에 공란은 없어야합니다.');
WHEN no_at THEN
    RAISE_APPLICATION_ERROR(-20004, '이메일의 형식이 맞지 않습니다(@가 없습니다)');
WHEN no_dot THEN
    RAISE_APPLICATION_ERROR(-20005, '이메일의 형식이 맞지 않습니다.(.가 없습니다)');
WHEN blank_e_mail THEN
    RAISE_APPLICATION_ERROR(-20006, '이메일에 공란은 없어야합니다.');
WHEN phone_length_under THEN
    RAISE_APPLICATION_ERROR(-20007, '전화번호 형식이 맞지 않습니다.');
END;
/