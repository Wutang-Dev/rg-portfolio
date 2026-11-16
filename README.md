# RG Infrastructure Labs — DevOps & Cloud Portfolio

## Project Overview

This project combines my personal DevOps and Cloud Engineering portfolio with an AWS hosting environment defined in Terraform and deployment workflows built with GitHub Actions.

The website showcases my projects, technical skills and progression from IT Support and Infrastructure into DevOps and Cloud Engineering. It uses my RG Infrastructure Labs green-and-black branding and is built with HTML, CSS and JavaScript.

**Live portfolio:** https://portfolio.rginfralabs.co.uk  
**Source code:** https://github.com/Wutang-Dev/rg-portfolio

## Current Status

The portfolio is live on AWS and has been checked on desktop and mobile.

Completed work includes:

- Private S3 hosting with versioning, encryption and Block Public Access.
- CloudFront delivery using Origin Access Control.
- HTTPS using an ACM certificate.
- Route 53 A and AAAA alias records.
- Terraform modules for S3, ACM, CloudFront and Route 53.
- Remote Terraform state in S3 with native state locking.
- GitHub Actions workflows for Terraform checks, infrastructure deployment and website releases.
- AWS authentication through GitHub OIDC.
- Verification of HTTPS delivery, HTTP redirects and restricted direct S3 access.
- Recovery from a missing bucket policy and an untracked bucket.

Kubernetes and Amazon EKS projects remain clearly labelled as planned work.

## Objectives

- Create a professional portfolio with links to documented engineering projects.
- Deliver the website through CloudFront using HTTPS and a custom domain.
- Keep the S3 origin private.
- Define the hosting infrastructure using reusable Terraform modules.
- Automate infrastructure checks and website releases.
- Use short-lived AWS credentials for GitHub Actions.
- Verify the deployed website and troubleshoot infrastructure failures.

## Portfolio Content

The website includes:

- **Flagship project:** RG Lab Tracker, deployed on AWS ECS Fargate using Docker, Terraform and GitHub Actions.
- **Planned projects:** Kubernetes and Amazon EKS.
- **Supporting projects:** WordPress on AWS with Terraform, EC2 configuration with Cloud-Init, Docker image publishing, Terraform validation and a multi-container Docker Compose challenge.
- **Technical skills:** AWS, Terraform, Docker, Kubernetes, Linux, Git and GitHub Actions.
- **About Me:** My background, homelab experience and approach to learning through building and troubleshooting.
- **Contact:** A visible email address, an email link and a copy-email button.

The website is static. The contact section uses the visitor’s email application and does not require an application backend.

## AWS Hosting Architecture

| Component | Purpose |
|---|---|
| Amazon S3 | Stores website files in a private bucket |
| Amazon CloudFront | Delivers and caches website content |
| Origin Access Control | Allows CloudFront to retrieve private S3 objects using signed requests |
| Amazon Route 53 | Routes the portfolio hostname to CloudFront |
| AWS Certificate Manager | Provides the HTTPS certificate |
| AWS IAM | Controls infrastructure and deployment permissions |
| S3 remote state backend | Stores Terraform state and lock files |

Visitors resolve `portfolio.rginfralabs.co.uk` through Route 53 and connect to CloudFront over HTTPS. CloudFront retrieves content from the private S3 bucket using Origin Access Control.

The bucket policy allows object reads from the specified CloudFront distribution and denies requests using insecure transport.

The configuration uses the regular S3 regional endpoint rather than the S3 static website endpoint. S3 Block Public Access remains enabled.

The website bucket is hosted in `eu-north-1`. The ACM certificate used by CloudFront is provisioned in `us-east-1`.

The existing `rginfralabs.co.uk` hosted zone is looked up through a Terraform data source. This project manages its own DNS records without recreating the shared hosted zone.

## Terraform Infrastructure

The infrastructure is separated into two Terraform root directories:

| Directory | Responsibility |
|---|---|
| `bootstrap/` | Remote state infrastructure and GitHub Actions IAM roles |
| `infra/` | Portfolio hosting resources |

The hosting configuration uses four modules:

| Module | Managed resources |
|---|---|
| `s3` | Website bucket, public access settings, ownership controls, versioning and encryption |
| `acm` | Certificate request, DNS validation records and certificate validation |
| `cloudfront` | Distribution and Origin Access Control |
| `route53` | A and AAAA alias records |

The root infrastructure configuration connects the modules and manages the S3 bucket policy.

Bootstrap and hosting infrastructure use separate state keys in the remote state bucket. Native S3 locking coordinates Terraform state changes.

## GitHub Actions

Infrastructure checks, infrastructure deployment and website delivery use separate workflows.

