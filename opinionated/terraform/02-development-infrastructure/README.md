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
- Configured AWS credentials (~/.aws/credentials)
- jq

#### Configuring AWS credentials
In `~/.aws/credentials` access credentials need to be added in the following form:

```
[default]
aws_access_key_id=XXXXXXXX
aws_secret_key_id=XXXXXXXX
```
To retrieve theses values access the UI, click on your user in the top right, then `Security Credentials`. Scroll down to `Create Access Key`, then populate the configuration file. 

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

### Apply (Tools Bucket only)

Because this project uses the tools S3 bucket to deploy Lambdas, the first step is to only 
provision the bucket. Following a successful deploy, the appropriate lambas can be built using
the build scripts in their repository.

```
./apply.sh -target aws_s3_bucket.tools
```
#### Override with global bucket

If you need not care for the bucket and it's contents, the tools bucket can be overriden to
point at the main bucket as an alternative. Instead of running the command special apply 
above, run the following;

```
# Replace "odavies" with your profile
echo "bucket_tools = \"workshop-development-main-tools\"" | tee -a "environments/development.odavies.tfvars"
```

### Apply (All)

With your ducks all in a row (bucket is available and populated), you can now finish the 
infrastructure deploy.

```
./apply.sh
```
### Destroy

The following will destroy all of the resource we've created in this subproject.

It's recommended that you perform this task regularly (i.e. when you've finished or
switched tasks) to reduce the monthly bill.

```
./destroy.sh
```

The tools buckets needs to be expunged before the bucket can be successfully destroyed. See "delete-dynamic.sh".

### Switching environment/profile

Re-run the initialize script with the reconfigure flag.

```
ENVIRONMENT=development PROFILE=odavies ./initialize.sh -reconfigure
```

### Deploying only what I need for my component

Like the tools bucket apply, you can use the resource name as part of the "target" configuration on terraform
to restrict the deployment to plan and apply only what is necessary.

```
# Example
./apply.sh -target aws_s3_bucket.tools
```

