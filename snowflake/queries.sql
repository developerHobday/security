-- Console Login events Without MFA
select * from cloudtrail where eventName = 'ConsoleLogin'
and responseElements:ConsoleLogin = 'Success' 
and additionalEventData:MFAUsed = 'No'
and additionalEventData:SamlProviderArn is null;

-- Unauthorized API calls
select * from cloudtrail where errorCode in ('AccessDenied', 'UnauthorizedOperation')
and sourceIPAddress != 'delivery.logs.amazonaws.com'
and eventName != 'HeadBucket';

-- Updated S3 Bucket Policies
select * from cloudtrail where eventName in (
'PutBucketAcl',
'PutBucketPolicy',
'PutBucketCors',
'PutBucketLifecycle',
'PutBucketReplication',
'DeleteBucketPolicy',
'DeleteBucketCors',
'DeleteBucketLifestyle',
'DeleteBucketReplication'
);

-- Audit Root account activity
select * from cloudtrail 
where userIdentity:type = 'Root' 
and eventType != 'AwsServiceEvent'
and userIdentity:invokedBy is null;

-- Updated Security Group Rules
select * from cloudtrail where eventName in (
'AuthorizeSecurityGroupEgress',
'AuthorizeSecurityGroupIngress',
'CreateSecurityGroup',
'DeleteSecurityGroup',
'RevokeSecurityGroupEgress',
'RevokeSecurityGroupIngress'
);