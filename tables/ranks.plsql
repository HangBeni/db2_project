CREATE TABLE RANK_PRIVILEGES (
    STATUS_ID NUMBER PRIMARY KEY,
    MEMBER_ID NUMBER NOT NULL,
    RANK_ID NUMBER NOT NULL,
    PROMOTION_TIME TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT MEMBER_RANK_FK FOREIGN KEY (MEMBER_ID) REFERENCES MEMBERS(MEMBER_ID),
    CONSTRAINT RANK_DICTIONARY_FK FOREIGN KEY (RANK_ID) REFERENCES RANK_DICTIONARY(RANK_ID),
    CONSTRAINT MEMBER_RANK_U UNIQUE (MEMBER_ID, RANK_ID)
    
);

CREATE OR REPLACE TABLE RANK_DICTIONARY (
    RANK_ID NUMBER PRIMARY KEY,
    RANK_NAME VARCHAR(50) NOT NULL
);

CREATE OR REPLACE TABLE RANK_PRIVILEGES_HIS (
    CHANGE_ID NUMBER PRIMARY KEY,
    CHANGER VARCHAR2(40) NOT NULL,
    LOG_MSSG VARCHAR2(4000) NOT NULL,
    TR_TIME TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
-- RANK_PRIVILEGES pkg
