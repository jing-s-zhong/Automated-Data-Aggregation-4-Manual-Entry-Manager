rem ====================================================
rem Schedule-5: Remove the solution
rem ----------------------------------------------------
rem Example: schedule5_remove.bat BI_TEST MANUAL_ENTRY
rem ====================================================
@echo off
if [%1]==[] goto missDb
if [%2]==[] goto missSchema

@echo Removing the manual entry manager from %1.%2
snowsql ^
--config ..\..\config\.snowsql\config ^
-f .\schedule5_remove.sql ^
-o exit_on_error=true ^
-o quiet=true ^
-o friendly=true ^
-D db_name=%1 ^
-D sc_name=%2
@echo The manual entry manager in %1.%2 has been removed
goto done

:tooFew
@echo Need two arguments for DB and SCHEMA!
goto done

:missDb
@echo First argument for DB is missing!
goto done

:missSchema
@echo Second argument for SCHEMA is missing!

:done

