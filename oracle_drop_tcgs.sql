REM @<COPYRIGHT>@
REM ==================================================
REM Copyright 2009.
REM Siemens Product Lifecycle Management Software Inc.
REM All Rights Reserved.
REM ==================================================
REM @<COPYRIGHT>@
REM
REM UGS PLM
REM
REM File: delete_gl.sql
REM
REM ****************************************************************************
REM Revision    History:
REM Date        Author         Comment
REM =========   ======         =================================================
REM 06-Jan-06   Shahji Dhole    Initial.
REM 21-Mar-07   Jonas Carlsson  Added gs_logs.
REM
REM ****************************************************************************

REM This script drops the Teamcenter Global Services tables.

prompt Dropping Global Services tables.  ALWAYS BACK UP DATA!!!
drop table gs_runtime_resources purge;
drop table gs_reactor_result purge;
drop table gs_message_log purge;
drop table gs_activity_status purge;
drop table gs_abort_request purge;
drop table gs_logs purge;
drop view gs_audit_log_view;
drop table gs_attribute purge;
drop sequence gs_attribute_seq;
drop table gs_data_object purge;
drop sequence gs_data_object_seq;
drop TABLE ODE_ACTIVITY_RECOVERY cascade constraints purge;
drop TABLE ODE_CORRELATION_SET cascade constraints purge;
drop TABLE ODE_CORRELATOR cascade constraints purge;
drop TABLE ODE_CORSET_PROP cascade constraints purge;
drop TABLE ODE_EVENT cascade constraints purge;
drop TABLE ODE_FAULT cascade constraints purge;
drop TABLE ODE_MESSAGE  cascade constraints purge;
drop TABLE ODE_MESSAGE_EXCHANGE cascade constraints purge;
drop TABLE ODE_MESSAGE_ROUTE cascade constraints purge;
drop TABLE ODE_MEX_PROP cascade constraints purge;
drop TABLE ODE_PARTNER_LINK cascade constraints purge;
drop TABLE ODE_PROCESS cascade constraints purge;
drop TABLE ODE_PROCESS_INSTANCE cascade constraints purge;
drop TABLE ODE_SCOPE cascade constraints purge;
drop TABLE ODE_XML_DATA cascade constraints purge;
drop TABLE ODE_XML_DATA_PROP cascade constraints purge;
drop TABLE OPENJPA_SEQUENCE_TABLE cascade constraints purge;
drop TABLE STORE_DU cascade constraints purge;
drop TABLE STORE_PROCESS cascade constraints purge;
drop TABLE STORE_PROCESS_PROP cascade constraints purge;
drop TABLE STORE_PROC_TO_PROP cascade constraints purge;
drop TABLE STORE_VERSIONS cascade constraints purge;
drop TABLE ODE_JOB cascade constraints purge;
drop TABLE ODE_SCHEMA_VERSION cascade constraints purge;
drop table BPEL_ACTIVITY_RECOVERY cascade constraints purge ;
drop table BPEL_CORRELATION_PROP cascade constraints purge ;
drop table BPEL_CORRELATION_SET cascade constraints purge ;
drop table BPEL_CORRELATOR cascade constraints purge ;
drop table BPEL_CORRELATOR_MESSAGE_CKEY cascade constraints purge ;
drop table BPEL_EVENT cascade constraints purge ;
drop table BPEL_FAULT cascade constraints purge ;
drop table BPEL_INSTANCE cascade constraints purge ;
drop table BPEL_MESSAGE cascade constraints purge ;
drop table BPEL_MESSAGE_EXCHANGE cascade constraints purge ;
drop table BPEL_MEX_PROPS cascade constraints purge ;
drop table BPEL_PLINK_VAL cascade constraints purge ;
drop table BPEL_PROCESS cascade constraints purge ;
drop table BPEL_SCOPE cascade constraints purge ;
drop table BPEL_SELECTORS cascade constraints purge ;
drop table BPEL_UNMATCHED cascade constraints purge ;
drop table BPEL_XML_DATA cascade constraints purge ;
drop table VAR_PROPERTY cascade constraints purge ;
drop sequence hibernate_sequence;
drop sequence HIBERNATE_SEQHILO;

REM Uncomment this line if dropping tables that were upgraded from Teamcenter 8.1.x - tc8.3.0.0.
REM Drop this table only if you are sure you want to destroy backed up data.
REM -- drop table ode_job_bak cascade constraints purge;  