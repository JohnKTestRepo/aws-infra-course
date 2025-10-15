# 🚀 Automating AWS Infrastructure Using Terraform, Terragrunt & GitHub Actions

This repository demonstrates how to **automate AWS infrastructure deployment and destruction** using **Terraform**, **Terragrunt**, and **GitHub Actions**, managed from an **Ubuntu 24.04 LTS WSL2 Jump Server**.

---

## 🧩 Project Overview

This example serves as **Lesson 0** in the course: *Automating AWS Infrastructure with Terraform*.  
You’ll learn how to structure your Terraform code with Terragrunt, manage environments (**Dev**, **Prod** and **Cleanup**), and automate **CI/CD** deployments through GitHub Actions.

### **Key Features**
- Modular Terraform code for **VPC**, **EC2**, and **S3 Static Website**
- Terragrunt for **environment separation**, **dependency management**, and **remote state**
- **GitHub Actions** for for automated deploy and destroy pipelines
- **GitFlow** strategy with feature → dev → main → cleanup
- Uses **Ubuntu 24.04 LTS (WSL2)** as a local jump server

---

## 🏗️ Folder Structure

```
live/
├── terragrunt.hcl           # Root config (remote state, common tags)
├── dev/
│   ├── vpc/terragrunt.hcl
│   ├── ec2/terragrunt.hcl
│   └── s3_website/terragrunt.hcl
└── prod/
    ├── vpc/terragrunt.hcl
    ├── ec2/terragrunt.hcl
    └── s3_website/terragrunt.hcl
└── cleanup/
    ├── destroy-dev/
    └── destroy-prod/

modules/
├── vpc/
├── ec2/
└── s3_website/
```

---

## ⚙️ Setup on Ubuntu 24.04 LTS WSL2

```bash
# Update and install dependencies
sudo apt update && sudo apt install -y unzip curl

# Install Terraform
curl -fsSL https://releases.hashicorp.com/terraform/1.6.6/terraform_1.13.3_linux_amd64.zip -o terraform.zip
sudo unzip terraform.zip -d /usr/local/bin/

# Install Terragrunt
TG_VERSION=0.90.0
curl -LO https://github.com/gruntwork-io/terragrunt/releases/download/v${TG_VERSION}/terragrunt_linux_amd64
chmod +x terragrunt_linux_amd64
sudo mv terragrunt_linux_amd64 /usr/local/bin/terragrunt

# Verify installation
terraform -version
terragrunt -version
```

---

## 🧱 Deploy the Infrastructure (Manual Run)

### For **Dev Environment**
```bash
cd live/dev
terragrunt run-all apply --auto-approve
```

### For **Prod Environment**
```bash
cd live/prod
terragrunt run-all apply --auto-approve
```

## 🧹 Cleanup (Destroy Infrastructure)
Use the following commands to destroy resources and avoid being billed for unused infrastructure.

### Destroy Dev Environment
```bash
cd live/dev
terragrunt run-all destroy --auto-approve
```

### Destroy Prod Environment
```bash
cd live/prod
terragrunt run-all destroy --auto-approve
```

>💡 Always confirm that your remote backend (S3 bucket, DynamoDB table) and GitHub workflows are properly configured before cleanup.

---

## 🤖 Automating with GitHub Actions

### **1. Workflow File**
Path: `github/workflows/aws_infra_gitflow.yml`

This workflow:
- 🚀 Deploys on pushes to `dev` or `main`
- 🧹 Destroys infrastructure on pushes to `cleanup/*`

🧹 Destroys infrastructure on pushes to cleanup/*

```yaml
name: AWS Infrastructure GitFlow Pipeline

on:
  push:
    branches:
      - dev
      - main
      - 'cleanup/*'
    paths:
      - 'live/**'

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3

      - name: Install Terraform & Terragrunt
        run: |
          sudo apt update && sudo apt install -y unzip curl
          curl -L https://releases.hashicorp.com/terraform/1.7.6/terraform_1.7.6_linux_amd64.zip -o terraform.zip
          sudo unzip terraform.zip -d /usr/local/bin/
          curl -L https://github.com/gruntwork-io/terragrunt/releases/download/v0.57.5/terragrunt_linux_amd64 -o terragrunt
          chmod +x terragrunt
          sudo mv terragrunt /usr/local/bin/

      - name: Configure AWS Credentials
        uses: aws-actions/configure-aws-credentials@v2
        with:
          aws-access-key-id: ${{ secrets.AWS_ACCESS_KEY_ID_DEV }}
          aws-secret-access-key: ${{ secrets.AWS_SECRET_ACCESS_KEY_DEV }}
          aws-region: us-east-2

      - name: Deploy or Destroy Infrastructure
        run: |
          if [[ "${GITHUB_REF##*/}" == cleanup* ]]; then
            echo "🧹 Destroying resources..."
            terragrunt run-all destroy --auto-approve
          else
            echo "🚀 Deploying environment..."
            terragrunt run-all apply --auto-approve
          fi
```

---

## 🔐 GitHub Secrets Setup

1. Create two environment: `dev` and `prod`
- **Settings → Environments → New environment** 
  - **Name**: `dev` or `prod`
  - **Configure environment**

2. Add secrets under **Configure environment → Add environment secret** based on the chart below:


| Environment | Secret Name | Description
|-------------|-------------|------------|
| `dev` | `AWS_ACCESS_KEY_ID_DEV`  | AWS access key from IAM user |
| `dev` | `AWS_SECRET_KEY_DEV`  | AWS secret key from IAM user |
| `prod`| `AWS_ACCESS_KEY_ID_PROD` | AWS access key from IAM user |
| `prod`| `AWS_SECRET_KEY_PROD` | AWS secret key from IAM user |


---

## 🌳 GitFlow Branching Strategy



| Branch | Action | Environment
|-------------|-------------|------------|
| `feature/*` | Develop features  | Local dev/test |
| `dev` | Auto-deploy to AWS Dev  | Dev environment |
| `main`| Auto-deploy to AWS Prod | Prod environment |
| `cleanup/dev-env`| Auto-destroy resources | Destroys all **Dev** resources |
| `cleanup/prod-env`| Auto-destroy resources | Destroys all **Prod** resources |

When pushed:
```bash
git checkout -b cleanup/dev-env
git push -u origin cleanup/dev-env
```

GitHub Actions automatically runs the destroy pipeline for the targeted environment.

Once cleanup completes:

```bash
git push origin --delete cleanup/dev-env
```

---

## 🧠 What Students Learn

- How to structure **multi-environment infrastructure** using Terragrunt
- How to manage **remote state** and **dependency chaining**
- How to build a **CI/CD pipeline** with GitHub Actions
- How to use **GitFlow** to control infrastructure lifecycle
- How to automate **destroy operations safely**

---

## 🗺️ Infrastructure Flow Diagram

```
            ┌──────────────────────────────┐
            │   GitHub Repository          │
            └──────────────┬───────────────┘
                           │
                           ▼
             ┌──────────────────────────────┐
             │   GitHub Actions Workflow    │
             │   (aws_infra_gitflow.yml)    │
             └──────────────┬───────────────┘
                           │
          ┌────────────────┼────────────────┐
          ▼                ▼                ▼
    live/dev         live/prod         cleanup/*
(Deploy Dev)     (Deploy Prod)     (Destroy All)

```

---

**Author:** John Kennedy  
**Project:** Automating AWS Infrastructure Using Terraform  
**Platform:** Ubuntu 24.04 LTS (WSL2)  
**Version:** v1.0.0  
