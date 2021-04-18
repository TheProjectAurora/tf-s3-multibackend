# Terraform S3 backend for multiple accounts

**Note** To get this working you have to have account alias at every AWS account where you plan
to use this. The account alias is set from the IAM panel or with the command:
`aws iam create-account-alias --account-alias <alias>`. 

The account alias is part of safety and security of your AWS environments. The users can remember
them better than random number. They can give visual cues where you are currently.

## Usage

This expects that the user has logged in. In case of multi account and MFA usge `awsume` is
superb tool for the authentication.

```
    tf-s3-backend [<user key>]
```

The `user key` is `default` by the default. If this causes the problems in my own tests, I'll 
remove the default value and replace it with something more unique.

The key at S3 bucket is the format:
`tf/<region>/<account alias>/<project name>/<user key>`

The `project name` is the name of the current directory or the content of the file 
`tf-workspace-name` if the file exists. 

### Environment variables

Environment variables are defining what extension is used for the S3 bucket. 

* `TF_S3_BACKEND_SECRET_KEY`
* `TF_S3_BACKEND_SECRET_KEY_<encoded account alias>`

Encoded account alias is the account alias which has only characters A-Z, a-z and 0-9. All other
are removed. E.g. `ncltd-test-environment` results `TF_S3_BACKEND_SECRET_KEY_ncltdtestenvironment`

### Terraform things

The directory must contain the Terraform file for the backend. I'm using `backend.tf` for that.
The content of it is following:

```backend.tf
    terraform {
        backend "s3" {
        }
    }
```

## Security

I've seen some multi account strategies for the state management. The biggest weakness at most
of them is security (and safety). E.g. single S3 bucket for all accounts doesn't allow limiting
the visibility of enviroments. 

* Safety side security - it's difficult to mess up the wrong environment. Only weak spot is 
  "user key". At production use non-default just in case.
* Own S3 bucket for each environment -> The principle of least privilege is implemented. E.g.
  if devs are not allowed to do anything at production, then they don't need to know about the
  states and content of the production.
* "Secret key" for the bucket name -> It's a bit more difficult to hijack your S3 bucket. And as
  each account alias can have own "secret key", the risk is reduced even more.