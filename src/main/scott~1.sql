Select TRUNC(sysdate, 'IW')-1 FROM_DATE,
NEXT_DAY(TRUNC(sysdate,'IW'),'SATURDAY') TO_DATE
From dual;

WITH
  empworkhours AS
  (
    SELECT
    trunc(task_start_date,'IW')-1 as week_start,
  --  trunc(task_start_date,'IW') week_end,
    TRUNC(timesheet1.TASK_START_DATE,'IW')+6  as  week_end,
   employee_id ,
  hours_worked
    FROM timesheet1
  )
  
SELECT
           week_start,
           week_end,
          employee_id ,
  SUM(hours_worked) total_hrs_per_week
FROM 
  empworkhours
GROUP BY
week_start,
week_end,
employee_id;
