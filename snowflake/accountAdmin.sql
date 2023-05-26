create STORAGE INTEGRATION s3_int_cloudtrail_logs
  TYPE = EXTERNAL_STAGE
  STORAGE_PROVIDER = S3
  ENABLED = TRUE
  STORAGE_AWS_ROLE_ARN = 'arn:aws:iam::<AWS_ACCOUNT_NUMBER>:role/snowflake-cloudtrail'
  STORAGE_ALLOWED_LOCATIONS = ('s3://security12-bucket/');


DESC INTEGRATION s3_int_cloudtrail_logs;