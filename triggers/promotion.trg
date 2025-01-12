CREATE OR REPLACE TRIGGER MEMBER_PROMOTION_LOG AFTER
    INSERT OR DELETE ON RANK_PRIVILEGES FOR EACH ROW
DECLARE
    PRAGMA AUTONOMOUS_TRANSACTION;
    V_OPERATION VARCHAR2 ( 100 );
    V_MESSAGE   INTERNAL_ASSIGNS_HISTORY.LOG_MSSG%TYPE;
BEGIN
    CASE
        WHEN INSERTING THEN
            V_MESSAGE := 'INSERT_NEW_PROMOTION';
            V_OPERATION := 'INSERT';
        WHEN DELETING THEN
            V_MESSAGE := 'DELETE_DEPROMOTION';
            V_OPERATION := 'DELETE';
            IF RANK_DIC_PKG.HAVE_MEMBER_RANK_BY_NAME_FUNC (
                P_MEMBER_ID => :OLD.MEMBER_ID /*IN NUMBER*/,
                P_RANK_NAME => CONSTANTS_PKG.RANKS_NAMES ( 'GL' ) /*IN NUMBER*/
            ) = 1 THEN
                UPDATE MEMBERS
                SET
                    ORS_ID = NULL
                WHERE
                    MEMBER_ID = :OLD.MEMBER_ID;
                V_MESSAGE := V_MESSAGE || ' GROUP LEADER ORS_ID IS SET NULL';
                COMMIT;
            END IF;
    END CASE;

    IF INSTR ( V_OPERATION, 'INSERT' ) <> 0 AND HAVE_MEMBER_RANK_BY_NAME_FUNC (
        P_MEMBER_ID => :NEW.MEMBER_ID /*IN NUMBER*/,
        P_RANK_NAME => 'GROUP_LEADER' /*IN VARCHAR2*/
    ) = 1 THEN
        RANK_PRIVILEGES_PGK.LEADER_TO_GROUP (
            P_LEADER_ID => :NEW.MEMBER_ID /*IN NUMBER*/
        );
        V_MESSAGE := V_MESSAGE || ' GROUP LEADER IS MOVED TO: ';
        SELECT V_MESSAGE || O.ORS_NAME INTO V_MESSAGE
        FROM GROUP_LEADERS_VW GL
            INNER JOIN ORS O
            ON GL.ORS_ID = O.ORS_ID;
    END IF;

    INSERT INTO INTERNAL_ASSIGNS_HISTORY (
        CHANGER,
        LOG_MSSG,
        MODIFIED_TABLE,
        TR_NAME
    ) VALUES (
        USER,
        V_MESSAGE,
        'RANK_PRIVILEGES',
        V_OPERATION
    );
    COMMIT;
END;
/

CREATE OR REPLACE TRIGGER RANK_DICTIONARY_LOG AFTER
    INSERT OR UPDATE OR DELETE ON RANK_DICTIONARY FOR EACH ROW
DECLARE
    V_OPERATION VARCHAR2 ( 100 );
    PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN
    CASE
        WHEN INSERTING THEN
            V_OPERATION := 'INSERT';
        WHEN UPDATING THEN
            V_OPERATION := 'UPDATE';
        WHEN DELETING THEN
            V_OPERATION := 'DELETE';
    END CASE;

    INSERT INTO INTERNAL_ASSIGNS_HISTORY (
        CHANGER,
        LOG_MSSG,
        MODIFIED_TABLE,
        TR_NAME
    ) VALUES (
        USER,
        'Rank ' || V_OPERATION || ': ' || :NEW.RANK_NAME,
        V_OPERATION,
        'RANK_DICTIONARY'
    );
    COMMIT;
END RANK_DICTIONARY_LOG;
/

CREATE OR REPLACE TRIGGER RANK_CONSTANT_UPDATE_TRG AFTER
    INSERT OR UPDATE OR DELETE ON RANK_DICTIONARY 
DECLARE
BEGIN
    CONSTANTS_PKG .INIT_RANKS;
END RANK_CONSTANT_UPDATE_TRG;