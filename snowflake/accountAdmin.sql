use role ACCOUNTADMIN;

create or replace STORAGE INTEGRATION s3_int_cloudtrail_logs
  TYPE = EXTERNAL_STAGE
  STORAGE_PROVIDER = S3
  ENABLED = TRUE
  STORAGE_AWS_ROLE_ARN = 'arn:aws:iam::<AWS_ACCOUNT>:role/security12-role'
  STORAGE_ALLOWED_LOCATIONS = ('s3://security12-bucket/');

GRANT USAGE ON INTEGRATION s3_int_cloudtrail_logs TO ROLE SYSADMIN;
DESC INTEGRATION s3_int_cloudtrail_logs;