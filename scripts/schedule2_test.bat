rem ====================================================
rem Schedule-2: Test the solution
rem ----------------------------------------------------
rem Example: chedule2_test.bat BI_TEST MANUAL_ENTRY
rem ====================================================
@echo off
if [%1]==[] goto missDb
if [%2]==[] goto missSchema

@echo Testing the manual entry manager in %1.%2
snowsql ^
--config ..\..\config\.snowsql\config ^
-f .\schedule2_test.sql ^
-o exit_on_error=true ^
-o quiet=true ^
-o friendly=true ^
-D db_name=%1 ^
-D sc_name=%2
@echo The manual entry manager is tested in %1.%2
goto done

:missDb
@echo First argument for DB name is missing!
goto done

:missSchema
@echo Second argument for SCHEMA name is missing!

:done

