# Terraform : Everything else

This subproject represents the "Infrastructure as Code" to support the workshop.

Note: this project makes uses of wrapper scripts and an opinionated environment configuration setup.
It's highly advised that you follow the instructions below. Before running any commands besides the
ones documented, please ensure you understand the consequences.

## Preamble : 01-terraform-infrastructure is required

This subproject relies on "01-terraform-infrastructure" having been successfully applied 
to the target environment. This dependency provides the Bucket required for state storage, and 
the DynamoDB table used for state locking

## How to use

For Development, it's recommended that you have a user specific "profile" instead of sharing
the provided "main" one.

### Prerequisites 

The following needs to be configured;

- Bash
- AWS CLI version 2
- Terraform (version 15 or greater)
- Configured AWS credentials (via AWS\_PROFILE or other methods)
- jq

### Generating a profile

```
./generateProfile.sh
```
When prompted, provide a unique profile name e.g. odavies. The main profile for "tfvars" and 
"backend configuration" will be duplicated with the appropriate values substituted. Commiting
these profile specific files in the "environment" folder is perfectly sane (and will form part
of future automated deployments).

### Initializing

With the profile generated, run the initilization tool.

```
# Where "PROFILE" is set to your profile.
PROFILE=odavies ./initialize.sh
```

This step configures;

- the backend configuration
- the "current" profile and environment (reused by apply and delete)

### Apply

```
./apply.sh
```
### Destroy

```
./destroy.sh
```

The tools buckets needs to be expunged before the bucket can be successfully destroyed. See "delete-dynamic.sh".

### Switching environment/profile

Re-run the initialize script with the reconfigure flag.

```
ENVIRONMENT=development PROFILE=odavies ./initialize.sh -reconfigure
```
