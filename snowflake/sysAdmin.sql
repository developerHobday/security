create warehouse security_quickstart with 
  WAREHOUSE_SIZE = MEDIUM 
  AUTO_SUSPEND = 60;


create stage cloudtrail_logs_staging
  url = 's3://security12-bucket/'
  storage_integration = s3_int_cloudtrail_logs
;
desc stage cloudtrail_logs_staging;

list @cloudtrail_logs_staging;