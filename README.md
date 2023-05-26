# Introduction
Compliance, governance and audit of AWS Cloud resources is essential.  Actions taken by a user, role, or an AWS service are recorded as events in CloudTrail. Events include actions taken in the AWS Management Console, AWS Command Line Interface, and AWS SDKs and APIs.   By ingesting and analyzing CloudTrail logs in Snowflake, we are able to gain analytical insights and work toward securing environments at scale.  

This repository provides a quickstart for configuring an automated ingestion and processing pipeline in Snowflake for CloudTrail logs, as well as example queries for analytics, threat detection and posture management.  Snowflake tables can also be securely exposed to downstream BI tools like Tableau, PowerBI and Metabase.

# Pre-requisites
1. Working AWS account, with AWS CLI configured.
2. Logged into Snowflake account, with AccountAdmin role.
3. Terraform installed.

# Steps
1. Copy `terraform/terraform.tfvars.template` to `terraform/terraform.tfvars`, and fill in the *project, owner and AWS Account* variables.
2. Substitute the *project and AWS Account* variables into `snowflake/awsIntegration.sql` script.  Run it as *AccountAdmin*.
3. In `terraform` directory, run `terraform apply`.
4. Substitute the *project* variables into `snowflake/ddl.sql` script.  Run it as *SysAdmin*.
5. Get the *snowpipe* notification *SQS ARN*, update it to `terraform/terraform.tfvars`, and rerun `terraform apply`.

You can then run the security analytics queries, like in `snowflake/queries.sql`.
