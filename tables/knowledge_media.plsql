CREATE TABLE KNOWLEDGE (
    KNOWLEDGE_ID NUMBER PRIMARY KEY,
    KNOWLEDGE_AUTHOR_ID NUMBER NOT NULL,
    KNOWLEDGE_NAME VARCHAR2(100) NOT NULL,
    CONSTRAINT KNOWLEDGE_AUTHOR_FK FOREIGN KEY (KNOWLEDGE_AUTHOR_ID) REFERENCES MEMBERS(MEMBER_ID)
);
CREATE TABLE KNOWLEDGE_MEDIA_ASS(
    KNOWLEDGE_ID NUMBER NOT NULL,
    MEDIA_ID NUMBER NOT NULL,
    PRIMARY KEY (KNOWLEDGE_ID, MEDIA_ID),
    CONSTRAINT KNOWLEDGE_MEDIA_KNOWLEDGE_FK FOREIGN KEY (KNOWLEDGE_ID) REFERENCES KNOWLEDGE(KNOWLEDGE_ID),
    CONSTRAINT KNOWLEDGE_MEDIA_MEDIA_FK FOREIGN KEY (MEDIA_ID) REFERENCES MEDIA(MEDIA_ID)
);
CREATE TABLE MEDIA(
    MEDIA_ID NUMBER PRIMARY KEY,
    MEDIA_NAME VARCHAR2(50) NOT NULL,
    MEDIA_VALUE BLOB,
    MEDIA_TYPE VARCHAR2(6) NOT NULL,
    CREATED_AT TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);