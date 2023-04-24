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

Alternatively, if you are using the Single Sign On (SSO) / Organization page, choose "Command line or programmatic access" next to the account, or alternatively the command line will prompt you.

## Configuring the credentials

There are a number of ways to setup the credentials, but the authors recommended is;

- for standalone accounts (with long term key access), using `aws configure --profile \<PROFILE\_NAME\>`
- for SSO, using `aws configure sso`

In each case, follow the instructions.

# Step 3 : Initialize Terraform

```
terraform init
```

# Step 4 : Apply Terraform

```
terraform apply
```

# Step 5 : Tear down Terraform

```
teraform destroy
```
