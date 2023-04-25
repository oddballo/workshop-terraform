# Terraform - "hello-world"

This terraform is set out to explain the basics of terraform.

This is all vanilla Terraform with no wrappers, state locking, or environment configuration.

# Step 1 : Tooling

You will need the following tools configured;

- AWS CLI
- Terraform CLI

Guides on how to set these up can be found online.

Alternatively, you can use an opionated [Virtual Machine environment](https://github.com/oddballo/virtualbox-demobox), with the tools configured, to get a head start.

# Step 2 : Configure cloud access

The command line needs to be configured with Access keys. This can be achieved in a number of different ways.

## Getting the credentials

If you are using a standalone account, use the [Security Credentials](https://us-east-1.console.aws.amazon.com/iamv2/home?region=us-east-1#/security_credentials) page to generate Access Keys.

Alternatively, if you are using the Single Sign On (SSO) / Organization page, choose "Command line or programmatic access" next to the account for configuration details.

## Configuring the credentials

There are a number of ways to setup the credentials, but the authors recommended is to configure a "profile".

- For standalone accounts (with long term key access), using `aws configure --profile development`
- For SSO, using `aws configure sso --profile development`

In each case, follow the instructions.

# Step 3 : Initialize Terraform

```
AWS_PROFILE=development terraform init
```

# Step 4 : Apply Terraform

Note: replace account ID with the AWS Account ID that you are deploying to.

```
AWS_PROFILE=development \
    TF_VAR_environment=development \
    TF_VAR_project=demo \
    TF_VAR_owner=jsmith \
    TF_VAR_region=eu-west-1 \
    TF_VAR_account_id=xxx \
    TF_VAR_name=world \
    terraform apply
```

# Step 5 : Run the lamba function

```
AWS_PROFILE=development aws lambda invoke \
    --region eu-west-1 \
    --function-name demo-development-demo \
    --cli-binary-format raw-in-base64-out \
    --payload '{ "doesnt": "matter" }' \
    response.json

cat response.json
```
# Step 6 : Tear down Terraform

Note: replace account ID with the AWS Account ID that you deployed to.

```
AWS_PROFILE=development \
    TF_VAR_environment=development \
    TF_VAR_project=demo \
    TF_VAR_owner=jsmith \
    TF_VAR_region=eu-west-1 \
    TF_VAR_account_id=xxx \
    TF_VAR_name=world \
    terraform destroy
```
