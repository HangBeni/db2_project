CREATE OR REPLACE TRIGGER ADDRESS_LOG AFTER
    INSERT OR UPDATE OR DELETE ON ADDRESS FOR EACH ROW
DECLARE
    PRAGMA AUTONOMOUS_TRANSACTION;
    V_OPERATION PERSONAL_HISTORY.TR_NAME%TYPE;
    V_MESSAGE   PERSONAL_HISTORY.LOG_MSSG%TYPE;
BEGIN
    CASE
        WHEN INSERTING THEN
            V_OPERATION := 'SUCCESSFUL_INSERT';
            V_MESSAGE := 'Address ' || V_OPERATION || ': ' || :NEW.ZIP_CODE || ', ' || :NEW.COUNTRY || ', ' || :NEW.CITY || ', ' || :NEW.STREET_NAME || ', ' || :NEW.STREET_TYPE || ', ' || :NEW.HOUSE_NUMBER;
        WHEN UPDATING THEN
            V_OPERATION := 'SUCCESSFUL_UPDATE';
            V_MESSAGE := 'Address ' || V_OPERATION || ' NEW: ' || :NEW.ZIP_CODE || ', ' || :NEW.COUNTRY || ', ' || :NEW.CITY || ', ' || :NEW.STREET_NAME || ', ' || :NEW.STREET_TYPE || ', ' || :NEW.HOUSE_NUMBER;
            V_MESSAGE := V_MESSAGE || CHR ( 10 ) ||'OLD: ' || :OLD.ZIP_CODE || ', ' || :OLD.COUNTRY || ', ' || :OLD.CITY || ', ' || :OLD.STREET_NAME || ', ' || :OLD.STREET_TYPE || ', ' || :OLD.HOUSE_NUMBER;
        WHEN DELETING THEN
            V_OPERATION := 'SUCCESSFUL_DELETE';
            V_MESSAGE := 'Address ' || V_OPERATION || ': ' || :OLD.ZIP_CODE || ', ' || :OLD.COUNTRY || ', ' || :OLD.CITY || ', ' || :OLD.STREET_NAME || ', ' || :OLD.STREET_TYPE || ', ' || :OLD.HOUSE_NUMBER;
    END CASE;

    INSERT INTO PERSONAL_HISTORY (
        CHANGER,
        LOG_MSSG,
        MODIFIED_TABLE,
        TR_NAME
    ) VALUES (
        USER,
        V_MESSAGE,
        'ADDRESS',
        V_OPERATION
    );
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        CASE
            WHEN INSERTING THEN
                V_OPERATION := 'FAIL_INSERT';
            WHEN UPDATING THEN
                V_OPERATION := 'FAIL_UPDATE';
            WHEN DELETING THEN
                V_OPERATION := 'FAIL_DELETE';
        END CASE;

        INSERT INTO PERSONAL_HISTORY (
            CHANGER,
            LOG_MSSG,
            MODIFIED_TABLE,
            TR_NAME
        ) VALUES (
            USER,
            V_MESSAGE,
            'ADDRESS',
            V_OPERATION
        );
        COMMIT;
END;
/