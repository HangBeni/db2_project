CREATE TABLE ADDRESS (
    ADDRESS_ID NUMBER PRIMARY KEY,
    ZIP_CODE VARCHAR2 ( 10 ) NOT NULL,
    COUNTRY VARCHAR2 ( 50 ) NOT NULL,
    CITY VARCHAR2 ( 50 ) NOT NULL,
    STREET_NAME VARCHAR2 ( 100 ) NOT NULL,
    STREET_TYPE VARCHAR2 ( 40 ) NOT NULL,
    HOUSE_NUMBER VARCHAR2 ( 30 ) NOT NULL,
    CONSTRAINT ZIP_CH CHECK ( REGEXP_LIKE ( ZIP_CODE, '^[0-9]{1,10}$' ) )
);

CREATE TABLE ADDRESS_MEMBER_ASS (
    ADDRESS_ID NUMBER NOT NULL,
    MEMBER_ID NUMBER NOT NULL,
    CONSTRAINT MEMBER_ADDRESS_PK PRIMARY KEY ( ADDRESS_ID, MEMBER_ID ),
    CONSTRAINT ADDRESS_PK FOREIGN KEY ( ADDRESS_ID ) REFERENCES ADDRESS ( ADDRESS_ID ),
    CONSTRAINT MEMBER_PK FOREIGN KEY ( MEMBER_ID ) REFERENCES MEMBERS ( MEMBER_ID )
);