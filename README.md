# Python API application

## Introduction
This repository contains an example project to host a python based API application which will be deployed to Amazon ECS. 

## Description
The entire project directory is divided into two sections: **app** and **container**.

**app** folder contains python based application and its docker image.
> The application is built over Flask web framework.
> It contains two basic apis for introduction and version which can be extended in future.

The application is dockerized and moved to docker hub(achidoc/python-flask-api). To make any enhancements to the image or to use a separate docker id, please run the image generation scrip(./app/createimage.sh).

**container** folder contains infrastructure as code. This has been written in HCL to support Terraform. Please check the configs folder for the inputs to the script. Run `bash ./deployinfra.sh` from within container folder to deploy the infrastructure.

## Pre-requisites
### Platform
> Any machine with Linux installed will be preferable.

### Packages
- > docker (required for image generation)
- > terraform (required for infrastructure deployment)

### Credentials
> AWS: We have used AWS connection parameters as environment variables. Please declare as below:
```
export AWS_ACCESS_KEY_ID={your_key_here}
export AWS_SECRET_ACCESS_KEY={your_key_secret_here}
export AWS_DEFAULT_REGION={your_default_region_here}
```
> Docker hub: Please provide your docker hub credentials during image generation(optional).

## Install instruction
### Generation of image(optional):
You may generate the image and upload the image to your own docker repository. Run following command from root folder:
```
cd app
bash ./createimage.sh
```
### Infrastructure deployment:
- > Please verify the variables mentioned under /templates/configs.tf and make changes if required.
- > Ensure the pre-requisites are met.
- > Run following command from root folder to deploy the infrastructure
```
cd container
bash ./deployinfra.sh
```
## Test instruction
Once the installation is completed:
- Collect the application load balancer DNS name(A record) and browse the url.

- Also call */version* api using the same url and verify the response.

## Production additions
This implementation is an example for test platform. To implement the solution into production, several improvements/addtions need to be made:
1. Network firewalls and route tables need to be configured with security best practices.
2. Cross-region deployment can be done for high availability.
3. Proper capacity planning need to be done for CPU and memory utilization of the container in production.
4. Private repositories should be used to store the image.
5. ALB listener based on HTTPS need to be configured.
6. AWS secrets need to be periodically generated and used via vault.
7. Any other changes specific to environment

## CONTRIBUTING
Please provide your suggestion and thoughts for further improvements of the project. Please connect with me for questions.