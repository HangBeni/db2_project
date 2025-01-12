CREATE OR REPLACE PACKAGE MEMBER_PKG AS

    FUNCTION GET_RANDOM_GROUP_LEADER_FUNC RETURN MEMBERS.MEMBER_ID%TYPE;

    FUNCTION GET_RANDOM_PATROL_LEADER_FUNC RETURN MEMBERS.MEMBER_ID%TYPE;

    PROCEDURE CREATE_MEMBER (
        P_MEMBER IN MEMBER_TY
    );

    PROCEDURE CREATE_MEMBER_FOR_USER (
        P_MEMBER IN MEMBER_TY,
        OUT_MEMBER_ID OUT MEMBERS.MEMBER_ID%TYPE
    );
END MEMBER_PKG;
/

CREATE OR REPLACE PACKAGE BODY MEMBER_PKG AS

    FUNCTION GET_RANDOM_GROUP_LEADER_FUNC RETURN MEMBERS.MEMBER_ID%TYPE IS
        V_RESULT MEMBERS.MEMBER_ID%TYPE;
    BEGIN
        SELECT T2.MEMBER_ID INTO V_RESULT
        FROM (
                SELECT T1.*
                FROM (
                        SELECT *
                        FROM MEMBERS
                        WHERE RANK_DIC_PKG.HAVE_MEMBER_RANK_BY_NAME_FUNC (
                                P_MEMBER_ID => MEMBERS.MEMBER_ID /*IN NUMBER*/,
                                P_RANK_NAME => 'GROUP_LEADER' /*IN VARCHAR2*/
                            ) = 1 AND
                            ROWNUM = 1
                    ) T1
                ORDER BY DBMS_RANDOM.VALUE
            ) T2;
        IF V_RESULT IS NOT NULL THEN
            RETURN V_RESULT;
        ELSE
            RETURN NULL;
        END IF;
    END GET_RANDOM_GROUP_LEADER_FUNC;

    FUNCTION GET_RANDOM_PATROL_LEADER_FUNC RETURN MEMBERS.MEMBER_ID%TYPE IS
        V_RESULT MEMBERS.MEMBER_ID%TYPE;
    BEGIN
        SELECT T2.MEMBER_ID INTO V_RESULT
        FROM (
                SELECT T1.*
                FROM (
                        SELECT *
                        FROM MEMBERS
                        WHERE RANK_DIC_PKG.HAVE_MEMBER_RANK_BY_NAME_FUNC (
                                P_MEMBER_ID => MEMBERS.MEMBER_ID /*IN NUMBER*/,
                                P_RANK_NAME => 'PATROL_LEADER' /*IN VARCHAR2*/
                            ) = 1 AND
                            ROWNUM = 1
                    ) T1
                ORDER BY DBMS_RANDOM.VALUE
            ) T2;
        IF V_RESULT IS NOT NULL THEN
            RETURN V_RESULT;
        ELSE
            RETURN NULL;
        END IF;
    END GET_RANDOM_PATROL_LEADER_FUNC;

    PROCEDURE CREATE_MEMBER (
        P_MEMBER IN MEMBER_TY
    ) IS
        PRAGMA AUTONOMOUS_TRANSACTION;
    BEGIN
        IF P_MEMBER.FIRST_NAME IS NULL OR P_MEMBER.LAST_NAME IS NULL OR P_MEMBER.MOTHERS_NAME IS NULL OR P_MEMBER.MOTHERS_TELEPHONE_NUMBER IS NULL OR P_MEMBER.MOTHERS_EMAIL IS NULL THEN
            RAISE EXCEPTIONS_PKG.MISSING_PARAM_EXC;
        ELSE
            INSERT INTO MEMBERS (
                FIRST_NAME,
                LAST_NAME,
                MOTHERS_NAME,
                MOTHERS_TELEPHONE_NUMBER,
                MOTHERS_EMAIL,
                MEMBER_EMAIL,
                MEMBER_TELEPHONE_NUMBER,
                BIRTH_DATE,
                ORS_ID,
                PATROL_ID
            ) VALUES (
                P_MEMBER.FIRST_NAME,
                P_MEMBER.LAST_NAME,
                P_MEMBER.MOTHERS_NAME,
                P_MEMBER.MOTHERS_TELEPHONE_NUMBER,
                P_MEMBER.MOTHERS_EMAIL,
                P_MEMBER.MEMBER_EMAIL,
                P_MEMBER.MEMBER_TELEPHONE_NUMBER,
                P_MEMBER.BIRTH_DATE,
                CASE WHEN P_MEMBER.ORS_ID IS NOT NULL THEN NULL WHEN P_MEMBER.ORS_ID IN ( SELECT ORS_ID FROM ORS ) THEN P_MEMBER.ORS_ID END,
                P_MEMBER.PATROL_ID
            );
            COMMIT;
        END IF;
    EXCEPTION
        WHEN DUP_VAL_ON_INDEX THEN
            RAISE_APPLICATION_ERROR ( -20009, 'There is already a Member like that' );
        WHEN EXCEPTIONS_PKG.MISSING_PARAM_EXC THEN
            DBMS_OUTPUT.PUT_LINE ( 'Missing required information about member' );
        WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR ( -20011, 'Error at member pkg'||'CODE- '|| SQLCODE || 'MESSAGE- ' || SQLERRM );
    END CREATE_MEMBER;

    PROCEDURE CREATE_MEMBER_FOR_USER (
        P_MEMBER IN MEMBER_TY,
        OUT_MEMBER_ID OUT MEMBERS.MEMBER_ID%TYPE
    ) AS
        PRAGMA AUTONOMOUS_TRANSACTION;
    BEGIN
        OUT_MEMBER_ID := MEMBERS_SEQ.NEXTVAL;
        IF ( P_MEMBER.FIRST_NAME IS NULL OR
        P_MEMBER.LAST_NAME IS NULL OR
        P_MEMBER.MOTHERS_NAME IS NULL OR
        P_MEMBER.MOTHERS_TELEPHONE_NUMBER IS NULL OR
        P_MEMBER.MOTHERS_EMAIL IS NULL ) THEN
            RAISE EXCEPTIONS_PKG.MISSING_PARAM_EXC;
        ELSE
            INSERT INTO MEMBERS (
                MEMBER_ID,
                FIRST_NAME,
                LAST_NAME,
                MOTHERS_NAME,
                MOTHERS_TELEPHONE_NUMBER,
                MOTHERS_EMAIL,
                MEMBER_EMAIL,
                MEMBER_TELEPHONE_NUMBER,
                BIRTH_DATE,
                ORS_ID,
                PATROL_ID
            ) VALUES (
                OUT_MEMBER_ID,
                P_MEMBER.FIRST_NAME,
                P_MEMBER.LAST_NAME,
                P_MEMBER.MOTHERS_NAME,
                P_MEMBER.MOTHERS_TELEPHONE_NUMBER,
                P_MEMBER.MOTHERS_EMAIL,
                P_MEMBER.MEMBER_EMAIL,
                P_MEMBER.MEMBER_TELEPHONE_NUMBER,
                P_MEMBER.BIRTH_DATE,
                CASE WHEN P_MEMBER.ORS_ID IN ( SELECT ORS_ID FROM ORS ) THEN P_MEMBER.ORS_ID ELSE NULL END,
                P_MEMBER.PATROL_ID
            );
        END IF;

        COMMIT;
    EXCEPTION
        WHEN DUP_VAL_ON_INDEX THEN
            ROLLBACK;
            RAISE_APPLICATION_ERROR ( -20009, 'There is already a Member like that' );
        WHEN EXCEPTIONS_PKG.MISSING_PARAM_EXC THEN
            ROLLBACK;
            DBMS_OUTPUT.PUT_LINE ( 'Missing required information about member' );
        WHEN OTHERS THEN
            ROLLBACK;
            RAISE_APPLICATION_ERROR ( -20011, 'CODE- '|| SQLCODE || 'MESSAGE- ' || SQLERRM );
    END CREATE_MEMBER_FOR_USER;
END MEMBER_PKG;