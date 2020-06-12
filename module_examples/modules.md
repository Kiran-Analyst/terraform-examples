The module is an independent block or container that builds a set of resources. It is like a black box component that accepts input parameters and exposes output parameters.

- Each Terraform code will have at least one module that is root. 
- A module can be called inside another module.
- The module can be from local source code or from the registry (Terraform registry or private registry).

### Structure of a Module:
- The module is the same as the normal terraform code.
- The module will have .tfvars and .tf files.
- It is recommended to have a simple module that responsible for creating a small number of resources which generally tied to each other.
- It supports all features of Terraform.


## Using Modules from the registry:
Each provider will provide several reusable modules that can be found in the Terraform Registry. In this section, we will explore Google Provider modules.  

### Module block structure:
```
    module "<arbitrary name of the module>"{
        source : <source of the module> #mandatory field
        version: 
        # other required input fields for the module
    }
```
- Module block starts with the keyword “Module”. The name can be any arbitrary name that helps to uniquely identify the block for further reference in the rest of the code.

- The source is a mandatory parameter for a module block that tells the terraform from where the module needs to be imported. terraform supports multiple sources. Below are some supported sources. Refer to the link for full list.

    - Local source 
    - Terraform Registry
    - Code repositories like Git, GitHub, Bitbucket, and others. 
    - Https URL 
    - Cloud storage buckets like S3, GCS, and others

- The version parameter is required to avoid conflicts and reliable response. Version supports strict and nonstrict variations like ==, >=, <= , and others.

**Example: Create a GCS bucket using a module from Registry.**

