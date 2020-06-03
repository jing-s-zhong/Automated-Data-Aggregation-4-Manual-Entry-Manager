rem ====================================================
rem Schedule-3: Empty the test data
rem ----------------------------------------------------
rem Example: schedule3_empty.bat BI_TEST MANUAL_ENTRY
rem ====================================================
@echo off
if [%1]==[] goto missDb
if [%2]==[] goto missSchema

@echo Emptying the manual entry manager in %1.%2
snowsql ^
--config ..\..\config\.snowsql\config ^
-f .\schedule3_empty.sql ^
-o exit_on_error=true ^
-o quiet=true ^
-o friendly=true ^
-D db_name=%1 ^
-D sc_name=%2
@echo The manual entry manager in %1.%2 is emptyed
goto done

:missDb
@echo First argument for DB is missing!
goto done

:missSchema
@echo Second argument for SCHEMA is missing!

:done
