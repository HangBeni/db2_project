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
    CHANGER_ID NUMBER NOT NULL,
    LOG_MSSG TEXT NOT NULL,
    TR_TIME TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
ALTER TABLE MEMBER_HIS
    ADD CONSTRAINT MEMBER_HIS_FK FOREIGN KEY (
        CHANGER_ID
    )
        REFERENCES MEMBERS(
            MEMBER_ID
        );
