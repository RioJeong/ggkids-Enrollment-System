CREATE OR REPLACE TRIGGER triggerTest2
BEFORE UPDATE ON professor
FOR EACH ROW

DECLARE

underflow_length EXCEPTION;
invalid_value EXCEPTION;
newPWD PROFESSOR.p_pwd%TYPE;
nLength NUMBER;
blankLength NUMBER;
nBlank NUMBER;

no_at EXCEPTION;
no_dot EXCEPTION;
blank_e_mail EXCEPTION;
newEMAIL PROFESSOR.p_email%TYPE;
isAt NUMBER;
isDot NUMBER;
nMailBlank NUMBER;

phone_length_under EXCEPTION;
phoneLength NUMBER;

BEGIN
blankLength := 0;
nLength := LENGTH(:new.p_pwd);

newPWD := :new.p_pwd;
newPWD := REPLACE(newPWD, ' ', '');
blankLength := nLength - LENGTH(newPWD);

isAt := 0;
isDot := 0;
nMailBlank := 0;
newEMAIL := :new.p_email;

newEMAIL := :new.p_email;
newEMAIL := REPLACE(newEMAIL, '@', '');
isAt := LENGTH(:new.p_email) - LENGTH(newEMAIL);

newEMAIL := :new.p_email;
newEMAIL := REPLACE(newEMAIL, '.', '');
isDot := LENGTH(:new.p_email) - LENGTH(newEMAIL);

newEMAIL := :new.p_email;
newEMAIL := REPLACE(newEMAIL, ' ', '');
nMailBlank := LENGTH(:new.p_email) - LENGTH(newEMAIL);

phoneLength := LENGTH(:new.p_phone);

IF ( nLength < 4 ) THEN
    :new.p_pwd := :old.p_pwd; 
    RAISE underflow_length;
END IF;

IF ( blankLength > 0 ) THEN
    :new.p_pwd := :old.p_pwd;
    RAISE invalid_value;
END IF;

IF ( isAt = 0 ) THEN
    :new.p_email := :old.p_email;
    RAISE no_at;
END IF;

IF ( isDot = 0 ) THEN
    :new.p_email := :old.p_email;
    RAISE no_dot;
END IF;

IF ( nMailBlank > 0 ) THEN
    :new.p_email := :old.p_email;
    RAISE blank_e_mail;
END IF;

IF ( phoneLength < 8 ) THEN
    :new.p_phone := :old.p_phone;
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