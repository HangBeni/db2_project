CREATE OR REPLACE PACKAGE EVENTS_PKG IS

    PROCEDURE CREATE_EVENT (
        P_EVENT_NAME IN VARCHAR2,
        P_EVENT_DESCRIPTION IN VARCHAR2,
        P_DATE_START IN TIMESTAMP,
        P_DATE_END IN TIMESTAMP
    );

    PROCEDURE CREATE_EVENT (
        P_EVENT_NAME IN VARCHAR2,
        P_DATE_START IN TIMESTAMP,
        P_DATE_END IN TIMESTAMP
    );

    PROCEDURE READ_EVENT (
        P_EVENT_ID IN NUMBER,
        P_EVENT OUT EVENTS%ROWTYPE
    );

    PROCEDURE UPDATE_EVENT (
        P_EVENT_ID IN NUMBER,
        P_EVENT_NAME IN VARCHAR2,
        P_EVENT_DESCRIPTION IN VARCHAR2,
        P_DATE_START IN TIMESTAMP,
        P_DATE_END IN TIMESTAMP
    );

    PROCEDURE UPDATE_EVENT (
        P_EVENT IN EVENTS%ROWTYPE
    );

    PROCEDURE DELETE_EVENT (
        P_EVENT_ID IN NUMBER
    );
END EVENTS_PKG;
/

CREATE OR REPLACE PACKAGE BODY EVENTS_PKG IS

    PROCEDURE CREATE_EVENT (
        P_EVENT_NAME IN VARCHAR2,
        P_EVENT_DESCRIPTION IN VARCHAR2,
        P_DATE_START IN TIMESTAMP,
        P_DATE_END IN TIMESTAMP
    ) IS
    BEGIN
        INSERT INTO EVENTS (
            EVENT_NAME,
            EVENT_DESCRIPTION,
            DATE_START,
            DATE_END
        ) VALUES (
            P_EVENT_NAME,
            P_EVENT_DESCRIPTION,
            P_DATE_START,
            P_DATE_END
        );
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
            DBMS_OUTPUT.PUT_LINE ( 'An error was encountered - ' || SQLCODE || ' -ERROR- ' || SQLERRM );
    END CREATE_EVENT;

    PROCEDURE CREATE_EVENT (
        P_EVENT_NAME IN VARCHAR2,
        P_DATE_START IN TIMESTAMP,
        P_DATE_END IN TIMESTAMP
    ) IS
    BEGIN
        INSERT INTO EVENTS (
            EVENT_NAME,
            DATE_START,
            DATE_END
        ) VALUES (
            P_EVENT_NAME,
            P_DATE_START,
            P_DATE_END
        );
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
            DBMS_OUTPUT.PUT_LINE ( 'An error was encountered - ' || SQLCODE || ' -ERROR- ' || SQLERRM );
    END CREATE_EVENT;

    PROCEDURE READ_EVENT (
        P_EVENT_ID IN NUMBER,
        P_EVENT OUT EVENTS%ROWTYPE
    ) IS
    BEGIN
        SELECT * INTO P_EVENT
        FROM EVENTS
        WHERE EVENT_ID = P_EVENT_ID;
    EXCEPTION
        WHEN TOO_MANY_ROWS THEN
            DBMS_OUTPUT.PUT_LINE ( 'Too many rows has returned - ' || SQLCODE || ' -ERROR- ' || SQLERRM );
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE ( 'An error was encountered - ' || SQLCODE || ' -ERROR- ' || SQLERRM );
    END READ_EVENT;

    PROCEDURE UPDATE_EVENT (
        P_EVENT_ID IN NUMBER,
        P_EVENT_NAME IN VARCHAR2,
        P_EVENT_DESCRIPTION IN VARCHAR2,
        P_DATE_START IN TIMESTAMP,
        P_DATE_END IN TIMESTAMP
    ) IS
        PRAGMA AUTONOMOUS_TRANSACTION;
    BEGIN
        UPDATE EVENTS
        SET
            EVENT_NAME = P_EVENT_NAME,
            EVENT_DESCRIPTION = P_EVENT_DESCRIPTION,
            DATE_START = P_DATE_START,
            DATE_END = P_DATE_END
        WHERE
            EVENT_ID = P_EVENT_ID;
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
            DBMS_OUTPUT.PUT_LINE ( 'An error was encountered - ' || SQLCODE || ' -ERROR- ' || SQLERRM );
    END UPDATE_EVENT;

    PROCEDURE UPDATE_EVENT (
        P_EVENT IN EVENTS%ROWTYPE
    ) IS
        PRAGMA AUTONOMOUS_TRANSACTION;
    BEGIN
        UPDATE EVENTS
        SET
            EVENT_NAME = P_EVENT.EVENT_NAME,
            EVENT_DESCRIPTION = P_EVENT.EVENT_DESCRIPTION,
            DATE_START = P_EVENT.DATE_START,
            DATE_END = P_EVENT.DATE_END
        WHERE
            EVENT_ID = P_EVENT.EVENT_ID;
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
            DBMS_OUTPUT.PUT_LINE ( 'An error was encountered - ' || SQLCODE || ' -ERROR- ' || SQLERRM );
    END UPDATE_EVENT;

    PROCEDURE DELETE_EVENT (
        P_EVENT_ID IN NUMBER
    ) IS
    PRAGMA AUTONOMOUS_TRANSACTION;
    BEGIN
        DELETE FROM EVENTS
        WHERE
            EVENT_ID = P_EVENT_ID;
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
            DBMS_OUTPUT .PUT_LINE ( 'An error was encountered - ' || SQLCODE || ' -ERROR- ' || SQLERRM );
    END DELETE_EVENT;
END EVENTS_PKG;
/