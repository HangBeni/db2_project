CREATE OR REPLACE PACKAGE ORS_PKG AS

    FUNCTION GET_RANDOM_ORS_FUNC RETURN ORS.ORS_ID%TYPE;

    FUNCTION GET_ORS_BY_ID_FUNC (
        P_ORS_ID ORS.ORS_ID%TYPE
    ) RETURN ORS.ORS_NAME%TYPE;

    FUNCTION GET_ORS_BY_NAME_FUNC (
        P_ORS_NAME ORS.ORS_NAME%TYPE
    ) RETURN ORS.ORS_ID%TYPE;

    PROCEDURE CREATE_ORS (
        P_NAME IN VARCHAR2,
        P_PATROL_ID IN NUMBER,
        P_LEADER_ID IN NUMBER
    );

    PROCEDURE CREATE_ORS (
        P_NAME IN VARCHAR2,
        P_PATROL_ID IN NUMBER
    );

    PROCEDURE ASSIGN_LEADER_TO_GROUP (
        P_LEADER_ID IN NUMBER,
        P_GROUP_ID IN NUMBER
    );
END ORS_PKG;
/

CREATE OR REPLACE PACKAGE BODY ORS_PKG AS

    FUNCTION GET_RANDOM_ORS_FUNC RETURN ORS.ORS_ID%TYPE IS
        V_RESULT ORS.ORS_ID%TYPE;
    BEGIN
        SELECT ORS_ID INTO V_RESULT
        FROM ORS
        WHERE ROWNUM = 1
        ORDER BY DBMS_RANDOM.VALUE;
        RETURN V_RESULT;
    END GET_RANDOM_ORS_FUNC;

    FUNCTION GET_ORS_BY_ID_FUNC (
        P_ORS_ID ORS.ORS_ID%TYPE
    ) RETURN ORS.ORS_NAME%TYPE IS
        V_RESULT ORS.ORS_NAME%TYPE;
    BEGIN
        SELECT ORS_NAME INTO V_RESULT
        FROM ORS
        WHERE ORS_ID = P_ORS_ID;
        CASE NVL ( V_RESULT, 0 )
            WHEN 0 THEN
                RAISE EXCEPTIONS_PKG.NOT_FOUND_ORS_EXC;
            ELSE
                RETURN V_RESULT;
        END CASE;
    EXCEPTION
        WHEN EXCEPTIONS_PKG.NOT_FOUND_ORS_EXC THEN
            DBMS_OUTPUT.PUT_LINE ( 'Ors ID does not found - ' || SQLCODE || ' -ERROR- ' || SQLERRM );
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE ( 'An error was encountered - ' || SQLCODE || ' -ERROR- ' || SQLERRM );
    END GET_ORS_BY_ID_FUNC;

    FUNCTION GET_ORS_BY_NAME_FUNC (
        P_ORS_NAME ORS.ORS_NAME%TYPE
    ) RETURN ORS.ORS_ID%TYPE IS
        V_RESULT ORS.ORS_ID%TYPE;
    BEGIN
        SELECT ORS_ID INTO V_RESULT
        FROM ORS
        WHERE ORS_NAME = P_ORS_NAME;
        CASE NVL ( V_RESULT, 0 )
            WHEN 0 THEN
                RAISE EXCEPTIONS_PKG.NOT_FOUND_ORS_EXC;
            ELSE
                RETURN V_RESULT;
        END CASE;
    EXCEPTION
        WHEN EXCEPTIONS_PKG.NOT_FOUND_ORS_EXC THEN
            DBMS_OUTPUT.PUT_LINE ( 'Ors ID does not found - ' || SQLCODE || ' -ERROR- ' || SQLERRM );
        WHEN TOO_MANY_ROWS THEN
            DBMS_OUTPUT.PUT_LINE ( 'Too many rows found - ' || SQLCODE || ' -ERROR- ' || SQLERRM );
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE ( 'An error was encountered - ' || SQLCODE || ' -ERROR- ' || SQLERRM );
    END GET_ORS_BY_NAME_FUNC;

    PROCEDURE CREATE_ORS (
        P_NAME IN VARCHAR2,
        P_PATROL_ID IN NUMBER,
        P_LEADER_ID IN NUMBER
    ) IS
    PRAGMA AUTONOMOUS_TRANSACTION;
    BEGIN
        INSERT INTO ORS (
            ORS_NAME,
            PATROL_ID,
            LEADER_ID
        ) VALUES (
            P_NAME,
            P_PATROL_ID,
            P_LEADER_ID
        );
        COMMIT;
    EXCEPTION
        WHEN DUP_VAL_ON_INDEX THEN
            RAISE_APPLICATION_ERROR ( -20009, 'There is already an '|| P_NAME || ' Group' );
    END CREATE_ORS;

    PROCEDURE CREATE_ORS (
        P_NAME IN VARCHAR2,
        P_PATROL_ID IN NUMBER
    ) IS
        V_LEADER_ID NUMBER;
    BEGIN
        V_LEADER_ID := MEMBER_PKG.GET_RANDOM_GROUP_LEADER_FUNC ( );
        IF V_LEADER_ID IS NULL THEN
            INSERT INTO ORS (
                ORS_NAME,
                PATROL_ID
            ) VALUES (
                P_NAME,
                P_PATROL_ID
            );
        ELSE
            INSERT INTO ORS (
                ORS_NAME,
                PATROL_ID,
                LEADER_ID
            ) VALUES (
                P_NAME,
                P_PATROL_ID,
                V_LEADER_ID
            );
        END IF;
    EXCEPTION
        WHEN DUP_VAL_ON_INDEX THEN
            RAISE_APPLICATION_ERROR ( -20009, 'There is already an '|| P_NAME || ' Group' );
    END CREATE_ORS;

    PROCEDURE ASSIGN_LEADER_TO_GROUP (
        P_LEADER_ID IN NUMBER,
        P_GROUP_ID IN NUMBER
    ) IS
        PRAGMA AUTONOMOUS_TRANSACTION;
        V_GROUP_EXISTS  NUMBER;
    BEGIN
        SELECT 1 INTO V_GROUP_EXISTS
        FROM ORS
        WHERE ORS_ID = P_GROUP_ID;
        IF V_GROUP_EXISTS > 0 THEN
        UPDATE ORS
        SET
            LEADER_ID = P_LEADER_ID
        WHERE
            ORS_ID = P_ORG_ID;
        COMMIT;
        END IF;
    EXCEPTION          
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE ( 'No such group/ors found: ' || P_ORG_ID );
    END;

    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE ( 'An error was encountered - ' || SQLCODE || ' -ERROR- ' || SQLERRM );
        ROLLBACK;
    END ASSIGN_LEADER_TO_GROUP;
END ORS_PKG;
/

-- CONNECT CSERKESZ_ADMIN/12345678@XE_LOCAL;