CREATE OR REPLACE PACKAGE ADDRESS_PKG AS

    PROCEDURE CREATE_ADDRESS (
        P_ZIP_CODE IN VARCHAR2,
        P_COUNTRY IN VARCHAR2,
        P_CITY IN VARCHAR2,
        P_STREET_NAME IN VARCHAR2,
        P_STREET_TYPE IN VARCHAR2,
        P_HOUSE_NUMBER IN VARCHAR2
    );

    PROCEDURE CREATE_ADDRESS (
        P_ADDRESS IN ADDRESS%ROWTYPE
    );

    FUNCTION GET_ADDRESS_BY_ID (
        P_ADDRESS_ID IN NUMBER
    ) RETURN ADDRESS%ROWTYPE;

    FUNCTION GET_ADDRESS_BY_RESIDENT (
        P_MEMBER_ID IN NUMBER
    ) RETURN ADDRESS%ROWTYPE;

    PROCEDURE UPDATE_ADDRESS (
        P_ADDRESS_ID IN NUMBER,
        P_ZIP_CODE IN VARCHAR2,
        P_COUNTRY IN VARCHAR2,
        P_CITY IN VARCHAR2,
        P_STREET_NAME IN VARCHAR2,
        P_STREET_TYPE IN VARCHAR2,
        P_HOUSE_NUMBER IN VARCHAR2
    );

    PROCEDURE DELETE_ADDRESS (
        P_ADDRESS_ID IN NUMBER
    );

    PROCEDURE ASSIGN_MEMBER_TO_ADDRESS (
        P_MEMBER_ID IN NUMBER,
        P_ADDRESS_ID IN NUMBER
    );
END ADDRESS_PKG;
/

