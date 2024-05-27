REM EDS PLM
REM
REM File: delete_user.sql
REM
REM ****************************************************************************
REM Revision    History:
REM Date        Author         Comment
REM =========   ======         =================================================
REM 12-Mar-03   Van Nguyen     Initial.
REM
REM ****************************************************************************

REM This script drops the TcEng infodba account and all it's schema objects.

prompt Dropping the infodba account and all it's schema objects.
drop user infodba cascade;
PURGE RECYCLEBIN;
