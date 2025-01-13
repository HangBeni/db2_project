CREATE OR REPLACE PACKAGE PATROL_PKG AS

    PROCEDURE CREATE_PATROL (
        P_NAME IN VARCHAR2,
        P_LEADER IN NUMBER
    );

    PROCEDURE CREATE_PATROL (
        P_NAME IN VARCHAR2
    );

    PROCEDURE ASSIGN_LEADER_TO_PATROL (
        P_LEADER_ID IN NUMBER,
        P_PATROL_ID IN NUMBER
    );
END PATROL_PKG;
/

CREATE OR REPLACE PACKAGE BODY PATROL_PKG AS

    PROCEDURE CREATE_PATROL (
        P_NAME IN VARCHAR2,
        P_LEADER IN NUMBER
    ) IS
        PRAGMA AUTONOMOUS_TRANSACTION;
    BEGIN
        INSERT INTO PATROL (
            PATROL_NAME,
            LEADER_ID
        ) VALUES (
            P_NAME,
            P_LEADER
        );
        COMMIT;
    EXCEPTION
        WHEN DUP_VAL_ON_INDEX THEN
            RAISE_APPLICATION_ERROR ( -20009, 'There is already an '|| P_NAME || ' Patrol' );
    END CREATE_PATROL;

    PROCEDURE CREATE_PATROL (
        P_NAME IN VARCHAR2
    ) IS
    BEGIN
        INSERT INTO PATROL (
            PATROL_NAME
        ) VALUES (
            P_NAME
        );
    EXCEPTION
        WHEN DUP_VAL_ON_INDEX THEN
            RAISE_APPLICATION_ERROR ( -20009, 'There is already an '|| P_NAME || ' Patrol' );
    END CREATE_PATROL;

    PROCEDURE ASSIGN_LEADER_TO_PATROL (
        P_LEADER_ID IN NUMBER,
        P_PATROL_ID IN NUMBER
    ) IS
        PRAGMA AUTONOMOUS_TRANSACTION;
        V_PATROL_EXISTS NUMBER;
    BEGIN
        SELECT 1 INTO V_PATROL_EXISTS
        FROM PATROL
        WHERE PATROL_ID = P_PATROL_ID;
        IF V_PATROL_EXISTS > 0 THEN
            UPDATE PATROL
            SET
                LEADER_ID = P_LEADER_ID
            WHERE
                PATROL_ID = P_ORG_ID;
            COMMIT;
        END IF;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE ( 'No such patrol/raj found: ' || P_ORG_ID );
            END;
        WHEN     OTHERS THEN
            DBMS_OUTPUT.PUT_LINE ( 'An error was encountered - ' || SQLCODE || ' -ERROR- ' || SQLERRM );
            ROLLBACK;
        END ASSIGN_LEADER_TO_PATROL;
    END PATROL_PKG;