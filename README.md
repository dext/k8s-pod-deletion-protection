# Validation Admission Controller
This Validation Admission Controller is a solution designed to enforce custom admission policies for Kubernetes resources using a combination of Terraform modules and a Ruby application.

## Overview
The Validation Admission Controller intercepts Kubernetes resource creation requests and applies custom validation logic before allowing resources to be created or modified. This helps enforce specific policies and ensure that only compliant resources are admitted into the cluster.

## Features
- **Terraform Integration:** Utilize Terraform modules to deploy and manage the admission controller within a Kubernetes cluster.

- **Ruby Application:** Core validation logic implemented in Ruby for flexibility and extensibility.

## Prerequisites
- **Kubernetes Cluster:** Access to a Kubernetes cluster (min version X.X) where the admission controller will be deployed.
- **Terraform:** Version 1.3 or higher installed locally for managing the infrastructure.

## Installation

To utilize the Validation Admission Controller, source the Terraform module in your existing Terraform configuration:

1. Add the module to your Terraform configuration

```hcl
module "termination_protection" {
    source = "https://github.com/Dext/k8s-pod-deletion-protection//ac_termination_protection?ref=v0.1"
    // Add any necessary parameters here
}
```

2. Configure the module by setting the necessary variables within the Terraform module block.
3. Apply the Terraform configuration to deploy the Termination Protection.

## Ruby Application
The Ruby application for custom validation logic is located in `app/app.rb`.

## Usage
Once deployed, the admission controller will intercept deletion requests for resources according to the defined policies. Only deletion requests targeting resources tagged with protected=true will be sent for admission. Any attempt to delete a resource not meeting this criteria will be rejected.

To ensure admission for deletion:

1. Tag the resources intended for protected deletion with protected=true.
2. he admission controller will evaluate deletion requests for compliance with defined policies, allowing only those tagged resources to be deleted.

To customize or extend the validation logic:

1. Update the Ruby application logic located in app/app.rb and rebuild the Docker image.
2. Re-deploy the Terraform module with the new Docker image to apply the changes.