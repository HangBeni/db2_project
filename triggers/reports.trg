CREATE OR REPLACE TRIGGER GATHERING_REPORT_LOG AFTER
    INSERT OR UPDATE OR DELETE ON GATHERING_REPORTS FOR EACH ROW
DECLARE
    PRAGMA AUTONOMOUS_TRANSACTION;
    V_OPERATION VARCHAR2 ( 100 );
    V_MESSAGE   REPORT_HISTORY.LOG_MSSG%TYPE;
BEGIN
    CASE
        WHEN INSERTING THEN
            V_OPERATION := 'INSERT';
            INSERT INTO REPORT_HISTORY (
                CHANGER,
                LOG_MSSG,
                MODIFIED_TABLE,
                TR_NAME
            ) VALUES (
                USER,
                'REPORT ' || V_OPERATION || 'ON - ' || :NEW.ORS_ID,
                V_OPERATION,
                'GATHERING_REPORTS'
            );
        WHEN UPDATING THEN
            V_OPERATION := 'UPDATE';
            INSERT INTO REPORT_HISTORY (
                CHANGER,
                LOG_MSSG,
                MODIFIED_TABLE,
                TR_NAME
            ) VALUES (
                USER,
                'REPORT ' || V_OPERATION || 'ON - ' || :NEW.ORS_ID,
                V_OPERATION,
                'GATHERING_REPORTS'
            );
        WHEN DELETING THEN
            V_OPERATION := 'DELETE';
            INSERT INTO REPORT_HISTORY (
                CHANGER,
                LOG_MSSG,
                MODIFIED_TABLE,
                TR_NAME
            ) VALUES (
                USER,
                'REPORT ' || V_OPERATION || 'ON - ' || :OLD.ORS_ID,
                V_OPERATION,
                'GATHERING_REPORTS'
            );
    END CASE;

    COMMIT;
END GATHERING_REPORT_LOG;
/

CREATE OR REPLACE TRIGGER GATHERING_REPORT_MOD_TRG AFTER
    UPDATE ON GATHERING_REPORTS FOR EACH ROW FOLLOWS GATHERING_REPORT_LOG
DECLARE
BEGIN
    :NEW.MODIFIED_AT := SYSTIMESTAMP;
END GATHERING_REPORT_MOD_TRG;
/

CREATE OR REPLACE TRIGGER GATHERING_REPORT_LOG AFTER
    INSERT OR UPDATE OR DELETE ON MEETING FOR EACH ROW
DECLARE
    PRAGMA AUTONOMOUS_TRANSACTION;
    V_OPERATION VARCHAR2 ( 100 );
    V_MESSAGE   REPORT_HISTORY.LOG_MSSG%TYPE;
BEGIN
    CASE
        WHEN INSERTING THEN
            V_OPERATION := 'INSERT';
            INSERT INTO REPORT_HISTORY (
                CHANGER,
                LOG_MSSG,
                MODIFIED_TABLE,
                TR_NAME
            ) VALUES (
                USER,
                'REPORT ' || V_OPERATION || 'ON - ' || :NEW.MEETING_ID,
                V_OPERATION,
                'MEETING'
            );
        WHEN UPDATING THEN
            V_OPERATION := 'UPDATE';
            INSERT INTO REPORT_HISTORY (
                CHANGER,
                LOG_MSSG,
                MODIFIED_TABLE,
                TR_NAME
            ) VALUES (
                USER,
                'REPORT ' || V_OPERATION || 'ON - ' || :NEW.MEETING_ID,
                V_OPERATION,
                'MEETING'
            );
        WHEN DELETING THEN
            V_OPERATION := 'DELETE';
            INSERT INTO REPORT_HISTORY (
                CHANGER,
                LOG_MSSG,
                MODIFIED_TABLE,
                TR_NAME
            ) VALUES (
                USER,
                'REPORT ' || V_OPERATION || 'ON - ' || :OLD.MEETING_ID,
                V_OPERATION,
                'MEETING'
            );
    END CASE;

    COMMIT;
END GATHERING_REPORT_LOG;
/

CREATE OR REPLACE TRIGGER GATHERING_REPORT_MOD_TRG AFTER
    UPDATE ON MEETING FOR EACH ROW FOLLOWS GATHERING_REPORT_LOG
DECLARE
BEGIN
    :NEW.MODIFIED_AT := SYSTIMESTAMP;
END GATHERING_REPORT_MOD_TRG;