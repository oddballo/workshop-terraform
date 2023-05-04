# Terraform - "hello-world"

This terraform is set out to explain the basics of terraform.

This is all vanilla Terraform with no wrappers, state locking, or environment configuration.

# Step 1 : Setup the environment

See the root [README.md](../README.md) for instructions on setting up the tooling and the 
authentication.

Don't forget to set the environment variable AWS\_PROFILE on each terminal login.

# Step 2 : Change directory

From the project root, change into this demonstration workshop folder.

```
cd "hello-world"
```

# Step 2 : Configure the Terraform
The following script will generate the configuration file you will use for the Terraform, including;

- prompting for the name of the Permissions Boundary policy,
- generating a (likely) unique profile prefix (to prevent namespace clashes), and
- fetching and setting the AWS account ID.

```
/bin/bash configure.sh
```

# Step 3 : Initialize Terraform

```
terraform init
```

# Step 4 : Apply Terraform

```
terraform apply -var-file="config.tfvars"
```

# Step 5 : Run the lamba function

```
aws lambda invoke \
    --region eu-west-1 \
    --function-name demo-development-demo \
    --cli-binary-format raw-in-base64-out \
    --payload '{ "doesnt": "matter" }' \
    response.json

cat response.json
```
# Step 6 : Tear down Terraform

```
terraform destroy -var-file="config.tfvars"
```
