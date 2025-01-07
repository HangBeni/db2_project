CREATE OR REPLACE PACKAGE MEETING_PKG AS

    PROCEDURE NEW_MEETING_FROM_XML (
        P_MEETING_XML CLOB
    );

    PROCEDURE EDIT_MEETING_CONTENT_BY_ID (
        P_MEETING_ID NUMBER,
        P_NEW_CONTENT CLOB
    );

    PROCEDURE DELETE_MEETING_BY_ID (
        P_MEETING_ID NUMBER
    );

    FUNCTION GET_MEETING_BY_ID (
        P_MEETING_ID NUMBER
    ) RETURN MEETING%ROWTYPE;

    PROCEDURE GET_MEETINGS_BY_AUTHOR (
        P_AUTHOR_ID NUMBER,
        P_MEETINGS OUT SYS_REFCURSOR
    );

    PROCEDURE GET_MEETINGS_BY_EVENT (
        P_EVENT_ID NUMBER,
        P_MEETINGS OUT SYS_REFCURSOR
    );
END MEETING_PKG;
/

CREATE OR REPLACE PACKAGE BODY MEETING_PKG AS
 
    -- New meeting from xml
    PROCEDURE NEW_MEETING_FROM_XML (
        P_MEETING_XML CLOB
    ) AS
        V_MEETING_CONTENT CLOB;
        V_AUTHOR_ID       NUMBER;
        V_EVENT_ID        NUMBER;
    BEGIN
        SELECT EXTRACTVALUE(XMLTYPE(P_MEETING_XML), '/meeting/content'),
            EXTRACTVALUE(XMLTYPE(P_MEETING_XML), '/meeting/author_id'),
            EXTRACTVALUE(XMLTYPE(P_MEETING_XML), '/meeting/event_id') INTO V_MEETING_CONTENT,
            V_AUTHOR_ID,
            V_EVENT_ID
        FROM DUAL;
 
        IF V_MEETING_CONTENT IS NULL OR V_AUTHOR_ID IS NULL OR V_EVENT_ID IS NULL THEN
            RAISE EXCEPTIONS_PKG.INVALID_FORMAT_EXC;
        END IF;

        INSERT INTO MEETING (
            MEETING_CONTENT,
            AUTHOR_ID,
            EVENT_ID
        ) VALUES (
            V_MEETING_CONTENT,
            V_AUTHOR_ID,
            V_EVENT_ID
        );
        COMMIT;
    EXCEPTION
        WHEN EXCEPTIONS_PKG.INVALID_FORMAT_EXC THEN
            ROLLBACK;
            DBMS_OUTPUT.PUT_LINE('Invalid format, file must contain meeting content, author, and event');
            DBMS_OUTPUT.PUT_LINE(' Invalid XML: ' || P_MEETING_XML);
        WHEN OTHERS THEN
            ROLLBACK;
            DBMS_OUTPUT.PUT_LINE('An error was encountered - ' || SQLCODE || ' -ERROR- ' || SQLERRM);
    END NEW_MEETING_FROM_XML;
 

    -- Edit meeting content by id
    PROCEDURE EDIT_MEETING_CONTENT_BY_ID (
        P_MEETING_ID NUMBER,
        P_NEW_CONTENT CLOB
    ) AS
    BEGIN
        UPDATE MEETING
        SET
            MEETING_CONTENT = P_NEW_CONTENT
        WHERE
            MEETING_ID = P_MEETING_ID;
        IF SQL%ROWCOUNT = 0 THEN
            RAISE_APPLICATION_ERROR(-21000, 'Meeting ID not found');
        END IF;

        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
            DBMS_OUTPUT.PUT_LINE('An error was encountered - ' || SQLCODE || ' -ERROR- ' || SQLERRM);
    END EDIT_MEETING_CONTENT_BY_ID;
 

    -- Delete meeting by id
    PROCEDURE DELETE_MEETING_BY_ID (
        P_MEETING_ID NUMBER
    ) AS
    BEGIN
        DELETE FROM MEETING
        WHERE
            MEETING_ID = P_MEETING_ID;
        IF SQL%ROWCOUNT = 0 THEN
            ROLLBACK;
            RAISE_APPLICATION_ERROR(-21000, 'Meeting ID not found');
        END IF;

        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
            DBMS_OUTPUT.PUT_LINE('An error was encountered - ' || SQLCODE || ' -ERROR- ' || SQLERRM);
    END DELETE_MEETING_BY_ID;
 

    -- Get meeting by id
    FUNCTION GET_MEETING_BY_ID (
        P_MEETING_ID NUMBER
    ) RETURN MEETING%ROWTYPE IS
        V_MEETING MEETING%ROWTYPE;
    BEGIN
        SELECT * INTO V_MEETING
        FROM MEETING
        WHERE MEETING_ID = P_MEETING_ID;
        IF SQL%NOTFOUND THEN
            ROLLBACK;
            RAISE_APPLICATION_ERROR(-21000, 'Meeting ID not found');
        END IF;

        RETURN V_MEETING;
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('An error was encountered - ' || SQLCODE || ' -ERROR- ' || SQLERRM);
            RETURN NULL;
    END GET_MEETING_BY_ID;
    -- TODO: GET MEETINGS create for type?
    PROCEDURE GET_MEETINGS_BY_AUTHOR (
        P_AUTHOR_ID NUMBER,
        P_MEETINGS OUT SYS_REFCURSOR
    ) AS
    BEGIN
        OPEN P_MEETINGS FOR
            SELECT *
            FROM MEETING
            WHERE AUTHOR_ID = P_AUTHOR_ID;
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('An error was encountered - ' || SQLCODE || ' -ERROR- ' || SQLERRM);
            IF P_MEETINGS%ISOPEN THEN
                CLOSE P_MEETINGS;
            END IF;
    END GET_MEETINGS_BY_AUTHOR;
-- TODO: GET MEETINGS create for type?
    PROCEDURE GET_MEETINGS_BY_EVENT (
        P_EVENT_ID NUMBER,
        P_MEETINGS OUT SYS_REFCURSOR
    ) AS
    BEGIN
        OPEN P_MEETINGS FOR
            SELECT *
            FROM MEETING
            WHERE EVENT_ID = P_EVENT_ID;
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('An error was encountered - ' || SQLCODE || ' -ERROR- ' || SQLERRM);
            IF P_MEETINGS%ISOPEN THEN
                CLOSE P_MEETINGS;
            END IF;
    END GET_MEETINGS_BY_EVENT;
END MEETING_PKG;