USE ROLE SYSADMIN;

CREATE OR REPLACE PROCEDURE create_cloudtrail_ddl(
  PROJECT VARCHAR
)
  RETURNS VARIANT
  LANGUAGE JAVASCRIPT
  EXECUTE AS CALLER
AS
$$
  try {
    const cmds = [`
        CREATE OR REPLACE SCHEMA aws_audit
    `, `
        CREATE OR REPLACE STAGE cloudtrail_logs_staging
            URL = 's3://${PROJECT}-bucket/'
            STORAGE_INTEGRATION = cloudtrail_s3_int
    `, `
        CREATE OR REPLACE TABLE cloudtrail_raw(
            record VARIANT
        )
    `, `
        CREATE PIPE cloudtrail_pipe 
            auto_ingest=true 
        AS
        COPY INTO cloudtrail_raw 
            FROM @cloudtrail_logs_staging 
            FILE_FORMAT = (type = json)
    `, `
        CREATE VIEW cloudtrail AS
        SELECT 
            VALUE:eventTime::TIMESTAMP as eventTime, 
            VALUE:eventVersion::string as eventVersion,
            VALUE:userIdentity::variant as userIdentity,
            VALUE:eventSource::string as eventSource,
            VALUE:eventName::string as eventName,
            VALUE:awsRegion::string as awsRegion,
            VALUE:sourceIPAddress::string as sourceIPAddress,
            VALUE:userAgent::string as userAgent,
            VALUE:errorCode::string as errorCode,
            VALUE:errorMessage::string as errorMessage,
            VALUE:requestParameters::variant as requestParameters,
            VALUE:responseElements::variant as responseElements,
            VALUE:additionalEventData::variant as additionalEventData,
            VALUE:requestID::string as requestID,
            VALUE:eventID::string as eventID,
            VALUE:eventType::string as eventType,
            VALUE:apiVersion::string as apiVersion,
            VALUE:managementEvent::variant as managementEvent,
            VALUE:resources::variant as resources,
            VALUE:recipientAccountId::string as recipientAccountId,
            VALUE:serviceEventDetails::variant as serviceEventDetails,
            VALUE:sharedEventID::string as sharedEventID,
            VALUE:eventCategory::string as eventCategory,
            VALUE:vpcEndpointId::string as vpcEndpointId,
            VALUE:addendum::string as addendum,
            VALUE:sessionCredentialFromConsole::string as sessionCredentialFromConsole,
            VALUE:edgeDeviceDetails::string as edgeDeviceDetails,
            VALUE:tlsDetails::variant as tlsDetails,
            VALUE:insightDetails::variant as insightDetails
        FROM cloudtrail_raw , LATERAL FLATTEN(input => record:Records);            
    `];
    for (const cmd of cmds) {
        const statement1 = snowflake.createStatement( {sqlText: cmd});
        statement1.execute();
    }

    return 'success';
  } catch(err) {
    return {
      "message": err.message,
      "statement": statement1? statement1.getSqlText() : 'null',
    }
  }
$$;

call create_cloudtrail_ddl('project4');

DESC PIPE cloudtrail_pipe;
