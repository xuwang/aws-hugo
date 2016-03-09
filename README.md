
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
    $ curl -L -O https://dl.bintray.com/mitchellh/terraform/terraform_0.6.0_darwin_amd64.zip
    $ unzip terraform_0.6.0_darwin_amd64.zip
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

First, edit `terraforms/provider.tf` to set up aws credentials and other necessary parameters for your hugo site.

And apply terraforms:

```
$ cd terraforms
$ terraform get
$ terraform apply
...
```
