create warehouse security_quickstart with 
  WAREHOUSE_SIZE = MEDIUM 
  AUTO_SUSPEND = 60;


create stage cloudtrail_logs_staging
  url = 's3://security12-bucket/'
  storage_integration = s3_int_cloudtrail_logs
;
desc stage cloudtrail_logs_staging;

list @cloudtrail_logs_staging;


create table public.cloudtrail_raw(
  record VARIANT
);

copy into cloudtrail_raw FROM @cloudtrail_logs_staging FILE_FORMAT = (type = json);

create pipe public.cloudtrail_pipe auto_ingest=true as
copy into cloudtrail_raw 
FROM @cloudtrail_logs_staging  FILE_FORMAT = (type = json);

alter pipe cloudtrail_pipe refresh;
  select *
  from table(snowflake.information_schema.pipe_usage_history(
    date_range_start=>dateadd('hour',-1,current_timestamp()),
    date_range_end=>current_timestamp(),
    pipe_name=>'public.cloudtrail_pipe'
  ));