CREATE OR REPLACE PACKAGE BODY ADDRESS_PKG AS

    FUNCTION ADDRESS_DUPLICATE_FINDER_FN (
        P_ADDRESS IN ADDRESS_TY
    ) RETURN NUMBER IS
        PRAGMA AUTONOMOUS_TRANSACTION;
        V_RETURN_ID NUMBER;
    BEGIN
        SELECT ADDRESS_ID INTO V_RETURN_ID
        FROM ADDRESS
        WHERE 1=1 AND
            TRIM ( UPPER ( ZIP_CODE ) ) = TRIM ( UPPER ( P_ADDRESS.ZIP_CODE ) ) AND
            TRIM ( UPPER ( COUNTRY ) ) = TRIM ( UPPER ( P_ADDRESS.COUNTRY ) ) AND
            TRIM ( UPPER ( CITY ) ) = TRIM ( UPPER ( P_ADDRESS.CITY ) ) AND
            TRIM ( UPPER ( STREET_NAME ) ) = TRIM ( UPPER ( P_ADDRESS.STREET_NAME ) ) AND
            TRIM ( UPPER ( STREET_TYPE ) ) = TRIM ( UPPER ( P_ADDRESS.STREET_TYPE ) ) AND
            TRIM ( UPPER ( HOUSE_NUMBER ) ) = TRIM ( UPPER ( P_ADDRESS.HOUSE_NUMBER ) );
        RETURN V_RETURN_ID;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RETURN 0;
            DBMS_OUTPUT.PUT_LINE ( 'No rows inserted.' );
        WHEN OTHERS THEN
            RETURN 0;
            DBMS_OUTPUT.PUT_LINE ( 'An error was encountered - ' || SQLCODE || ' -ERROR- ' || SQLERRM );
    END ADDRESS_DUPLICATE_FINDER_FN;

    PROCEDURE CREATE_ADDRESS (
        P_ZIP_CODE IN VARCHAR2,
        P_COUNTRY IN VARCHAR2,
        P_CITY IN VARCHAR2,
        P_STREET_NAME IN VARCHAR2,
        P_STREET_TYPE IN VARCHAR2,
        P_HOUSE_NUMBER IN VARCHAR2
    ) IS
        PRAGMA AUTONOMOUS_TRANSACTION;
        V_RESULT  NUMBER;
        V_ADDRESS ADDRESS_TY;
    BEGIN
        V_ADDRESS := ADDRESS_TY ( P_ZIP_CODE, P_COUNTRY, P_CITY, P_STREET_NAME, P_STREET_TYPE, P_HOUSE_NUMBER );
        V_RESULT := ADDRESS_DUPLICATE_FINDER_FN ( P_ADDRESS => V_ADDRESS );
        IF V_RESULT = 0 THEN
            INSERT INTO ADDRESS (
                ZIP_CODE,
                COUNTRY,
                CITY,
                STREET_NAME,
                STREET_TYPE,
                HOUSE_NUMBER
            ) VALUES (
                P_ZIP_CODE,
                P_COUNTRY,
                P_CITY,
                P_STREET_NAME,
                P_STREET_TYPE,
                P_HOUSE_NUMBER
            );
            COMMIT;
        ELSE
            DBMS_OUTPUT.PUT_LINE ( 'Address already exists with ID: ' || V_RESULT );
        END IF;
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE ( 'An error was encountered - ' || SQLCODE || ' -ERROR- ' || SQLERRM );
    END CREATE_ADDRESS;

    PROCEDURE CREATE_ADDRESS (
        P_ADDRESS IN ADDRESS%ROWTYPE
    ) IS
        PRAGMA AUTONOMOUS_TRANSACTION;
        V_RESULT  ADDRESS.ADDRESS_ID%TYPE;
        V_ADDRESS ADDRESS_TY;
    BEGIN
        V_ADDRESS := ADDRESS_TY ( P_ADDRESS.ZIP_CODE, P_ADDRESS.COUNTRY, P_ADDRESS.CITY, P_ADDRESS.STREET_NAME, P_ADDRESS.STREET_TYPE, P_ADDRESS.HOUSE_NUMBER );
        V_RESULT := ADDRESS_DUPLICATE_FINDER_FN ( P_ADDRESS => V_ADDRESS );
        IF V_RESULT = 0 THEN
            INSERT INTO ADDRESS (
                ZIP_CODE,
                COUNTRY,
                CITY,
                STREET_NAME,
                STREET_TYPE,
                HOUSE_NUMBER
            ) VALUES (
                P_ADDRESS.ZIP_CODE,
                P_ADDRESS.COUNTRY,
                P_ADDRESS.CITY,
                P_ADDRESS.STREET_NAME,
                P_ADDRESS.STREET_TYPE,
                P_ADDRESS.HOUSE_NUMBER
            );
            COMMIT;
        ELSE
            DBMS_OUTPUT.PUT_LINE ( 'Address already exists with ID: ' || V_RESULT );
        END IF;
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE ( 'An error was encountered - ' || SQLCODE || ' -ERROR- ' || SQLERRM );
    END CREATE_ADDRESS;

    FUNCTION GET_ADDRESS_BY_ID (
        P_ADDRESS_ID IN NUMBER
    ) RETURN ADDRESS%ROWTYPE AS
        V_ADDRESS ADDRESS%ROWTYPE;
    BEGIN
        SELECT * INTO V_ADDRESS
        FROM ADDRESS
        WHERE ADDRESS_ID = P_ADDRESS_ID;
        RETURN V_ADDRESS;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE ( 'No rows found.' );
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE ( 'An error was encountered - ' || SQLCODE || ' -ERROR- ' || SQLERRM );
    END GET_ADDRESS_BY_ID;

    FUNCTION GET_ADDRESS_BY_RESIDENT (
        P_MEMBER_ID IN NUMBER
    ) RETURN ADDRESS%ROWTYPE AS
        V_ADDRESS ADDRESS%ROWTYPE;
    BEGIN
        SELECT * INTO V_ADDRESS
        FROM ADDRESS
        WHERE ADDRESS_ID IN (
                SELECT ADDRESS_ID
                FROM ADDRESS_MEMBER_ASS
                WHERE MEMBER_ID = P_MEMBER_ID
            );
        RETURN V_ADDRESS;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE ( 'No rows found.' );
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE ( 'An error was encountered - ' || SQLCODE || ' -ERROR- ' || SQLERRM );
    END GET_ADDRESS_BY_RESIDENT;

    PROCEDURE UPDATE_ADDRESS (
        P_ADDRESS_ID IN NUMBER,
        P_ZIP_CODE IN VARCHAR2,
        P_COUNTRY IN VARCHAR2,
        P_CITY IN VARCHAR2,
        P_STREET_NAME IN VARCHAR2,
        P_STREET_TYPE IN VARCHAR2,
        P_HOUSE_NUMBER IN VARCHAR2
    ) AS
        PRAGMA AUTONOMOUS_TRANSACTION;
    BEGIN
        UPDATE ADDRESS
        SET
            ZIP_CODE = P_ZIP_CODE,
            COUNTRY = P_COUNTRY,
            CITY = P_CITY,
            STREET_NAME = P_STREET_NAME,
            STREET_TYPE = P_STREET_TYPE,
            HOUSE_NUMBER = P_HOUSE_NUMBER
        WHERE
            ADDRESS_ID = P_ADDRESS_ID;
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE ( 'An error was encountered - ' || SQLCODE || ' -ERROR- ' || SQLERRM );
    END UPDATE_ADDRESS;

    PROCEDURE DELETE_ADDRESS (
        P_ADDRESS_ID IN NUMBER
    ) AS
        PRAGMA AUTONOMOUS_TRANSACTION;
    BEGIN
        DELETE FROM ADDRESS
        WHERE
            ADDRESS_ID = P_ADDRESS_ID;
        IF SQL%ROWCOUNT = 0 THEN
            RAISE_APPLICATION_ERROR ( -20001, 'No address found with the given ID.' );
        END IF;

        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT .PUT_LINE ( 'An error was encountered - ' || SQLCODE || ' -ERROR- ' || SQLERRM );
    END DELETE_ADDRESS;

    PROCEDURE ASSIGN_MEMBER_TO_ADDRESS (
        P_MEMBER_ID IN NUMBER,
        P_ADDRESS_ID IN NUMBER
    ) AS
        PRAGMA AUTONOMOUS_TRANSACTION;
    BEGIN
        INSERT INTO ADDRESS_MEMBER_ASS (
            ADDRESS_ID,
            MEMBER_ID
        ) VALUES (
            P_ADDRESS_ID,
            P_MEMBER_ID
        );
        COMMIT;
    END ASSIGN_MEMBER_TO_ADDRESS;
END ADDRESS_PKG;