
# Create Hugo static website generator on AWS Lambda with Terraform

This project demonstrates how to use [Terraform](https://www.terraform.io/intro/index.html) to manage AWS resources needed to create Hugo static website using AWS Lambda service. 
Resources managed are:

* Source, destination and log buckets on AWS, bucket policies, static websites configuration
* Lambda function, IAM role and policies
* Lambda S3 trigger

This tutorial uses content and ideas from a number of open source projects. See [Acknowledgements](#Acknowledgements) for details.

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
Install S3 event trigger - workaround until Terraform support this:

```
$ ./set-s3-trigger.sh
```

### To test

* Upload hugo page content to the input bucket
* Go to AWS Lambda console to run "Configure & Test"

### To destroy

```
$ cd terraform
$ ./delete-s3-trigger.sh
$ terraform destroy
```

## <a name="Acknowledgement">Acknowledgements</a>
* [hugo-aws-lambda-static-website](http://bezdelev.com/post/hugo-aws-lambda-static-website/)
* [Terraform](http://www.terraform.io/downloads.html)
* [Hugo](gohugo.io)

