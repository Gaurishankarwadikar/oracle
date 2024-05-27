REM EDS PLM
REM
REM File: tc_unpopulate_db.sql
REM
REM ****************************************************************************
REM Revision    History:
REM Date        Author         Comment
REM =========   ======         =================================================
REM 12-Mar-03   Van Nguyen     Initial.
REM
REM ****************************************************************************

REM This script:
REM 1) drops the existing Tc infodba schema.
REM 2) recreates the Tc infodba user and it's logging tables/indexes.

spool tc_unpopulate_db.lst

prompt
prompt You must be connected as SYSDBA before running this script.
prompt
prompt You are about to unpopulate Tc data from this ORACLE_SID:
select instance_name from v$instance;
accept value prompt 'Press "Enter" to continue or Press "Control/c" to abort.'
prompt

@@delete_user.sql

@@create_user.sql

spool off

