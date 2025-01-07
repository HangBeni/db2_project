CREATE OR REPLACE PACKAGE DUTY_PKG AS

    PROCEDURE INSERT_DUTY (
        P_DUTY_NAME IN VARCHAR2,
        P_DUTY_DESCRIPTION IN VARCHAR2
    );

    PROCEDURE UPDATE_DUTY (
        P_DUTY_ID IN NUMBER,
        P_DUTY_NAME IN VARCHAR2,
        P_DUTY_DESCRIPTION IN VARCHAR2
    );

    PROCEDURE DELETE_DUTY (
        P_DUTY_ID IN NUMBER
    );

    FUNCTION GET_DUTIES_FUNC RETURN DUTY_TABLE;
END DUTY_PKG;
/

CREATE OR REPLACE PACKAGE BODY DUTY_PKG AS
 
    -- TODO:Csak olyan inzertálhat, módosíthat vagy törölhet feladatot aki felelős a programért v. [csp. + helyettes, rp + helyettes, titkár]
    --Láthatóság/jogosultság kezelés
    PROCEDURE INSERT_DUTY (
        P_DUTY_NAME IN VARCHAR2,
        P_DUTY_DESCRIPTION IN VARCHAR2
    ) AS
    BEGIN
        INSERT INTO DUTIES (
            DUTY_NAME,
            DUTY_DESCRIPTION
        ) VALUES (
            P_DUTY_NAME,
            P_DUTY_DESCRIPTION
        );
        COMMIT;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('No rows inserted.');
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('An error was encountered - ' || SQLCODE || ' -ERROR- ' || SQLERRM);
    END INSERT_DUTY;

    PROCEDURE UPDATE_DUTY (
        P_DUTY_ID IN NUMBER,
        P_DUTY_NAME IN VARCHAR2,
        P_DUTY_DESCRIPTION IN VARCHAR2
    ) AS
    BEGIN
        UPDATE DUTIES
        SET
            DUTY_NAME = P_DUTY_NAME,
            DUTY_DESCRIPTION = P_DUTY_DESCRIPTION
        WHERE
            DUTY_ID = P_DUTY_ID;
        IF SQL%ROWCOUNT = 0 THEN
            ROLLBACK;
            RAISE_APPLICATION_ERROR(-22000, 'Duty ID not found');
        END IF;

        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
            DBMS_OUTPUT.PUT_LINE('An error was encountered - ' || SQLCODE || ' -ERROR- ' || SQLERRM);
    END UPDATE_DUTY;

    PROCEDURE DELETE_DUTY (
        P_DUTY_ID IN NUMBER
    ) AS
    BEGIN
        DELETE FROM DUTIES
        WHERE
            DUTY_ID = P_DUTY_ID;
        IF SQL%ROWCOUNT = 0 THEN
            ROLLBACK;
            RAISE_APPLICATION_ERROR(-22000, 'Duty ID not found');
        END IF;
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
            DBMS_OUTPUT.PUT_LINE('An error was encountered - ' || SQLCODE || ' -ERROR- ' || SQLERRM);
    END DELETE_DUTY;

    FUNCTION GET_DUTIES_FUNC RETURN DUTY_TABLE IS
        V_DUTY_TABLE DUTY_TABLE := DUTY_TABLE();
    BEGIN
        SELECT DUTY_REC(DUTY_ID, DUTY_NAME, DUTY_DESCRIPTION) BULK COLLECT INTO V_DUTY_TABLE
        FROM DUTIES;
        RETURN V_DUTY_TABLE;
    END;
END DUTY_PKG;
/