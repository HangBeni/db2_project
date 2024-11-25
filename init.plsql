DECLARE
    V_COUNT NUMBER;
BEGIN
    SELECT COUNT(*) INTO V_COUNT
    FROM DBA_USERS T
    WHERE T.USERNAME='CSERKESZ_ADMIN';
    SELECT COUNT(*) INTO V_COUNT
    FROM DBA_USERS T
    WHERE T.USERNAME='DOG_MANAGER';
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


CREATE OR REPLACE TABLE MEMBERS (
    MEMBER_ID NUMBER PRIMARY KEY,
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

ALTER TABLE MEMBERS
    ADD CONSTRAINT MEMBERS_ORS_FK FOREIGN KEY (
        ORS_ID
    )
        REFERENCES ORS(
            ORS_ID
        );

ALTER TABLE MEMBERS
    ADD CONSTRAINT MEMBERS_PATROL_FK FOREIGN KEY (
        PATROL_ID
    )
        REFERENCES PATROL(
            PATROL_ID
        );

ALTER TABLE MEMBERS
    ADD CONSTRAINT MEMBERS_ADDRESS_FK FOREIGN KEY (
        ADDRESS_ID
    )
        REFERENCES ADDRESS(
            ADDRESS_ID
        );

CREATE OR REPLACE TABLE MEMBER_HIS (
    CHANGE_ID NUMBER PRIMARY KEY,
    LOG_MSSG TEXT NOT NULL,
    TR_TIME TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


CREATE OR REPLACE TABLE ADDRESS (
    ADDRESS_ID NUMBER PRIMARY KEY,
    ZIP_CODE VARCHAR2(10) NOT NULL,
    COUNTRY VARCHAR2(50) NOT NULL,
    CITY VARCHAR2(50) NOT NULL,
    STREET_NAME VARCHAR2(100) NOT NULL,
    STREET_TYPE VARCHAR2(40) NOT NULL,
    HOUSE_NUMBER VARCHAR2(30) NOT NULL,
);

CREATE OR REPLACE TABLE ORS (
    ORS_ID NUMBER PRIMARY KEY,
    NAME VARCHAR(100) NOT NULL,
    PATROL_ID NUMBER NOT NULL,
);

ALTER TABLE ORS
    ADD CONSTRAINT ORS_PATROL_FK FOREIGN KEY (
        PATROL_ID
    )
        REFERENCES PATROL(
            PATROL_ID
        );

CREATE OR REPLACE TABLE PATROL (
    PATROL_ID NUMBER PRIMARY KEY,
    PATROL_NAME VARCHAR2(100) NOT NULL
);

CREATE OR REPLACE TABLE RANK_PRIVILEGES (
    STATUS_ID NUMBER PRIMARY KEY,
    MEMBER_ID NUMBER NOT NULL,
    RANK_ID NUMBER NOT NULL
);

ALTER TABLE ORS
    ADD CONSTRAINT RANK_MEMBER_FK FOREIGN KEY (
        MEMBER_ID
    )
        REFERENCES MEMBERS(
            MEMBER_ID
        );

ALTER TABLE ORS
    ADD CONSTRAINT RANK_TYPE_FK FOREIGN KEY (
        RANK_ID
    )
        REFERENCES RANK_DICTIONARY(
            RANK_ID
        );

CREATE OR REPLACE TABLE RANK_DICTIONARY (
    RANK_ID NUMBER PRIMARY KEY,
    RANK_NAME VARCHAR(50) NOT NULL
);

CREATE OR REPLACE TABLE RANK_PRIVILEGES_HIS (
    CHANGE_ID NUMBER PRIMARY KEY,
    LOG_MSSG TEXT NOT NULL,
    TR_TIME TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE OR REPLACE TABLE GATHERING_REPORTS (
    REPORT_ID NUMBER PRIMARY KEY,
    REPORT_CONTENT CLOB NOT NULL,
    AUTHOR_ID NUMBER NOT NULL,
    ORS_ID NUMBER NOT NULL,
);

ALTER TABLE GATHERING_REPORTS
    ADD CONSTRAINT GATHERING_AUTHOR_FK FOREIGN KEY (
        AUTHOR_ID
    )
        REFERENCES MEMBERS(
            MEMBER_ID
        );

ALTER TABLE GATHERING_REPORTS
    ADD CONSTRAINT GATHERING_ORS_FK FOREIGN KEY (
        ORS_ID
    )
        REFERENCES ORS(
            ORS_ID
        );

CREATE OR REPLACE TABLE GATHERING_HIS (
    LOG_ID NUMBER PRIMARY KEY,
    CHANGER_ID NUMBER NOT NULL,
    LOG_MSSG VARCHAR2(4000) NOT NULL,
    TR_TIME TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

ALTER TABLE GATHERING_HIS
    ADD CONSTRAINT GATHERING_HIS_CHANGER_FK FOREIGN KEY (
        CHANGER_ID
    )
        REFERENCES MEMBERS(
            MEMBER_ID
        );

CREATE OR REPLACE TABLE MEETING (
    MEETING_ID NUMBER PRIMARY KEY,
    MEETING_CONTENT CLOB NOT NULL,
    AUTHOR_ID NUMBER NOT NULL,
    EVENT_ID NUMBER NOT NULL,
    CREATE OR REPLACED_AT TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE OR REPLACE TABLE MEETING_HIS (
    LOG_ID NUMBER PRIMARY KEY,
    CHANGED_ID NUMBER NOT NULL,
    AUTHOR_ID NUMBER NOT NULL,
    TR_TIME TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

ALTER TABLE MEETING_HIS
    ADD CONSTRAINT MEETING_AUTHOR_FK FOREIGN KEY (
        AUTHOR_ID
    )
        REFERENCES MEMBERS(
            MEMBER_ID
        );

ALTER TABLE MEETING_HIS
    ADD CONSTRAINT MEETING_CHANGED_FK FOREIGN KEY (
        CHANGED_ID
    )
        REFERENCES MEETING(
            MEETING_ID
        );

CREATE OR REPLACE TABLE EVENTS (
    EVENT_ID NUMBER PRIMARY KEY,
    EVENT_NAME VARCHAR2(100) NOT NULL,
    EVENT_DESCRIPTION VARCHAR2(2000) NOT NULL,
    DATE_START TIMESTAMP NOT NULL,
    DATE_END TIMESTAMP NOT NULL
);

CREATE OR REPLACE TABLE DUTIES (
    DUTY_ID NUMBER PRIMARY KEY,
    DUTY_NAME VARCHAR2(100) NOT NULL,
    DUTY_DESCRIPTION VARCHAR2(500),
    EVENT_ID NUMBER NOT NULL,
);

ALTER TABLE DUTIES
    ADD CONSTRAINT DUTIES_EVENT_FK FOREIGN KEY (
        EVENT_ID
    )
        REFERENCES EVENTS(
            EVENT_ID
        );

CREATE OR REPLACE TABLE EVENT_DUTIES_HIS (
    LOG_ID NUMBER PRIMARY KEY,
    AUTHOR_ID NUMBER NOT NULL,
    LOG_MSSG VARCHAR2(2000) NOT NULL,
    TR_TIME TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

ALTER TABLE EVENT_DUTIES_HIS
    ADD CONSTRAINT EVENT_DUTIES_HIS_AUTHOR_FK FOREIGN KEY (
        AUTHOR_ID
    )
        REFERENCES MEMBERS(
            MEMBER_ID
        );

CREATE OR REPLACE TABLE KNOWLEDGE (
    KNOWLEDGE_ID NUMBER PRIMARY KEY,
    KNOWLEDGE_AUTHOR_ID NUMBER NOT NULL,
    KNOWLEDGE_NAME VARCHAR2(100) NOT NULL,
);

ALTER TABLE KNOWLEDGE
    ADD CONSTRAINT KNOWLEDGE_AUTHOR_FK FOREIGN KEY (
        KNOWLEDGE_ID
    )
        REFERENCES MEMBERS(
            MEMBER_ID
        );

CREATE OR REPLACE TABLE KNOWLEDGE_MEDIA(
    KNOWLEDGE_ID NUMBER NOT NULL,
    MEDIA_ID NUMBER NOT NULL
);

ALTER TABLE KNOWLEDGE_MEDIA
    ADD CONSTRAINT KNOWLEDGE_AUTHOR_PK PRIMARY KEY (
        KNOWLEDGE_ID,
        MEDIA_ID
    );

CREATE OR REPLACE TABLE MEDIA(
    MEDIA_ID NUMBER PRIMARY KEY,
    MEDIA_NAME VARCHAR2(50) NOT NULL,
    MEDIA_VALUE BLOB,
    MEDIA_TYPE VARCHAR2(6) NOT NULL,
    AUTHOR_ID NUMBER NOT NULL,
    CREATED_AT TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

ALTER TABLE MEDIA
    ADD CONSTRAINT MEDIA_AUTHOR_FK FOREIGN KEY (
        AUTHOR_ID
    )
        REFERENCES MEMBERS(
            MEMBER_ID
        );


CREATE OR REPLACE TABLE POSTS (
    POST_ID NUMBER PRIMARY KEY,
    POST_NAME VARCHAR2(100) NOT NULL,
    POST_DESCRIPTION VARCHAR2(2000),
    POST_TYPE VARCHAR2(4) NOT NULL, -- ['NEWS', 'BLOG', 'KNOW']
);