| Workflow | Responsibility |
|---|---|
| `terraform-checks.yml` | Checks formatting, initialises without the remote backend and validates both Terraform roots |
| `infra-deploy.yml` | Generates a saved plan and applies that plan in a separate job |
| `website-deploy.yml` | Checks website files, publishes content to S3, invalidates CloudFront and verifies the published release |

The deployment workflows authenticate to AWS using GitHub OIDC and IAM roles rather than stored AWS access keys.

Separate roles are used for infrastructure planning, infrastructure application and website deployment.

The website workflow also creates a release marker so verification can identify the deployed commit.

Terraform manages infrastructure. The website deployment workflow manages website content.

## Verification

The following checks were completed:

| Check | Observed result |
|---|---|
| Portfolio HTTPS request | HTTP 200 |
| Portfolio HTTP request | HTTP 301 redirect to HTTPS |
| Anonymous request to the S3 object endpoint | HTTP 403 |
| Route 53 A and AAAA lookups | IPv4 and IPv6 addresses returned |
| Website deployment workflow | Upload, cache invalidation and release verification succeeded |
| Desktop and mobile review | Website content and layout checked |
| Terraform plan after recovery | No changes |

Example commands:

```bash
curl -I https://portfolio.rginfralabs.co.uk

curl -I http://portfolio.rginfralabs.co.uk

dig +short portfolio.rginfralabs.co.uk A

dig +short portfolio.rginfralabs.co.uk AAAA

terraform -chdir=infra plan
```

## Troubleshooting and Recovery

### GitHub OIDC authentication

The infrastructure apply job initially failed to assume its AWS role.

The deployed trust policy still expected a GitHub environment subject, while the workflow was configured to run without that environment.

I updated and applied the trust policy to match the repository’s main-branch OIDC subject, then checked the deployed IAM role.

### Infrastructure permissions

An infrastructure apply also failed because its IAM role did not allow `s3:CreateBucket`.

I updated the role’s Terraform configuration to include that action. However, resolving the permission error alone did not establish why Terraform was attempting to create an existing bucket.

### Missing bucket policy and Terraform state recovery

The website later returned HTTP 403 through CloudFront.

I checked the origin directly using authenticated AWS CLI commands and confirmed that `index.html` still existed. A separate check showed that the bucket policy was missing.

The failed apply logs showed that Terraform had deleted the bucket policy and several bucket settings. A fresh plan also showed that Terraform intended to create the existing website bucket.

I recovered the infrastructure by:

1. Importing the existing bucket back into Terraform state.
2. Generating and reviewing a fresh recovery plan.
3. Applying the plan to restore the bucket policy and settings.
4. Invalidating CloudFront’s cached errors.
5. Confirming HTTP 200 and a Terraform plan with no changes.

The website files were preserved during recovery.

The original trigger for the bucket becoming untracked still requires investigation.

**Key lesson:** Passing formatting and validation checks does not prove that a deployment is safe or that the website is working. The Terraform plan and the public application both need verification.

## Repository Structure

```text
.
├── README.md
├── bootstrap/
│   ├── main.tf
│   ├── providers.tf
│   ├── variables.tf
│   ├── outputs.tf
│   ├── backend.tf
│   ├── github-actions.tf
│   ├── infra-plan-role.tf
│   └── infra-apply-role.tf
├── infra/
│   ├── main.tf
│   ├── providers.tf
│   ├── variables.tf
│   ├── outputs.tf
│   ├── backend.tf
│   └── modules/
│       ├── s3/
│       ├── acm/
│       ├── cloudfront/
│       └── route53/
├── .github/
│   └── workflows/
│       ├── terraform-checks.yml
│       ├── infra-deploy.yml
│       └── website-deploy.yml
└── site/
    ├── index.html
    ├── style.css
    ├── script.js
    ├── ASSET-SOURCES.md
    └── assets/
```

Terraform state, local backend configuration and saved plans are excluded from version control. Provider lock files are committed.

## Local Preview

From the repository root:

```bash
python3 -m http.server 8000 --directory site
```

Open http://localhost:8000 in a browser.

The website also supports opening `site/index.html` directly. Clipboard behaviour depends on browser permissions; the email address remains visible when copying is unavailable.

## Future Improvements

- Investigate the original infrastructure deployment failure.
- Verify another complete infrastructure pipeline run after recovery.
- Practise restoring a previous website release.
- Document operating costs.
- Add completed Kubernetes and EKS projects as they become available.

## What I Learned

This project gave me practical experience connecting DNS, certificates, CloudFront and private S3 storage, organising Terraform into modules, and separating infrastructure changes from website releases.

It also reinforced the importance of checking IAM trust policies, reviewing saved plans and understanding Terraform state before making changes to existing resources.

The portfolio is both a showcase of my engineering work and an infrastructure project in its own right.