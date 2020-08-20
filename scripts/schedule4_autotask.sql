!set variable_substitution=true;
use database &{db_name};
use schema &{sc_name};
--
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- Create and schedule the automated tasks
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--
-- Create a task with a monthly schedule
--
CREATE OR REPLACE TASK SELLSIDE_MANUAL_ENTRY_MONTHLY_SETUP
    WAREHOUSE = S1_BI
    SCHEDULE = 'USING CRON 59 23 L * * UTC'
AS
CALL SELLSIDE_CONTRACT_MANUAL_ENTRY_MONTHLY_RENEW (TO_VARCHAR(CURRENT_DATE()+1));
--
-- Enable the monthly scheduled task
--
ALTER TASK SELLSIDE_MANUAL_ENTRY_MONTHLY_SETUP RESUME;
SHOW TASKS;
--
-- Create a task with a daily schedule
--
CREATE OR REPLACE TASK SELLSIDE_MANUAL_ENTRY_DAILY_UPDATE
    WAREHOUSE = S1_BI
    SCHEDULE = 'USING CRON 5 0 * * * UTC'
AS
CALL SELLSIDE_CONTRACT_MANUAL_ENTRY_DAILY_UPDATE(TO_VARCHAR(CURRENT_DATE()));
--
-- Enable the daily scheduled task
--
ALTER TASK SELLSIDE_MANUAL_ENTRY_DAILY_UPDATE RESUME;
SHOW TASKS;
--
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- Extra: Add a task to do some work the daily generated rev data
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--
-- Suspend the root task
--
ALTER TASK SELLSIDE_MANUAL_ENTRY_DAILY_UPDATE SUSPEND;
SHOW TASKS;
--
-- Create follower task with "after" cause point to daily scheduled task
--
CREATE OR REPLACE TASK BUYSIDE_MANUAL_ENTRY_DAILY_THRYV_ALLOCATE
  WAREHOUSE = S1_BI
  AFTER SELLSIDE_MANUAL_ENTRY_DAILY_UPDATE
AS
MERGE INTO BUYSIDE_ACCOUNT_DATA_MANUAL_ENTRY D
USING MANUAL_ENTRY.BUYSIDE_MAPQUEST_THRYV_SPEND S
ON D.DATA_TS = S.DATA_TS
AND D.NETWORK_NAME_ID = S.NETWORK_NAME_ID
AND D.ACCOUNT_ID = S.ACCOUNT_ID
WHEN MATCHED THEN UPDATE 
    SET ACCOUNT_STATUS = S.ACCOUNT_STATUS
      ,NETWORK_NAME = S.NETWORK_NAME
      ,CURRENCY_CODE = S.CURRENCY_CODE
      ,CONVERSION_RATE = S.CONVERSION_RATE
      ,CLICKS = S.CLICKS
      ,IMPRESSIONS = S.IMPRESSIONS
      ,NATIVE_SPEND = S.NATIVE_SPEND
      ,SPEND = S.SPEND
WHEN NOT MATCHED THEN INSERT (
    DATA_TS
    ,ACCOUNT_ID
    ,ACCOUNT_STATUS
    ,NETWORK_NAME
    ,NETWORK_NAME_ID
    ,CURRENCY_CODE
    ,CONVERSION_RATE
    ,CLICKS
    ,IMPRESSIONS
    ,NATIVE_SPEND
    ,SPEND
    )
VALUES (
    S.DATA_TS
    ,S.ACCOUNT_ID
    ,S.ACCOUNT_STATUS
    ,S.NETWORK_NAME
    ,S.NETWORK_NAME_ID
    ,S.CURRENCY_CODE
    ,S.CONVERSION_RATE
    ,S.CLICKS
    ,S.IMPRESSIONS
    ,S.NATIVE_SPEND
    ,S.SPEND
);
--
-- Enable the root taks for hourly scheduled
--
SELECT SYSTEM$TASK_DEPENDENTS_ENABLE('SELLSIDE_MANUAL_ENTRY_DAILY_UPDATE');
SHOW TASKS;
