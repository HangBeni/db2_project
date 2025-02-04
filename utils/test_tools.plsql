-- RANKS AND ORSOK
DECLARE
    V_PATROL_ID        NUMBER;
    V_GROUP_LEADER_ID  NUMBER;
    V_GROUP_MEMBER_ID  NUMBER;
    V_PATROL_LEADER_ID NUMBER;
    V_ADDRESS_ID       NUMBER;
    V_MEMBER           MEMBER_TY;
BEGIN
    RANK_DIC_PKG.CREATE_NEW_RANK (
        P_RANK_NAME => 'GROUP LEADER' /*IN VARCHAR2*/
    );
    RANK_DIC_PKG.CREATE_NEW_RANK (
        P_RANK_NAME => 'PATROL LEADER' /*IN VARCHAR2*/
    );
    CONSTANTS_PKG.INIT_RANKS ( );
    RANK_DIC_PKG.CREATE_NEW_RANK (
        P_RANK_NAME => CONSTANTS_PKG.RANKS_NAMES ( 'GL' ) /*IN VARCHAR2*/
    );
    RANK_DIC_PKG.CREATE_NEW_RANK (
        P_RANK_NAME => CONSTANTS_PKG.RANKS_NAMES ( 'PL' ) /*IN VARCHAR2*/
    );
    COMMIT;
    V_MEMBER := MEMBER_TY ( FIRST_NAME => 'Benjamin', LAST_NAME => 'Hang', MOTHERS_NAME => 'Szabó Kata', MOTHERS_TELEPHONE_NUMBER => '+363214215', MOTHERS_EMAIL => 'ghdsj@dsa.com', ORS_ID => NULL );
 
    -- Group leader Member
    MEMBER_PKG.CREATE_MEMBER (
        P_MEMBER =>V_MEMBER
    );
    V_MEMBER := MEMBER_TY ( FIRST_NAME => 'Zsombor', LAST_NAME => 'Nagy', MOTHERS_NAME => 'Kovács Anikó', MOTHERS_TELEPHONE_NUMBER => '+363213315', MOTHERS_EMAIL => 'gfdssj@ssa.com', ORS_ID => NULL );
 
    -- Patrol leader Member
    MEMBER_PKG.CREATE_MEMBER (
        P_MEMBER =>V_MEMBER
    );
    COMMIT;
    SELECT MEMBER_ID INTO V_GROUP_LEADER_ID
    FROM MEMBERS
    WHERE FIRST_NAME = 'Benjamin';
    SELECT MEMBER_ID INTO V_PATROL_LEADER_ID
    FROM MEMBERS
    WHERE FIRST_NAME = 'Zsombor';
 
    -- Promote member to group leader
    RANK_PRIVILEGES_PGK.PROMOTE_MEMBER (
        P_MEMBER_ID => V_GROUP_LEADER_ID /*IN NUMBER*/,
        P_RANK_ID => RANK_DIC_PKG.GET_RANK_ID_BY_NAME ( P_RANK_NAME =>CONSTANTS_PKG.RANKS_NAMES ( 'GL' ) ) /*IN NUMBER*/
    );
 
    -- Promote member to patrol leader
    RANK_PRIVILEGES_PGK.PROMOTE_MEMBER (
        P_MEMBER_ID => V_PATROL_LEADER_ID /*IN NUMBER*/,
        P_RANK_ID => RANK_DIC_PKG.GET_RANK_ID_BY_NAME ( P_RANK_NAME => CONSTANTS_PKG.RANKS_NAMES ( 'PL' ) ) /*IN NUMBER*/
    );
    COMMIT;
 
    -- Patrol
    PATROL_PKG.CREATE_PATROL (
        P_NAME => 'Zsaboborczki Raj' /*IN VARCHAR2*/
    );
    COMMIT;
    SELECT PATROL_ID INTO V_PATROL_ID
    FROM PATROL
    WHERE PATROL_NAME='Zsaboborczki Raj';
 
    -- Group
    ORS_PKG.CREATE_ORS (
        P_NAME => 'TIGRIS' /*IN VARCHAR2*/,
        P_PATROL_ID => V_PATROL_ID /*IN NUMBER*/,
        P_LEADER_ID => V_GROUP_LEADER_ID /*IN NUMBER*/
    );
    COMMIT;
    V_MEMBER := MEMBER_TY ( FIRST_NAME => 'Levente', LAST_NAME => 'Szabó', MOTHERS_NAME => 'Takács Kata', MOTHERS_TELEPHONE_NUMBER => '+364561563', MOTHERS_EMAIL => 'fffsj@dsa.com', ORS_ID => ORS_PKG.GET_ORS_BY_NAME_FUNC ( P_ORS_NAME => 'TIGRIS' /*IN VARCHAR2*/ ) );
 
    -- Group member
    MEMBER_PKG.CREATE_MEMBER (
        P_MEMBER =>V_MEMBER
    );
    COMMIT;
 
    --Assign patrol leader to patrol
    ORS_PKG.ASSIGN_LEADER_TO_ORGANISATION (
        P_LEADER_ID => V_PATROL_LEADER_ID /*IN NUMBER*/,
        P_ORG_ID => V_PATROL_ID /*IN NUMBER*/
    );
    ADDRESS_PKG.CREATE_ADDRESS (
        P_ZIP_CODE => '8000' /*IN VARCHAR2*/,
        P_COUNTRY => 'HUNGARY' /*IN VARCHAR2*/,
        P_CITY =>'SIÓFOK' /*IN VARCHAR2*/,
        P_STREET_NAME =>'LIDÓ' /*IN VARCHAR2*/,
        P_STREET_TYPE =>'UTCA' /*IN VARCHAR2*/,
        P_HOUSE_NUMBER => '2' /*IN VARCHAR2*/
    );
    COMMIT;
 
    --Address Create
    ADDRESS_PKG.CREATE_ADDRESS (
        P_ZIP_CODE => '8020' /*IN VARCHAR2*/,
        P_COUNTRY => 'HUNGARY' /*IN VARCHAR2*/,
        P_CITY =>'TAB' /*IN VARCHAR2*/,
        P_STREET_NAME =>'KOSSUTH' /*IN VARCHAR2*/,
        P_STREET_TYPE =>'UTCA' /*IN VARCHAR2*/,
        P_HOUSE_NUMBER => '22' /*IN VARCHAR2*/
    );
    COMMIT;
    ADDRESS_PKG.CREATE_ADDRESS (
        P_ZIP_CODE => '8020' /*IN VARCHAR2*/,
        P_COUNTRY => 'HUNGARY' /*IN VARCHAR2*/,
        P_CITY =>'TAB' /*IN VARCHAR2*/,
        P_STREET_NAME =>'KOSSUTH' /*IN VARCHAR2*/,
        P_STREET_TYPE =>'UTCA' /*IN VARCHAR2*/,
        P_HOUSE_NUMBER => '22' /*IN VARCHAR2*/
    );
    COMMIT;
 
    --Address Assigns
    SELECT ADDRESS_ID INTO V_ADDRESS_ID
    FROM ADDRESS
    WHERE CITY = 'SIÓFOK';
    ADDRESS_PKG.ASSIGN_MEMBER_TO_ADDRESS (
        P_MEMBER_ID => V_PATROL_LEADER_ID /*IN NUMBER*/,
        P_ADDRESS_ID =>V_ADDRESS_ID /*IN NUMBER*/
    );
    SELECT ADDRESS_ID INTO V_ADDRESS_ID
    FROM ADDRESS
    WHERE CITY = 2;
    ADDRESS_PKG.ASSIGN_MEMBER_TO_ADDRESS (
        P_MEMBER_ID => V_GROUP_LEADER_ID /*IN NUMBER*/,
        P_ADDRESS_ID =>V_ADDRESS_ID /*IN NUMBER*/
    );
    SELECT MEMBER_ID INTO V_GROUP_MEMBER_ID
    FROM MEMBERS
    WHERE FIRST_NAME = 'Levente';
    ADDRESS_PKG.ASSIGN_MEMBER_TO_ADDRESS (
        P_MEMBER_ID => V_GROUP_MEMBER_ID /*IN NUMBER*/,
        P_ADDRESS_ID =>V_ADDRESS_ID /*IN NUMBER*/
    );
EXCEPTION
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR ( -20111, 'CODE- ' || SQLCODE ||' MSSG' || SQLERRM );
END;