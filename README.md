**Project Name**
Terraform CI/CD Pipeline with GitLab for AWS

**Description**
In this DevOps project, you will see how to set up a CI/CD pipeline using GitLab to automatically deploy infrastructure on AWS cloud using Terraform. The project will cover the end-to-end process of infrastructure as code (IaC) deployment, including validation, planning, application, and destruction of resources. This project have a robust and automated pipeline that ensures consistent and reliable infrastructure deployment.

**Project Architecture**

- > The project consists of a GitLab repository that contains Terraform configuration files.
- > A GitLab CI/CD pipeline is configured to manage the deployment process.
- > The pipeline stages include validation, planning, applying, and destroying infrastructure.
- > The infrastructure is deployed on AWS, utilizing services such as EC2, S3, and VPC.
- > The pipeline is triggered on code changes, ensuring continuous deployment.



**Technologies Used**

- Infrastructure as Code (IaC): Terraform
- Version Control: GitLab
- CI/CD: GitLab CI/CD
- Cloud Provider: AWS
- Containerization: Docker (for the GitLab AWS runner image)
- CI/CD Pipeline


**Pipeline Configuration**
The CI/CD pipeline is configured in the .gitlab-ci.yml file and consists of the following stages:


```
image:
    name: registry.gitlab.com/gitlab-org/gitlab-build-images:terraform
    entrypoint:
        - '/usr/bin/env'
        - 'PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin'
variables:
    
  AWS_ACCESS_KEY_ID: $MY_AWS_ACCESS_KEY
  AWS_SECRET_ACCESS_KEY: $MY_SECRET_KEY
  AWS_DEFAULT_REGION: "us-east-1"

before_script:
    -  terraform --version
    -  terraform init
stages:
    - validate
    - plan
    - apply 
    - destroy

validate:
    stage: validate
    script:
        - terraform validate

plan:
    stage: plan
    dependencies:
        - validate
    script: 
        - terraform plan -out="planfile"
    artifacts:
        paths:
          - planfile

apply:
    stage: apply
    dependencies:
        - plan
    script:
        - terraform apply -input=false planfile

destroy:
    stage: destroy
    script: 
        - terraform destroy --auto-approve

    when: manual

```

**Stage Descriptions:**

Validate: Ensures that the Terraform configuration files are syntactically correct using terraform validate. 

Plan: Creates an execution plan with terraform plan -out=planfile, outlining the changes Terraform will make to the infrastructure. The artifact of the plan stage will be saved in the planfile  that will be used in the apply stage. Dependencies is used so that the plan job runs only if the validate job is successful

Apply: Applies the changes required to reach the desired state of the configuration with terraform apply "planfile".Dependencies parameter is used so that the apply job only runs once the plan job is successful. And it will be run manually.

Destroy: Destroys the infrastructure managed by Terraform using terraform destroy -auto-approve. And it will be run manually.

**Repository Structure**

```
cicdTF/
│
├── backend.tf                  # Configuration for S3 backend and state locking
├── main.tf                     # Main configuration file calling the modules
├── provider.tf                 # AWS provider initialization for us-east-1 region
├── variables.tf                # Variables for the main configuration
├── outputs.tf                  # Outputs for the main configuration
│
├── modules/
│   ├── ec2/
│   │   ├── main.tf             # EC2 resource configuration
│   │   ├── variables.tf        # Input variables for EC2 module
│   │   ├── outputs.tf          # Output variables for EC2 module
│   │
│   ├── vpc/
│       ├── main.tf             # VPC, subnet, and security group configuration
│       ├── variables.tf        # Input variables for VPC module
│       ├── outputs.tf          # Output variables for VPC module
│
└── README.md                   # Documentation for the repository
```
**backend.tf:** Configures a shared S3 backend to store the Terraform state file and enables state locking with a DynamoDB table.
**main.tf:** The main configuration file that calls the vpc and ec2 modules and passes necessary inputs and outputs between them.
**provider.tf: **Initializes the AWS provider in the us-east-1 region.
**variables.tf:** Defines the input variables for the main configuration.
**outputs.tf:** Specifies the outputs for the main configuration.
**Modules:**

**ec2/:**
_main.tf:_ Contains the resource block for creating EC2 instances.
_variables.tf:_ Defines input variables required by the EC2 module.
_outputs.tf:_ Specifies the outputs of the EC2 module.
**vpc/:**
_main.tf:_ Contains the resource blocks for creating VPC, subnets, and security groups.
_variables.tf:_ Defines input variables required by the VPC module.
_outputs.tf:_ Specifies the outputs of the VPC module, such as subnet IDs and security group IDs, which are used as inputs for the EC2 module.

**Prerequisites**:

- GitLab account
- AWS account with appropriate permissions
- Terraform installed locally for testing

**Installation Steps:**

- Clone the repository to your local machine.
- Configure AWS credentials in GitLab CI/CD variables.
- Customize the Terraform configuration files in the main directory as needed.

**Configuration:**

Ensure the .gitlab-ci.yml file is configured correctly with your AWS credentials and desired Terraform actions.

**Deployment**:

**Pipeline Execution:**

- Push changes to the GitLab repository to trigger the CI/CD pipeline.
- The pipeline will automatically run the validation, plan. The apply, and destroy stages will be required to run manually.
- Monitor the pipeline progress in the GitLab CI/CD interface.


**Manual Steps:**

- Review and approve the plan stage output if needed.
- Apply additional configurations or manual steps as required by your specific use case.


**Usage**:

**Deploy Infrastructure:**

- Make changes to the Terraform configuration files.
- Commit and push the changes to the GitLab repository.
- The CI/CD pipeline will automatically validate, plan, and the apply the changes manually.


**Destroy Infrastructure:**

To destroy the infrastructure, trigger the destroy stage manually from the GitLab CI/CD interface or by pushing a commit that includes the necessary changes.