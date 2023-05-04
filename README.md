# Workshop : Terraform

This workshop is intended to support Terraform introductions presented by the author.

## Setup

### Tooling

Follow the instructions for [setting up a demobox](https://github.com/oddballo/virtualbox-demobox).

After successfully creating the demobox, setup Terraform and AWS by running the following command
from within the demobox codebase via Git bash.

```
./tool/copy-and-run.sh 2222 install/terraform.sh

```
### Accessing the command line

To access the command line, run the following command from within the demobox codebase via Git 
bash.

```
./tool/ssh.sh 2222

```

### Authentication

#### Using SSO

From within the demobox, run the following command.

```
aws configure sso --no-browser --profile sandbox

```

When prompted;
- Enter nothing (i.e., "") when configuring SSO session name and ignore the warning.
- Configure the SSO URL that you would typically use in the browser to sign in
- Configure the region as "eu-west-2"
- Login via the browser and provide the code presented
- Via the console, choose the account and role you wish to use
- Configure the default client region as "eu-west-2"
- Configure the output format as "json"

Example;
```
SSO session name (Recommended):
WARNING: Configuring using legacy format (e.g. without an SSO session).
Consider re-running "configure sso" command and providing a session name.
SSO start URL [None]: https://X-XXXXXXXXXX.awsapps.com/start
SSO region [None]: eu-west-2
Browser will not be automatically opened.
Please visit the following URL:

https://device.sso.eu-west-2.amazonaws.com/

Then enter the code:

XXXX-XXXX

Alternatively, you may visit the following URL which will autofill the code upon loading:
https://device.sso.eu-west-2.amazonaws.com/?user_code=XXXX-XXXX
There are X AWS accounts available to you.
Using the account ID XXXXXXXXXXXX
There are X roles available to you.
Using the role name "XXX"
CLI default client Region [None]: eu-west-2
CLI default output format [None]: json
```

Once successfully completed, run the following to configure the AWS 
profile for the remainder of the terminal session. This will need to
be done each time you open a new terminal session.

```
export AWS_PROFILE=sandbox

```

### Clone project files

```
git clone https://github.com/oddballo/workshop-terraform.git
cd workshop-terraform

```

## Demonstration: hello-world

Follow the [README.md](hello-world/README.md) to go about setting up a simple Lambda in AWS.
