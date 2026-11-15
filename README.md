# RG Infrastructure Labs — DevOps & Cloud Portfolio

## Project Overview

This project combines my personal DevOps and Cloud Engineering portfolio with a practical AWS infrastructure and deployment workflow.

The website showcases my projects, technical skills and progression from IT Support and Infrastructure into DevOps and Cloud Engineering. It uses my RG Infrastructure Labs green-and-black branding and is built with HTML, CSS and JavaScript.

The project follows three infrastructure stages: building the hosting environment manually in the AWS Console, recreating it with Terraform, and automating infrastructure changes and website releases through GitHub Actions.

## Current Status

The static website is available for local review. AWS hosting, Terraform configuration and CI/CD pipelines form the next stages of the project. EKS projects appear on the website as planned work.

## Objectives

- Create a professional portfolio with direct links to documented engineering projects.
- Understand the hosting architecture through a manual AWS Console deployment.
- Serve the website through CloudFront using HTTPS and a custom domain.
- Keep the S3 origin private using CloudFront Origin Access Control.
- Recreate the hosting infrastructure using Terraform.
- Automate infrastructure checks and website releases using GitHub Actions.
- Verify DNS, TLS, origin access, caching and release recovery.
- Document implementation decisions, troubleshooting and costs.

## Portfolio Content

The website includes:

- **Flagship project:** RG Lab Tracker, deployed on AWS ECS Fargate using Docker, Terraform and GitHub Actions.
- **Future flagship projects:** Kubernetes and Amazon EKS, clearly labelled as planned.
- **Supporting projects:** WordPress on AWS with Terraform, EC2 configuration with Cloud-Init, Docker image publishing, Terraform validation, and a multi-container Docker Compose challenge.
- **Technical skills:** AWS, Terraform, Docker, Kubernetes, Linux, Git and GitHub Actions.
- **About Me:** My background, homelab experience and approach to learning through building and troubleshooting.
- **Contact:** A visible email address, an email link and a copy-email button.

The first version remains static. The contact section uses the visitor's email application and does not require a backend or contact form.

## AWS Hosting Architecture

The hosting design uses the following services:

| Component | Purpose |
|---|---|
| Amazon S3 | Stores the website files in a private bucket |
| Amazon CloudFront | Delivers and caches the website content |
| Origin Access Control | Restricts S3 object access to the authorised CloudFront distribution |
| Amazon Route 53 | Routes the portfolio hostname to CloudFront |
| AWS Certificate Manager | Provides the certificate for HTTPS |
| AWS IAM | Controls infrastructure and deployment permissions |

Visitors resolve the portfolio hostname through Route 53 and connect to CloudFront over HTTPS. CloudFront retrieves content from the private S3 bucket using signed origin requests.

The design uses the regular S3 bucket endpoint rather than the S3 static website endpoint, with S3 Block Public Access enabled.

The base domain is `rginfralabs.co.uk`. The initial deployment hostname is `portfolio.rginfralabs.co.uk`, allowing the existing root website to remain available during testing.

The design places the website bucket in `eu-north-1` and the CloudFront ACM certificate in `us-east-1`.

## Build and Deployment Workflow

### Stage 1 — Local Website

The `site/` directory contains the portfolio source and assets. Local checks cover content, navigation, image loading, mobile layout and contact controls.

### Stage 2 — AWS Console Deployment

The manual build establishes the S3 bucket, CloudFront distribution, origin access policy, certificate and DNS record. This stage provides a working reference for the Terraform implementation.

### Stage 3 — Terraform Infrastructure

Terraform defines the hosting resources, while a remote state backend tracks the managed infrastructure. The rebuild uses a separate test hostname before any change to the established portfolio address.

The existing Route 53 hosted zone remains shared infrastructure. The project manages its own records without recreating the zone.

### Stage 4 — GitHub Actions

Infrastructure and website delivery use separate workflows:

| Workflow | Responsibility |
|---|---|
| Infrastructure checks | Check Terraform formatting and configuration validity |
| Infrastructure deployment | Review a Terraform plan and apply infrastructure changes |
| Website deployment | Check website files, publish them to S3, refresh the appropriate CloudFront cache entries and verify the public site |

GitHub OIDC provides short-lived AWS credentials for deployment workflows. Terraform manages infrastructure; the website workflow publishes content.

### Stage 5 — Verification and Recovery

Verification exercises cover:

- Successful HTTPS access through the portfolio hostname.
- Rejection of anonymous direct access to S3 objects.
- Correct DNS resolution and certificate configuration.
- Publication and visibility of a website update.
- Restoration of a previous website release.
- Diagnosis of an origin-access policy failure in a test environment.

## Repository Structure

The repository starts with the website source:

```text
.
├── README.md
└── site/
    ├── index.html
    ├── style.css
    ├── script.js
    ├── ASSET-SOURCES.md
    └── assets/
```

The infrastructure stages introduce `infra/` for Terraform and `.github/workflows/` for GitHub Actions.

## Local Preview

From the repository root:

```bash
python3 -m http.server 8000 --directory site
```

Open [http://localhost:8000](http://localhost:8000) in a browser.

The website also supports opening `site/index.html` directly. Clipboard behaviour depends on browser permissions; the email address remains visible when copying is unavailable.

## Documentation and Evidence

Project documentation captures the manual build, Terraform implementation, pipeline runs, architecture decisions and troubleshooting results. Screenshots and verification commands provide evidence for each completed stage.

The portfolio serves as both a showcase of my engineering work and a documented infrastructure project in its own right.
