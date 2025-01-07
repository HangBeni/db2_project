CREATE OR REPLACE PACKAGE GATHERING_PKG IS

    PROCEDURE NEW_GATHERING_FROM_STRING(
        P_REPORT_STRING IN VARCHAR2,
        P_AUTHOR_ID IN GATHERING_REPORTS.AUTHOR_ID%TYPE,
        P_ORS_ID IN GATHERING_REPORTS.ORS_ID%TYPE
    );

    PROCEDURE NEW_GATHER_REPORT_FROM_BFILE(
        P_FILE_NAME VARCHAR2
    );
END GATHERING_PKG;
/

CREATE OR REPLACE PACKAGE BODY GATHERING_PKG IS

    PROCEDURE NEW_GATHERING_FROM_STRING(
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
                REPORT_CONTENT,
                AUTHOR_ID,
                ORS_ID
            ) VALUES (
                P_REPORT_STRING,
                P_AUTHOR_ID,
                P_ORS_ID
            );
            COMMIT;
        ELSE
            ROLLBACK;
            RAISE EXCEPTIONS_PKG.INVALID_PRIVILEGE_EXC;
        END IF;
    EXCEPTION
        WHEN EXCEPTIONS_PKG.INVALID_PRIVILEGE_EXC THEN
            INSERT INTO GATHERING_HIS(
                LOG_ID,
                CHANGER,
                LOG_MSSG
            ) VALUES (
                GATHERING_REPORT_HIS_SEQ.NEXTVAL,
                USER,
                'User ' || USER || P_AUTHOR_ID ||' tried to insert a gathering report without the required privilege.'
            );
            COMMIT;
    END;

    PROCEDURE NEW_GATHER_REPORT_FROM_BFILE(
        P_FILE_NAME VARCHAR2
    ) IS
        V_CLOB   CLOB;
        V_BFILE  BFILE;
        V_LEADER MEMBERS%ROWTYPE;
    BEGIN
        V_LEADER := GET_RANDOM_GROUP_LEADER_FUNC();
        V_BFILE := BFILENAME( 'FILES_FOR_REPORT', LOWER(P_FILE_NAME));
        DBMS_LOB.FILEOPEN(V_BFILE);
        DBMS_LOB.LOADFROMFILE( V_CLOB, V_BFILE, DBMS_LOB.GETLENGTH(V_BFILE));
        DBMS_LOB.FILECLOSE(V_BFILE);
        IF HAVE_MEMBER_RANK_BY_NAME_FUNC(
            P_MEMBER_ID => V_LEADER.MEMBER_ID,
            P_RANK_NAME => 'GROUP_LEADER'
        ) = 1 THEN
            INSERT INTO GATHERING_REPORTS(
                REPORT_CONTENT,
                AUTHOR_ID,
                ORS_ID
            ) VALUES (
                V_CLOB,
                V_LEADER.MEMBER_ID,
                GET_RANDOM_ORS_FUNC()
            );
            COMMIT;
        ELSE
            ROLLBACK;
            RAISE EXCEPTIONS_PKG.INVALID_PRIVILEGE_EXC;
        END IF;
    EXCEPTION
        WHEN EXCEPTIONS_PKG.INVALID_PRIVILEGE_EXC THEN
            INSERT INTO GATHERING_HIS(
                CHANGER,
                LOG_MSSG
            ) VALUES (
                USER,
                'User ' || USER || V_LEADER.MEMBER_ID || ' tried to insert a gathering report without the required privilege.'
            );
            COMMIT;
    END; 
    
    -- TODO: get all report
    -- TODO: get author's report
END GATHERING_PKG;
/