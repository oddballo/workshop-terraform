# Demo

This project packages and uploads to an AWS bucket a simple Python based 
"Hello World" application.

This is to be used as a demo application for the Terraform workshop.

## Building

### Requirements

- AWS
- zip
- configured credentials

### Build Task

```
PROFILE='odavies' ./build.sh
```
Where 'odavies' should be substituted with your profile.
Optionally, ENVIRONMENT can be set to deploy elsewhere. Default is "development".
