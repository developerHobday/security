use role ACCOUNTADMIN;

CREATE OR REPLACE PROCEDURE create_cloudtrail_s3_storage_integration(
  PROJECT VARCHAR,
  AWS_ACCOUNT VARCHAR
)
  RETURNS VARIANT
  LANGUAGE JAVASCRIPT
  EXECUTE AS CALLER
AS
$$
  try {
    let cmd = `
        CREATE OR REPLACE STORAGE INTEGRATION cloudtrail_s3_int
          TYPE = EXTERNAL_STAGE
          STORAGE_PROVIDER = S3
          ENABLED = TRUE
          STORAGE_AWS_ROLE_ARN = 'arn:aws:iam::${AWS_ACCOUNT}:role/${PROJECT}-role'
          STORAGE_ALLOWED_LOCATIONS = ('s3://${PROJECT}-bucket/');
    `;
    let statement1 = snowflake.createStatement( {sqlText: cmd});
    statement1.execute();

    cmd = `
        GRANT USAGE ON INTEGRATION cloudtrail_s3_int TO ROLE SYSADMIN;
    `;
    statement1 = snowflake.createStatement( {sqlText: cmd});
    statement1.execute();
    
    return 'success';
  } catch(err) {
    return {
      "message": err.message,
      "statement": statement1.getSqlText()
    }
  }
$$;

CALL create_cloudtrail_s3_storage_integration('project4', '738');

DESC INTEGRATION cloudtrail_s3_int;
