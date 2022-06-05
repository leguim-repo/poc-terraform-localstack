<img src="readme/icon.png" align="right" />

# Awesome poc with Terraform, Localstack and AWS Project [![Awesome](readme/badge.svg)](https://github.com/sindresorhus/awesome#readme)

> Super short description noname project

Extended description of noname project

## Project Installation

### Terraform installation for MacOs

~~~bash
brew tap hashicorp/tap
brew install hashicorp/tap/terraform
~~~~

####  Terraform Offical help

<https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket>

### Create virtual environment

~~~bash
make venv
~~~

### Start virtual environment

~~~bash
source venv/bin/activate
~~~

### Install project dependencies

~~~bash
make all-dependencies
~~~

### Run Localstack container

~~~bash
docker-compose up -d
~~~

### Deploy Infrastructure to Localstack

~~~bash
make deploy-localstack
~~~

### Upload file to Localstack

~~~bash
make upload-unicorn
~~~

NI: No unicorn has been mistreated to carry out this project
---
<!-- Pit i Collons -->
![Coded In Barcelona](https://raw.githubusercontent.com/leguim-repo/leguim-repo/master/img/currentfooter.png)
