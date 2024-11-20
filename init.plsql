-- TODO: Create user
DECLARE
    V_COUNT NUMBER;
BEGIN
    SELECT
        COUNT(*) INTO V_COUNT
    FROM
        DBA_USERS T
    WHERE
        T.USERNAME='CSERKESZ_ADMIN';
    SELECT
        COUNT(*) INTO V_COUNT
    FROM
        DBA_USERS T
    WHERE
        T.USERNAME='DOG_MANAGER';
    IF V_COUNT = 1 THEN
        EXECUTE IMMEDIATE 'DROP USER CSERKESZ_ADMIN CASCADE';
    END IF;
END;
/

CREATE USER CSERKESZ_ADMIN IDENTIFIED BY 12345678 DEFAULT TABLESPACE USERS QUOTA UNLIMITED ON USERS;

/

GRANT CREATE TRIGGER TO CSERKESZ_ADMIN;

GRANT CREATE SESSION TO CSERKESZ_ADMIN;

GRANT CREATE TABLE TO CSERKESZ_ADMIN;

GRANT CREATE VIEW TO CSERKESZ_ADMIN;

GRANT CREATE SEQUENCE TO CSERKESZ_ADMIN;

GRANT CREATE PROCEDURE TO CSERKESZ_ADMIN;

GRANT CREATE TYPE TO CSERKESZ_ADMIN;

ALTER SESSION SET CURRENT_SCHEMA=CSERKESZ_ADMIN;

-- TODO: Taglista tábla

CREATE TABLE MEMBERS (
    MEMBER_ID NUMBER PRIMARY KEY,
 
    --Személyes adatok
    FIRST_NAME VARCHAR2(40) NOT NULL,
    LAST_NAME VARCHAR2(80) NOT NULL,
    MOTHERS_NAME VARCHAR2(120) NOT NULL,
    MOTHERS_TELEPHONE_NUMBER VARCHAR2(12) NOT NULL,
    MOTHERS_EMAIL VARCHAR2(60) NOT NULL,
    MEMBER_EMAIL VARCHAR2(60),
    MEMBER_TELEPHONE_NUMBER VARCHAR2(12),
    ADDRESS_ID NUMBER NOT NULL,
    BIRTH_DATE DATE,
    ORS_ID NUMBER,
    PATROL_ID NUMBER
) TABLESPACE USERS;

-- TODO: CONSTRAINTS FOR THE TABLE (address, ors, patrol)

-- TODO: History taglista táblához

-- TODO: Levelezési cim tábla

CREATE TABLE ADDRESS (
    ADDRESS_ID NUMBER PRIMARY KEY,
    ZIP_CODE VARCHAR2(10) NOT NULL,
    COUNTRY VARCHAR2(50) NOT NULL,
    CITY VARCHAR2(50) NOT NULL,
    STREET_NAME VARCHAR2(100) NOT NULL,
    STREET_TYPE VARCHAR2(40) NOT NULL,
    HOUSE_NUMBER VARCHAR2(30) NOT NULL,
);

-- TODO: Őrs tábla
CREATE TABLE ORS (
    ORS_ID NUMBER PRIMARY KEY,
    NAME VARCHAR(100) NOT NULL,
    PATROL_ID NUMBER NOT NULL,
);

-- FOREIGN KEY (patrol_id) REFERENCES patrol (patrol_id)
-- TODO: Raj tábla
CREATE TABLE PATROL (
    PATROL_ID NUMBER PRIMARY KEY,
    PATROL_NAME VARCHAR2(100) NOT NULL
);

-- TODO: Státusz, jogosultság tábla
CREATE TABLE RANK_PRIVILEGES (
    STATUS_ID NUMBER PRIMARY KEY,
    MEMBER_ID NUMBER NOT NULL,
    RANK_ID NUMBER NOT NULL
);

CREATE TABLE RANK_DICTIONARY (
    RANK_ID NUMBER PRIMARY KEY,
    RANK_NAME VARCHAR(50) NOT NULL
);

-- TODO: History Státusz,jogosultság táblához
CREATE TABLE RANK_PRIVILEGES_HIS (
    CHANGE_ID NUMBER PRIMARY KEY,
    LOG_MSSG TEXT NOT NULL,
    TR_TIME TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- TODO: Gyűlésjelentések tábla
CREATE TABLE MEETING_REPORTS (
    REPORT_ID NUMBER PRIMARY KEY,
    REPORT_CONTENT CLOB NOT NULL,
    AUTHOR_ID NUMBER NOT NULL,
    GROUP_ID NUMBER NOT NULL,
);

-- FOREIGN KEY (AUTHOR_ID) REFERENCES MEMBERS(MEMBER_ID),
-- FOREIGN KEY (GROUP_ID) REFERENCES GROUPS(GROUP_ID)

-- TODO: Gyűlésjelentések History
CREATE TABLE MEETING_HIS (
    CHANGE_ID NUMBER PRIMARY KEY,
    CHANGER_ID NUMBER NOT NULL LOG_MSSG VARCHAR2(4000) NOT NULL,
    TR_TIME TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- TODO: Megbeszélés tábla

-- TODO: Megbeszélés szerkesztési history

-- TODO: Programlista tábla
-- TODO: Feladatlista tábla
-- TODO: Program/feladat history

-- TODO: Tudásbázis tábla

-- TODO: Blog/news tábla