# Cloud Resume Challenge

This project is a serverless website built as part of the Cloud Resume Challenge. It utilizes various AWS services to host a static website, track visitor counts, and implement CI/CD using Terraform and GitHub Actions. Please note, as part of the challenge I manually configured my resources via the AWS console first. Later in the challenge I created the IaC code to match the infrastructure that was already in place. This means that some portions of the code directly point to the pre-exisiting ARNs from the console. This will affect your ability to replicate this project, so please change the code accordingly. 

## Architecture

The following AWS services were used:

- CloudFront - Content delivery network (CDN) for global distribution.

- S3 - Static website hosting for HTML, CSS, and JavaScript files.

- DynamoDB - NoSQL database to store and update visitor counts.

- Route 53 - Domain name system (DNS) management.

- IAM - Secure authentication and authorization management.

- Terraform - Infrastructure as Code (IaC) to provision AWS resources.

- Lambda (Python) - Function to track website visitors, invoked via the Function URL.

- ACM (AWS Certificate Manager) - SSL/TLS certificate management.

- GitHub Actions - CI/CD pipeline for automated deployments.

## Features

- Static Website Hosting - The website is hosted on S3 and served via CloudFront.

- Visitor Counter - Uses a JavaScript frontend to call an AWS Lambda function that updates a DynamoDB table.

- Custom Domain & HTTPS - Route 53 is used for domain management, with SSL/TLS certificates provided by ACM.

- Automated Deployment - Terraform is used to manage infrastructure, and GitHub Actions handle CI/CD.

## File Structure
```
.
├── infra/                  # Terraform configuration files
│   ├── lambda/             
│   |   ├── view_counter.py # Python script for AWS Lambda             
├── Resume/                 # Static website files (HTML, CSS, JavaScript)
│   ├── index.html
│   ├── assets/
│   |   ├── css
│   |   │   ├── main.css
│   |   ├── js
│   |   │   ├── index.js (Visitor counter logic)
├── .github/workflows/       # GitHub Actions for CI/CD
│   ├── deploy.yml
├── README.md                # Project documentation
```
## Setup & Deployment

### Prerequisites

- AWS account with necessary permissions

- Terraform installed

- GitHub repository for CI/CD

### Steps

1. Clone the repository:   
```
git clone https://github.com/camnowil96/Cloud-Resume-Challenge
cd Cloud-Resume-Challenge
```
2. Initialize and apply Terraform:
```
terraform init
terraform plan
terraform apply
```
3. Deploy website files to S3:
```
aws s3 sync ./website s3://your-s3-bucket-name
```
4. Verify the setup by visiting your CloudFront domain or Route 53 custom domain.

## CI/CD Workflow

The project uses GitHub Actions for automated deployment:

- On push to `main`, Terraform applies infrastructure changes.

- S3 website files are updated automatically.

- Lambda function is deployed with new code changes.

## Technologies Used

- Frontend: HTML, CSS, JavaScript

- Backend: AWS Lambda (Python), DynamoDB

- Infrastructure: Terraform, AWS CloudFront, S3, IAM, Route 53, ACM

- CI/CD: GitHub Actions

## Future Improvements

- Implement a frontend framework like React
  
- Add user authentication with AWS Cognito
  
- Enhance security policies for IAM roles
  
- Integrate testing in the CI/CD pipeline

## Author

**Cameron N. Wilson**<br>
[GitHub](https://github.com/camnowil96) | [LinkedIn](https://linkedin.com/in/cameron-wilson-46b51119a)
