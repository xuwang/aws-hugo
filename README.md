
# Create HUGO static web site on AWS with [Terraform](https://www.terraform.io/intro/index.html)

## Setup AWS credentials

Go to [AWS Console](https://console.aws.amazon.com/)

1. Create a group `myhugo` with `AdministratorAccess` policy.
2. Create a user `myhugo` and __Download__ the user credentials.
3. Add user `myhugo` to group `myhugo`.

## Install tools

If you use [Vagrant](https://www.vagrantup.com/), you can skip this section and go to 
[Quick Start](#quick-start) section.

Instructions for install tools on MacOS:

1. Install [Terraform](http://www.terraform.io/downloads.html)

    ```
    $ brew update
    $ brew install terraform
    ```
    or
    ```
    $ mkdir -p ~/bin/terraform
    $ cd ~/bin/terraform
    $
    $ curl -L -O https://releases.hashicorp.com/terraform/0.6.12/terraform_0.6.12_darwin_amd64.zip
    $ unzip terraform_0.6.12_darwin_amd64.zip
    ```

## Clone the repo:
```
$ git clone git@github.com:xuwang/aws-hugo
$ cd aws-hugo
```

#### Run Vagrant ubuntu box with terraform installed (Optional)
If you use Vagrant, instead of install tools on your host machine,
there is Vagranetfile for a Ubuntu box with all the necessary tools installed:
```
$ vagrant up
$ vagrant ssh
$ cd aws-hugo
```

#### To build:

First setup parameters for your site:

```
$ cd terraforms
$ cp provider.tf.tmpl provider.tf
```

edit `terraforms/provider.tf` to set up aws credentials and other necessary parameters for your hugo site.

And apply terraforms:

```
$ terraform get
$ terraform apply
...
```

### To test

* Upload hugo page content to the input bucket
* Go to AWS Lambda console to run "Configure & Test"

### To destroy

```
$ cd terraform
$ terraform destroy
```
Note: as of this writting, you will get the following errors:

```
* aws_iam_role.lambda_role: Error deleting IAM Role...: DeleteConflict: Cannot delete entity, must detach all policies first.
	status code: 409, request id: 71c5feea-e688-11e5-a9a8-958f1eb280a9
* aws_s3_bucket.log: Error deleting S3 Bucket: BucketNotEmpty: The bucket you tried to delete is not empty
	status code: 409, request id: 9F923D99C0985315
```
You should manaually detache lambda policy from hugo-lambda role and remove sub folders in hugo hugo-log bucket. Then re-run:

```
$ terraform destroy
```
