CREATE TABLE GATHERING_REPORTS(
    REPORT_ID NUMBER PRIMARY KEY,
    REPORT_CONTENT CLOB NOT NULL,
    AUTHOR_ID NUMBER NOT NULL,
    ORS_ID NUMBER NOT NULL,
    CREATED_AT TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    MODIFIED_AT TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT GATHERING_AUTHOR_FK FOREIGN KEY (AUTHOR_ID) REFERENCES MEMBERS(MEMBER_ID),
    CONSTRAINT GATHERING_ORS_FK FOREIGN KEY (ORS_ID) REFERENCES ORS(ORS_ID)
);