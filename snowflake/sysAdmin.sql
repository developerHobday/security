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

create view cloudtrail as
select 
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
  from public.cloudtrail_raw , LATERAL FLATTEN(input => record:Records);