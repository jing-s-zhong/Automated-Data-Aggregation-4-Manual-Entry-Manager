!set variable_substitution=true;
use database &{db_name};
use schema &{sc_name};
-------------------------------------------------------
-- Create a dummy aggreagtion table
-------------------------------------------------------
CREATE OR REPLACE SEQUENCE SELLSIDE_CONTRACT_MANUAL_ENTRY_CONFIGURATION_SEQ START = 1 INCREMENT = 1;
ALTER SEQUENCE IF EXISTS SELLSIDE_CONTRACT_MANUAL_ENTRY_CONFIGURATION_SEQ
SET COMMENT = 'Used to generate the default identity value for "SELLSIDE_CONTRACT_MANUAL_ENTRY_CONFIGURATION"';
--
CREATE OR REPLACE TABLE SELLSIDE_CONTRACT_MANUAL_ENTRY_CONFIGURATION (
	ID INTEGER DEFAULT SELLSIDE_CONTRACT_MANUAL_ENTRY_CONFIGURATION_SEQ.NEXTVAL
	,SELLSIDE_CONTRACT_ID NUMBER
	,REVENUE_MONTH DATE
	,MONTHLY_REVENUE_FORECAST FLOAT
	,MONTHLY_REVENUE_ACTUAL FLOAT
	,DATES_IN_MONTH VARIANT
	)
COMMENT = 'This table is used to store and manage the manual entry of the revenue data';
