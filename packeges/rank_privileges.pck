CREATE OR REPLACE PACKAGE RANK_PRIVILEGES_PGK IS

    PROCEDURE PROMOTE_MEMBER (
        P_MEMBER_ID IN NUMBER,
        P_RANK_ID IN NUMBER
    );

    PROCEDURE DEPROMOTE_MEMBER (
        P_MEMBER_ID IN NUMBER,
        P_RANK_ID IN NUMBER
    );

    PROCEDURE LEADER_TO_GROUP (
        P_LEADER_ID IN NUMBER
    );

    PROCEDURE VALIDATE_PROMOTION_TIME;
END RANK_PRIVILEGES_PGK;
/

CREATE OR REPLACE PACKAGE BODY RANK_PRIVILEGES_PGK IS

    PROCEDURE PROMOTE_MEMBER (
        P_MEMBER_ID IN NUMBER,
        P_RANK_ID IN NUMBER
    ) IS
        PRAGMA AUTONOMOUS_TRANSACTION;
    BEGIN
        INSERT INTO RANK_PRIVILEGES (
            MEMBER_ID,
            RANK_ID
        ) VALUES (
            P_MEMBER_ID,
            P_RANK_ID
        );
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE ( 'Error happend at the promotion of the -'|| P_MEMBER_ID || '- to: '||P_RANK_ID );
    END PROMOTE_MEMBER;

    PROCEDURE DEPROMOTE_MEMBER (
        P_MEMBER_ID IN NUMBER,
        P_RANK_ID IN NUMBER
    ) IS
    BEGIN
        DELETE FROM RANK_PRIVILEGES
        WHERE
            MEMBER_ID = P_MEMBER_ID AND
            RANK_ID = P_RANK_ID;
    END DEPROMOTE_MEMBER;

    PROCEDURE LEADER_TO_GROUP (
        P_LEADER_ID IN NUMBER
    ) IS
        PRAGMA AUTONOMOUS_TRANSACTION;
        V_LEADER_IN NUMBER;
        V_IS_LEADER NUMBER;
    BEGIN
        V_IS_LEADER := RANK_DIC_PKG.HAVE_MEMBER_RANK_BY_NAME_FUNC ( P_MEMBER_ID => P_LEADER_ID /*IN NUMBER*/, P_RANK_NAME => 'GROUP_LEADER' /*IN VARCHAR2*/ );
        CASE V_IS_LEADER
            WHEN 1 THEN
                SELECT ORS_ID INTO V_LEADER_IN
                FROM GROUP_LEADERS_VW
                WHERE P_LEADER_ID = LEADER_ID AND
                    ROWNUM = 1;
                IF V_LEADER_IN IS NOT NULL THEN
                    UPDATE MEMBERS M
                    SET
                        M.ORS_ID = V_LEADER_IN
                    WHERE
                        MEMBER_ID = P_LEADER_ID;
                END IF;
                COMMIT;
            ELSE
                RAISE EXCEPTIONS_PKG.INVALID_PRIVILEGE_EXC;
        END CASE;
    EXCEPTION
        WHEN EXCEPTIONS_PKG.INVALID_PRIVILEGE_EXC THEN
            ROLLBACK;
            DBMS_OUTPUT.PUT_LINE ( 'The member ( '|| P_LEADER_ID || ' ) have not group leader rank' );
    END LEADER_TO_GROUP;

    PROCEDURE VALIDATE_PROMOTION_TIME AS
    BEGIN
        DELETE RANK_PRIVILEGES
        WHERE
            PROMOTION_TIME_END >= SYSTIMESTAMP;
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE ( 'Error has happend at validating promotions' );
    END VALIDATE_PROMOTION_TIME;
END RANK_PRIVILEGES_PGK;