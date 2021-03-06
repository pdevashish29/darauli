--------------------------------------------------------
--  File created - Monday-August-01-2016   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Table TIMESHEET1
--------------------------------------------------------

  CREATE TABLE "TIMESHEET1" 
   (	"EMPLOYEE_ID" NUMBER, 
	"TASK_START_DATE" DATE, 
	"TASK_END_DATE" DATE, 
	"HOURS_WORKED" NUMBER
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS" ;
REM INSERTING into TIMESHEET1
SET DEFINE OFF;
Insert into TIMESHEET1 (EMPLOYEE_ID,TASK_START_DATE,TASK_END_DATE,HOURS_WORKED) values (1,to_date('31-MAR-12','DD-MON-RR'),to_date('31-MAR-12','DD-MON-RR'),6);
Insert into TIMESHEET1 (EMPLOYEE_ID,TASK_START_DATE,TASK_END_DATE,HOURS_WORKED) values (1,to_date('01-APR-12','DD-MON-RR'),to_date('01-APR-12','DD-MON-RR'),5);
Insert into TIMESHEET1 (EMPLOYEE_ID,TASK_START_DATE,TASK_END_DATE,HOURS_WORKED) values (1,to_date('02-APR-12','DD-MON-RR'),to_date('02-APR-12','DD-MON-RR'),4);
Insert into TIMESHEET1 (EMPLOYEE_ID,TASK_START_DATE,TASK_END_DATE,HOURS_WORKED) values (1,to_date('03-APR-12','DD-MON-RR'),to_date('03-APR-12','DD-MON-RR'),2);
Insert into TIMESHEET1 (EMPLOYEE_ID,TASK_START_DATE,TASK_END_DATE,HOURS_WORKED) values (1,to_date('04-APR-12','DD-MON-RR'),to_date('04-APR-12','DD-MON-RR'),1);
Insert into TIMESHEET1 (EMPLOYEE_ID,TASK_START_DATE,TASK_END_DATE,HOURS_WORKED) values (2,to_date('31-MAR-12','DD-MON-RR'),to_date('31-MAR-12','DD-MON-RR'),4);
Insert into TIMESHEET1 (EMPLOYEE_ID,TASK_START_DATE,TASK_END_DATE,HOURS_WORKED) values (2,to_date('01-APR-12','DD-MON-RR'),to_date('01-APR-12','DD-MON-RR'),2);
Insert into TIMESHEET1 (EMPLOYEE_ID,TASK_START_DATE,TASK_END_DATE,HOURS_WORKED) values (2,to_date('02-APR-16','DD-MON-RR'),to_date('02-APR-12','DD-MON-RR'),1);
Insert into TIMESHEET1 (EMPLOYEE_ID,TASK_START_DATE,TASK_END_DATE,HOURS_WORKED) values (2,to_date('03-APR-16','DD-MON-RR'),to_date('03-APR-12','DD-MON-RR'),1);
Insert into TIMESHEET1 (EMPLOYEE_ID,TASK_START_DATE,TASK_END_DATE,HOURS_WORKED) values (2,to_date('04-APR-16','DD-MON-RR'),to_date('04-APR-12','DD-MON-RR'),5);
Insert into TIMESHEET1 (EMPLOYEE_ID,TASK_START_DATE,TASK_END_DATE,HOURS_WORKED) values (2,to_date('05-APR-16','DD-MON-RR'),to_date('05-APR-12','DD-MON-RR'),17);
