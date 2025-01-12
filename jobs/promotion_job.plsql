BEGIN
-- job ahhoz hogy a rank_privileges.promotion_time ne legyen réggebbi mint 1 év --> job ehhez

   DBMS_SCHEDULER.CREATE_JOB (
JOB_NAME => 'Clear_invalid_promotions' /*IN VARCHAR2*/,
JOB_TYPE => 'STORED_PROCEDURE' /*IN VARCHAR2*/,
JOB_ACTION => 'RANK_PRIVILEGES_PKG.VALIDATE_PROMOTION_TIME' /*IN VARCHAR2*/,
START_DATE => SYSTIMESTAMP /*IN TIMESTAMP WITH TIME ZONE*/,
REPEAT_INTERVAL => 'FREQ=WEEKLY; BYDAY=SAT;' /*IN VARCHAR2*/,
ENABLED => TRUE /*IN BOOLEAN*/,
AUTO_DROP => FALSE /*IN BOOLEAN*/,
COMMENTS => 'This job is responsible to handle invalidated/expired privilege/rank' /*IN VARCHAR2*/
 );

END;