The Module Registry [link](https://registry.terraform.io/modules/terraform-google-modules/cloud-storage/google/1.6.0) provides module usage information along with input and output parameters. As per the module documentation, it requires 3 required parameters along with source and version.

Required fields:

- names: list of bucket names
- prefix: string type. This appends to the bucket name 
- project_id
```
module "cloud-storage" {
  source  = "terraform-google-modules/cloud-storage/google"
  version = "1.6.0"
  # insert the 3 required variables here
  names = [bucket1, bucket2]
  prefix = "test-kiran"
  project = <project id>
}
```
Note: Currently, we are facing a certificate issue while running the module from the repository on MAC Os


## Creating and using own Modules:
### Building source code:

1. Create a subdirectory for the module.
    ```
    $ ls -lt
    total 8
    drwxr-xr-x  5 ramreddy3  117863849  160 Jun 13 01:26 gcs-bucket
    ```
2. Create all the required terraform files.
    ```
    $ find gcs-bucket/
    gcs-bucket/
    gcs-bucket//outputs.tf
    gcs-bucket//main.tf
    gcs-bucket//variables.tf
    ```
    - main.tf
       
        ```
        resource "google_storage_bucket" "buckets" {
            for_each = var.names
            name          = "${var.prefix}${each.value}"
            project       = var.project_id
            location      = var.location
        }
        ```
    - variables.tf
        ```
        variable "names" {
            type = set(string)
            default = []
        }
        
        variable "project_id" {
            type = string
            default = ""
        }
        
        variable "prefix" {
            type = string
            default = ""
        }
        
        variable "location" {
            type = string
            default = "us-east1"
        }
        ```
    - outputs.tf
        ```
        output "bucket_name"{
            description = "bucket names"
            value = google_storage_bucket.buckets
        }
      ```
3. Create a main.tf file in the root directory to use test module 
```
provider "google" {
  version = "3.25.0"
  credentials = file("gcp_cred.json")
  project = "practiceproject-248407"
  region  = "us-central1"
  zone    = "us-central1-c"
}

module "cloud-storage" {
  source  = "./gcs-bucket"
  names = ["bucket1", "bucket2"]
  prefix = "test-kiran"
  project_id = "practiceproject-248407"
}
```
Note: Create a service account to access GCP components and save the file with name  gcp_cred.json file in the root directory

### Executing Terraform scripts:

- **Run terraform init command**. 
This step imports all the required plugins related to provides and required modules. The below output shows module initialization and plugin installation.
```
$ terraform init
Initializing modules...
- cloud-storage in gcs-bucket

Initializing the backend...

Initializing provider plugins...
- Checking for available provider plugins...
- Downloading plugin for provider "google" (hashicorp/google) 3.25.0...

Terraform has been successfully initialized!

You may now begin working with Terraform. Try running "terraform plan" to see
any changes that are required for your infrastructure. All Terraform commands
should now work.

If you ever set or change modules or backend configuration for Terraform,
rerun this command to reinitialize your working directory. If you forget, other
commands will detect it and remind you to do so if necessary.$ terraform init
Initializing modules...
- cloud-storage in gcs-bucket

Initializing the backend...

Initializing provider plugins...
- Checking for available provider plugins...
- Downloading plugin for provider "google" (hashicorp/google) 3.25.0...

Terraform has been successfully initialized!

You may now begin working with Terraform. Try running "terraform plan" to see
any changes that are required for your infrastructure. All Terraform commands
should now work.

If you ever set or change modules or backend configuration for Terraform,
rerun this command to reinitialize your working directory. If you forget, other
commands will detect it and remind you to do so if necessary.
```
- Create a plan -  Plan section provides the execution plan. The below plan shows, 2 new resources are going to be added and resource section shows bucket1 and bucke2 will be created.
```
$ terraform plan -out=plan.txt
Refreshing Terraform state in-memory prior to plan...
The refreshed state will be used to calculate this plan, but will not be
persisted to local or remote state storage.


------------------------------------------------------------------------

An execution plan has been generated and is shown below.
Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # module.cloud-storage.google_storage_bucket.buckets["bucket1"] will be created
  + resource "google_storage_bucket" "buckets" {
      + bucket_policy_only = (known after apply)
      + force_destroy      = false
      + id                 = (known after apply)
      + location           = "US-EAST1"
      + name               = "test-kiranbucket1"
      + project            = "practiceproject-248407"
      + self_link          = (known after apply)
      + storage_class      = "STANDARD"
      + url                = (known after apply)
    }

  # module.cloud-storage.google_storage_bucket.buckets["bucket2"] will be created
  + resource "google_storage_bucket" "buckets" {
      + bucket_policy_only = (known after apply)
      + force_destroy      = false
      + id                 = (known after apply)
      + location           = "US-EAST1"
      + name               = "test-kiranbucket2"
      + project            = "practiceproject-248407"
      + self_link          = (known after apply)
      + storage_class      = "STANDARD"
      + url                = (known after apply)
    }

Plan: 2 to add, 0 to change, 0 to destroy.

------------------------------------------------------------------------

This plan was saved to: plan.txt

To perform exactly these actions, run the following command to apply:
    terraform apply "plan.txt"
```
- Apply plan for resource creation
```
$ terraform apply -auto-approve plan.txt
module.cloud-storage.google_storage_bucket.buckets["bucket2"]: Creating...
module.cloud-storage.google_storage_bucket.buckets["bucket1"]: Creating...
module.cloud-storage.google_storage_bucket.buckets["bucket1"]: Creation complete after 3s [id=test-kiranbucket1]
module.cloud-storage.google_storage_bucket.buckets["bucket2"]: Creation complete after 4s [id=test-kiranbucket2]

Apply complete! Resources: 2 added, 0 changed, 0 destroyed.

The state of your infrastructure has been saved to the path
below. This state is required to modify and destroy your
infrastructure, so keep it safe. To inspect the complete state
use the `terraform show` command.

State path: terraform.tfstate
```
4. Run pan again to check the behavior
```
$ terraform plan
Refreshing Terraform state in-memory prior to plan...
The refreshed state will be used to calculate this plan, but will not be
persisted to local or remote state storage.

module.cloud-storage.google_storage_bucket.buckets["bucket2"]: Refreshing state... [id=test-kiranbucket2]
module.cloud-storage.google_storage_bucket.buckets["bucket1"]: Refreshing state... [id=test-kiranbucket1]

------------------------------------------------------------------------

No changes. Infrastructure is up-to-date.

This means that Terraform did not detect any differences between your
configuration and real physical resources that exist. As a result, no
actions need to be performed.
```

## Using Module output variables:
The module output variables can be used in the scripts like any other variable. Below is the syntax for accessing module output variables
```
Syntax:
module.<module name>.<module output variable>

from the previous example  
module.cloud-storage.bucket_name
```
Let's add the output variables in the root main.tf code to expose the output variables from the module.
```
provider "google" {
  version = "3.25.0"
  credentials = file("../gcp_cred.json")
  project = "practiceproject-248407"
  region  = "us-central1"
  zone    = "us-central1-c"
}

module "cloud-storage" {
  source  = "./gcs-bucket"
  names = ["bucket1", "bucket2"]
  prefix = "test-kiran"
  project_id = "practiceproject-248407"
}

output "bucket-names"{
    description = "names of the buckets created"
    value = module.cloud-storage.bucket_name
}
```
- Run the Terraform apply command again to show the output variables. The below log shows no changes to resources but printed the output variable “bucket-names” 
```
$ terraform apply
module.cloud-storage.google_storage_bucket.buckets["bucket2"]: Refreshing state... [id=test-kiranbucket2]
module.cloud-storage.google_storage_bucket.buckets["bucket1"]: Refreshing state... [id=test-kiranbucket1]

Apply complete! Resources: 0 added, 0 changed, 0 destroyed.

Outputs:

bucket-names = {
  "bucket1" = {
    "bucket_policy_only" = false
    "cors" = []
    "default_event_based_hold" = false
    "encryption" = []
    "force_destroy" = false
    "id" = "test-kiranbucket1"
    "labels" = {}
    "lifecycle_rule" = []
    "location" = "US-EAST1"
    "logging" = []
    "name" = "test-kiranbucket1"
    "project" = "practiceproject-248407"
    "requester_pays" = false
    "retention_policy" = []
    "self_link" = "https://www.googleapis.com/storage/v1/b/test-kiranbucket1"
    "storage_class" = "STANDARD"
    "url" = "gs://test-kiranbucket1"
    "versioning" = []
    "website" = []
  }
  "bucket2" = {
    "bucket_policy_only" = false
    "cors" = []
    "default_event_based_hold" = false
    "encryption" = []
    "force_destroy" = false
    "id" = "test-kiranbucket2"
    "labels" = {}
    "lifecycle_rule" = []
    "location" = "US-EAST1"
    "logging" = []
    "name" = "test-kiranbucket2"
    "project" = "practiceproject-248407"
    "requester_pays" = false
    "retention_policy" = []
    "self_link" = "https://www.googleapis.com/storage/v1/b/test-kiranbucket2"
    "storage_class" = "STANDARD"
    "url" = "gs://test-kiranbucket2"
    "versioning" = []
    "website" = []
  }
}
```
Resources:

- https://www.terraform.io/docs/configuration/modules.html
- https://registry.terraform.io/search?page=2&provider=hashicorp%2Fgoogle&q=google
- https://registry.terraform.io/modules/terraform-google-modules/cloud-storage/google/1.6.0