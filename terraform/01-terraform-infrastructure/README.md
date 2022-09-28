# Terraform - Terraform Infrastructure

This subproject deploys the infrastructure required to support;

- Remote state files backed by S3
- State locking backed by DynamoDB

This subproject is a precursor to any further Terraform deployments
for the workshop.

WARNING: Do not run this project (i.e. apply / destroy) without 
understanding the wider impacts of your actions.

## Configurations

"Environment" are configured via files in the "environments" folder.

A backend configuration (used by terraform init) and an environment 
configuration (used by terraform plan / apply) need to exist for each
environment. See the environments folder for an example.

There are no "Profiles" in this subproject as this infrastructure is
shared across the environment.

## Initialization

```
ENVIRONMENT=development ./initialize.sh
```

## Apply
```
./apply.sh
```

## Destroy
```
./destroy.sh
```

## Quirks

### Locking disabled

Becuase this infrastrucutre is responsible for locking, there is no 
locking infrastructure in place for locking during this deployment.

### Bucket created via AWS S3 CLI

The Bucket used for storing the state file is defined ahead of time
using the AWS S3 CLI in the initalization file.
