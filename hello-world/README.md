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
- For SSO, using `aws configure sso --profile development` (NOTE: provide an empty Session Name when prompted to enable the necessary legacy support for Terraform to work)

In each case, follow the instructions.

Once completed, use `export AWS_PROFILE='development'` to set the environment variable for future session commands.

# Step 3 : Configure the Terraform
The following script will generate the configuration file you will use for the Terraform, including;

- prompting for the name of the Permissions Boundary policy,
- generating a (likely) unique profile prefix (to prevent namespace clashes), and
- fetching and setting the AWS account ID.

```
./configure.sh
```

# Step 4 : Initialize Terraform

```
terraform init
```

# Step 5 : Apply Terraform

```
terraform apply -var-file="config.tfvars"
```

# Step 6 : Run the lamba function

```
aws lambda invoke \
    --region eu-west-1 \
    --function-name demo-development-demo \
    --cli-binary-format raw-in-base64-out \
    --payload '{ "doesnt": "matter" }' \
    response.json

cat response.json
```
# Step 7 : Tear down Terraform

```
terraform destroy -var-file="config.tfvars"
```
