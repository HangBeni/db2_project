CREATE OR REPLACE TABLE KNOWLEDGE (
    KNOWLEDGE_ID NUMBER PRIMARY KEY,
    KNOWLEDGE_AUTHOR_ID NUMBER NOT NULL,
    KNOWLEDGE_NAME VARCHAR2(100) NOT NULL,
);

ALTER TABLE KNOWLEDGE
    ADD CONSTRAINT KNOWLEDGE_AUTHOR_FK FOREIGN KEY (
        KNOWLEDGE_ID
    )
        REFERENCES MEMBERS(
            MEMBER_ID
        );

CREATE OR REPLACE TABLE KNOWLEDGE_MEDIA(
    KNOWLEDGE_ID NUMBER NOT NULL,
    MEDIA_ID NUMBER NOT NULL
);

ALTER TABLE KNOWLEDGE_MEDIA
    ADD CONSTRAINT KNOWLEDGE_AUTHOR_PK PRIMARY KEY (
        KNOWLEDGE_ID,
        MEDIA_ID
    );

CREATE OR REPLACE TABLE MEDIA(
    MEDIA_ID NUMBER PRIMARY KEY,
    MEDIA_NAME VARCHAR2(50) NOT NULL,
    MEDIA_VALUE BLOB,
    MEDIA_TYPE VARCHAR2(6) NOT NULL,
    AUTHOR_ID NUMBER NOT NULL,
    CREATED_AT TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

ALTER TABLE MEDIA
    ADD CONSTRAINT MEDIA_AUTHOR_FK FOREIGN KEY (
        AUTHOR_ID
    )
        REFERENCES MEMBERS(
            MEMBER_ID
        );