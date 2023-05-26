use role ACCOUNTADMIN;

create or replace STORAGE INTEGRATION s3_int_cloudtrail_logs
  TYPE = EXTERNAL_STAGE
  STORAGE_PROVIDER = S3
  ENABLED = TRUE
  STORAGE_AWS_ROLE_ARN = 'arn:aws:iam::<AWS_ACCOUNT>:role/security12-role'
  STORAGE_ALLOWED_LOCATIONS = ('s3://security12-bucket/');

GRANT USAGE ON INTEGRATION s3_int_cloudtrail_logs TO ROLE SYSADMIN;
DESC INTEGRATION s3_int_cloudtrail_logs;


CREATE OR REPLACE PROCEDURE create_cloudtrail_s3_storage_integration()
  RETURNS TEXT
  LANGUAGE SQL
  EXECUTE AS CALLER
AS
DECLARE
  cmd TEXT;
BEGIN
  cmd := $$ 
    CREATE OR REPLACE STORAGE INTEGRATION s3_int_cloudtrail_logs
      TYPE = EXTERNAL_STAGE
      STORAGE_PROVIDER = S3
      ENABLED = TRUE
      STORAGE_AWS_ROLE_ARN = 'arn:aws:iam::123:role/security12-role'
      STORAGE_ALLOWED_LOCATIONS = ('s3://security12-bucket/');
  $$;
  EXECUTE IMMEDIATE cmd;
  RETURN 'Success';
END;


CREATE OR REPLACE PROCEDURE create_cloudtrail_s3_storage_integration()
  RETURNS VARIANT
  LANGUAGE JAVASCRIPT
  EXECUTE AS CALLER
AS
$$
  var return_value = '';
  try {
    var aws_account = '222'
    var project = 'security12'
    var cmd = `
        CREATE OR REPLACE STORAGE INTEGRATION s3_int_cloudtrail_logs
          TYPE = EXTERNAL_STAGE
          STORAGE_PROVIDER = S3
          ENABLED = TRUE
          STORAGE_AWS_ROLE_ARN = 'arn:aws:iam::${aws_account}:role/${project}-role'
          STORAGE_ALLOWED_LOCATIONS = ('s3://${project}-bucket/');
    `;
    var statement1 = snowflake.createStatement( {sqlText: cmd});
    var result = statement1.execute();
    return 'success';
  } catch(err) {
    return {
      "message": err.message,
      "statement": statement1.getSqlText()
    }
  }
  return return_value;
$$;

CREATE OR REPLACE PROCEDURE create_cloudtrail_s3_storage_integration(
  PROJECT VARCHAR
)
  RETURNS VARIANT
  LANGUAGE JAVASCRIPT
  EXECUTE AS CALLER
AS
$$
  var return_value = '';
  try {
    var aws_account = '222'
    var cmd = `
        CREATE OR REPLACE STORAGE INTEGRATION s3_int_cloudtrail_logs
          TYPE = EXTERNAL_STAGE
          STORAGE_PROVIDER = S3
          ENABLED = TRUE
          STORAGE_AWS_ROLE_ARN = 'arn:aws:iam::${aws_account}:role/${project}-role'
          STORAGE_ALLOWED_LOCATIONS = ('s3://${PROJECT}-bucket/');
    `;
    var statement1 = snowflake.createStatement( {sqlText: cmd});
    var result = statement1.execute();
    return 'success';
  } catch(err) {
    return {
      "message": err.message,
      "statement": statement1.getSqlText()
    }
  }
  return return_value;
$$;


--sample call of the procedure
  CALL create_cloudtrail_s3_storage_integration();

DESC INTEGRATION s3_int_cloudtrail_logs;
