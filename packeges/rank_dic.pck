CREATE OR REPLACE PACKAGE RANK_DIC_PKG IS

    FUNCTION HAVE_MEMBER_RANK_BY_NAME_FUNC(
        P_MEMBER_ID RANK_PRIVILEGES.MEMBER_ID%TYPE,
        P_RANK_NAME RANK_DICTIONARY.RANK_NAME%TYPE
    ) RETURN NUMBER;

    FUNCTION HAVE_MEMBER_RANK_BY_ID_FUNC(
        P_MEMBER_ID RANK_PRIVILEGES.MEMBER_ID%TYPE,
        P_RANK_ID RANK_PRIVILEGES.RANK_ID%TYPE
    ) RETURN NUMBER;

    PROCEDURE CREATE_NEW_RANK(
        P_RANK_NAME RANK_DICTIONARY.RANK_NAME%TYPE
    );

    PROCEDURE DELETE_RANK_BY_NAME(
        P_RANK_NAME RANK_DICTIONARY.RANK_NAME%TYPE
    );

    PROCEDURE DELETE_RANK_BY_ID(
        P_RANK_ID RANK_DICTIONARY.RANK_ID%TYPE
    );
END RANK_DIC_PKG;
/

CREATE OR REPLACE PACKAGE BODY RANK_DIC_PKG IS

    FUNCTION HAVE_MEMBER_RANK_BY_NAME_FUNC(
        P_MEMBER_ID RANK_PRIVILEGES.MEMBER_ID%TYPE,
        P_RANK_NAME RANK_DICTIONARY.RANK_NAME%TYPE
    ) RETURN NUMBER IS
        V_RESULT NUMBER;
    BEGIN
        SELECT CASE
                WHEN COUNT(*) > 0 THEN
                    1
                ELSE
                    0
            END INTO V_RESULT
        FROM MEMBERS_RANK_VW
        WHERE MEMBER_ID = P_MEMBER_ID AND
            INSTR(ALL_RANKS, P_RANK_NAME) <> 0;
        RETURN V_RESULT;
    END HAVE_MEMBER_RANK_BY_NAME_FUNC;

    FUNCTION HAVE_MEMBER_RANK_BY_ID_FUNC(
        P_MEMBER_ID RANK_PRIVILEGES.MEMBER_ID%TYPE,
        P_RANK_ID RANK_PRIVILEGES.RANK_ID%TYPE
    ) RETURN NUMBER IS
        V_RESULT NUMBER;
    BEGIN
        SELECT CASE
                WHEN COUNT(*) > 0 THEN
                    1
                ELSE
                    0
            END INTO V_RESULT
        FROM RANK_PRIVILEGES
        WHERE MEMBER_ID = P_MEMBER_ID AND
            RANK_ID = P_RANK_ID;
        RETURN V_RESULT;
    END HAVE_MEMBER_RANK_BY_ID_FUNC;

    PROCEDURE CREATE_NEW_RANK(
        P_RANK_NAME RANK_DICTIONARY.RANK_NAME%TYPE
    ) IS
    BEGIN
        INSERT INTO RANK_DICTIONARY(
            RANK_NAME
        ) VALUES (
            P_RANK_NAME
        );
        COMMIT;
    END;

    PROCEDURE DELETE_RANK_BY_NAME(
        P_RANK_NAME RANK_DICTIONARY.RANK_NAME%TYPE
    ) IS
        V_RANK_COUNT NUMBER;
    BEGIN
        SELECT COUNT(*) INTO V_RANK_COUNT
        FROM RANK_PRIVILEGES
        WHERE RANK_PRIVILEGES.RANK_ID = (
                SELECT RANK_ID
                FROM RANK_DICTIONARY
                WHERE RANK_NAME = P_RANK_NAME
            );
        CASE
            WHEN V_RANK_COUNT = 0 THEN
                DELETE FROM RANK_DICTIONARY
                WHERE
                    RANK_NAME = P_RANK_NAME;
                COMMIT;
            WHEN V_RANK_COUNT > 0 THEN
                RAISE_APPLICATION_ERROR(-20001, 'This rank is in use');
        END CASE;
    END DELETE_RANK_BY_NAME;

    PROCEDURE DELETE_RANK_BY_ID(
        P_RANK_ID RANK_DICTIONARY.RANK_ID%TYPE
    ) IS
        V_RANK_COUNT NUMBER;
    BEGIN
        SELECT COUNT(*) INTO V_RANK_COUNT
        FROM RANK_PRIVILEGES
        WHERE RANK_PRIVILEGES.RANK_ID = P_RANK_ID;
        CASE
            WHEN V_RANK_COUNT = 0 THEN
                DELETE FROM RANK_DICTIONARY
                WHERE
                    RANK_NAME = P_RANK_ID;
                COMMIT;
            WHEN V_RANK_COUNT > 0 THEN
                RAISE_APPLICATION_ERROR(-20001, 'This rank is in use');
        END CASE;
    END DELETE_RANK_BY_ID;
END RANK_DIC_PKG;