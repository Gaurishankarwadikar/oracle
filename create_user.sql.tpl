REM EDS PLM
REM
REM File: create_user.sql
REM
REM ****************************************************************************
REM Revision    History:
REM Date        Author         Comment
REM =========   ======         =================================================
REM 12-Mar-03   Van Nguyen     Initial.
REM 14-Jul-05   Van Nguyen     Remove dba privilege;only grant those required.
REM 11-Jan-06   Van Nguyen     Give infodba imp_full_database role.
REM
REM ****************************************************************************

REM This script creates the TcEng infodba account.
REM This script expects 2 existing tablespaces: "idata" and "temp".
 
prompt Creating infodba account and granting privileges.
grant Connect, Create table, Create tablespace, Create procedure, Create view, create sequence, Select_catalog_role, alter user, alter session, Create trigger to infodba identified by infodba;


prompt Setting default tablespaces for the infodba account.
alter user infodba default tablespace idata temporary tablespace temp;
ALTER USER "INFODBA" QUOTA UNLIMITED ON "IDATA" QUOTA UNLIMITED ON "ILOG" QUOTA UNLIMITED ON "INDX";

