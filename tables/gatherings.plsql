CREATE TABLE GATHERING_REPORTS(
    REPORT_ID NUMBER PRIMARY KEY,
    REPORT_CONTENT CLOB NOT NULL,
    AUTHOR_ID NUMBER NOT NULL,
    ORS_ID NUMBER NOT NULL
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

CREATE OR REPLACE PROCEDURE NEW_GATHERING_FROM_STRING(
    P_REPORT_STRING IN VARCHAR2,
    P_AUTHOR_ID IN GATHERING_REPORTS.AUTHOR_ID%TYPE,
    P_ORS_ID IN GATHERING_REPORTS.ORS_ID%TYPE
) IS
BEGIN
    IF HAVE_MEMBER_RANK_BY_NAME_FUNC(
        P_MEMBER_ID => P_AUTHOR_ID,
        P_RANK_NAME => 'GROUP_LEADER'
    ) = 1 THEN
        INSERT INTO GATHERING_REPORTS(
            REPORT_ID,
            REPORT_CONTENT,
            AUTHOR_ID,
            ORS_ID
        ) VALUES (
            REPORTS_SEQ.NEXTVAL,
            P_REPORT_STRING,
            P_AUTHOR_ID,
            P_ORS_ID
        );
        COMMIT;
        ELSE
            RAISE_APPLICATION_ERROR(-20002, 'You are not a group leader');
        END IF;
    END;

    CREATE OR REPLACE PROCEDURE NEW_GATHERING_REPORT_FROM_BFILE( ) IS
    BEGIN
    END;