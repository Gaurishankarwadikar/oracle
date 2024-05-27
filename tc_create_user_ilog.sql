REM EDS PLM
REM
REM File: tc_create_user_ilog.sql
REM
REM ****************************************************************************
REM Revision    History:
REM Date        Author         Comment
REM =========   ======         =================================================
REM 12-Mar-03   Van Nguyen     Initial.
REM
REM ****************************************************************************

REM This script:
REM 1) creates the Tc infodba user account
REM 2) creates the Tc infodba's logging tables/indexes

spool tc_create_user_ilog.lst

connect / as sysdba

REM create the Tc infodba account
@@create_user.sql

spool off

exit
