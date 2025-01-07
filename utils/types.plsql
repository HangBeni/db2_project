CREATE TYPE DUTY_REC IS
    OBJECT (
        DUTY_ID NUMBER,
        DUTY_NAME VARCHAR2(100),
        DUTY_DESCRIPTION VARCHAR2(500)
    );
/

CREATE TYPE DUTY_TABLE IS
    TABLE OF DUTY_REC;

