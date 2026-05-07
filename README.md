##  DevOps Production-Ready Application Deployment

### Project Overview

This project demonstrates a production-ready DevOps pipeline that automates the build, test, and deployment of a containerized application to AWS.

The system follows modern DevOps practices including:

Infrastructure as Code (Terraform)
CI/CD automation (GitHub Actions)
Containerization (Docker)
Cloud deployment (AWS ECS + ECR)
Basic monitoring readiness via AWS-native services

The goal is to simulate a real-world production deployment pipeline.

### Architecture Overview

The system architecture consists of the following components:

- Developer pushes code to GitHub repository
- GitHub Actions triggers CI/CD pipeline
- Docker image is built and tested
- Image is pushed to Amazon ECR
- Amazon ECS pulls the latest image and deploys it
- Application is exposed via ECS service (optionally behind ALB)

### Flow Diagram (logical)

Architecture

![Architecture](https://github.com/ChideraA080/devops-assessment/blob/main/Screenshots%20Devops%20Assessment/Devops%20Assessement.drawio.png)

```
GitHub Repo
     ↓
GitHub Actions CI/CD
     ↓
Docker Build + Test
     ↓
Amazon ECR (Image Registry)
     ↓
Amazon ECS (Deployment)
     ↓
Running Application
     ↓
Logs → CloudWatch
```

### Flow Explanation:
- Code is pushed to GitHub
- GitHub Actions builds Docker image
- Image is pushed to Amazon ECR
- ECS pulls image and deploys container
- Application is exposed via ECS service / Load Balancer
- Logs are sent to CloudWatch

### Application Access

Application URL:
http://devops-alb-21328564.us-east-1.elb.amazonaws.com

### Deployment Steps

1. Clone Repository
```
git clone <repo-url>
cd <repo-folder>
```
2. Infrastructure Setup (Terraform)

Initialize Terraform:

```
terraform init
```
Validate configuration:

```
terraform validate
```
Deploy infrastructure:
```
terraform apply -auto-approve
```

This provisions:

- ECS Cluster

- ECS Service

- Networking (VPC/Subnets)

- IAM Roles

- Load Balancer

3. Docker Build (Local Optional Test)

```
docker build -t app-image .
docker run -p 5000:5000 app-image
```
The application will be accessible at:

```
http://localhost:5000
```

4. CI/CD Setup (GitHub Actions)

Add the following secrets in GitHub:

- AWS_ACCESS_KEY_ID

- AWS_SECRET_ACCESS_KEY

- AWS_REGION

- ECR_URI

5. Pipeline Execution

Pipeline automatically runs on push to main branch:

Stages:

- Build Docker image

- Run basic container test

- Push image to Amazon ECR

- Deploy to Amazon ECS

### Amazon ECR Configuration

Amazon ECR was used as the private container registry for storing Docker images used by the ECS service.

The CI/CD pipeline automatically:

- Builds the Docker image
- Tags the image
- Pushes the image to Amazon ECR

Example Docker image push flow:
```
docker build -t app-image .
docker tag app-image:latest <ECR_URI>:latest
docker push <ECR_URI>:latest
```
ECS task definitions reference the latest image stored in ECR during deployment.

### Amazon ECS Deployment Configuration

The application was deployed using Amazon ECS Fargate to avoid manual server management and simplify container orchestration.

Terraform provisions:

ECS Cluster
ECS Service
ECS Task Definition
IAM Execution Roles
Networking resources
Application Load Balancer (ALB)

The ECS task definition specifies:

- Docker image from Amazon ECR
- CPU and memory allocation
- Container port mappings
- CloudWatch logging configuration

Example ECS container configuration:

```
{
  "containerPort": 5000,
  "hostPort": 5000
}
```

### Design Decisions

1. ECS over EC2

Amazon ECS was chosen because:

- It reduces infrastructure management overhead

- Supports container orchestration natively

- Easier scaling and deployment automation

2. Docker Containerization

Docker ensures:

- Consistency across environments

- Portable application packaging

- Easy integration with CI/CD pipelines

3. GitHub Actions for CI/CD

Chosen because:

- Native GitHub integration

- Easy configuration

- No external server required (unlike Jenkins)

4. ECR as Container Registry

Amazon ECR was used instead of Docker Hub because:

- Tight AWS integration with ECS

- Secure private registry

- IAM-based access control

5. Terraform for Infrastructure

Infrastructure is defined as code to ensure:

- Repeatability

- Version control

- Easy environment replication

### Assumptions
- AWS account is properly configured with IAM permissions

- ECS cluster and service are deployed via Terraform

- Docker image is compatible with ECS task definition

- GitHub repository is connected to Actions

- Basic application (web service or API) is already containerized

### Limitations

- Basic test stage only validates container startup (not full unit testing)

- No advanced monitoring dashboards configured (CloudWatch logs only)

- No blue/green deployment strategy implemented

- Single environment (no dev/staging/prod separation)

###  Future Improvements

- Implement Blue/Green deployment using ECS or CodeDeploy

- Add full unit + integration testing in CI pipeline

- Add AWS CloudWatch dashboards and alarms

- Introduce multi-environment deployment (dev/staging/prod)

- Add automated rollback on deployment failure

- Implement Terraform modules for better scalability

### Issues Encountered & Fixes
- ECS tasks stuck in PENDING → Fixed by correcting subnet/network configuration
- CannotPullContainerError → Fixed by ensuring correct :latest image pushed to ECR
- CI/CD Docker build failure → Fixed incorrect Dockerfile path in GitHub Actions workflow
- CloudWatch logs not appearing → Fixed IAM execution role permissions and log group configuration

### Screenshots

All screenshots are stored in: docs/screenshots/

ECS Service Running
![ECS Service](https://github.com/ChideraA080/devops-assessment/blob/main/Screenshots%20Devops%20Assessment/1000787439.jpg)

CI/CD Pipeline Success
![CI/CD Pipeline](https://github.com/ChideraA080/devops-assessment/blob/main/Screenshots%20Devops%20Assessment/Devops%20Assessment%20Pipeline.png)

CloudWatch Logs
![CloudWatch](https://github.com/ChideraA080/devops-assessment/blob/main/Screenshots%20Devops%20Assessment/1000787508.jpg)

Image pushed to ECR
![Image pushed to ECR](https://github.com/ChideraA080/devops-assessment/blob/main/Screenshots%20Devops%20Assessment/1000787462.jpg)

ECR Repository Image
![ECR Repository Image](https://github.com/ChideraA080/devops-assessment/blob/main/Screenshots%20Devops%20Assessment/1000787585.jpg)

ALB Showing DNS
![ALB WITH DNS](https://github.com/ChideraA080/devops-assessment/blob/main/Screenshots%20Devops%20Assessment/1000787460.jpg)

Application Running in Browser (ALB URL)
![ALB URL](https://github.com/ChideraA080/devops-assessment/blob/main/Screenshots%20Devops%20Assessment/1000787461.jpg)


### Conclusion

This project demonstrates a complete DevOps lifecycle including:

- Infrastructure provisioning (Terraform)

- Application containerization (Docker)

- CI/CD automation (GitHub Actions)

- Cloud deployment (AWS ECS + ECR)

- Logging and monitoring (CloudWatch)


It reflects a production-style deployment workflow focused on automation, scalability, and reliability.

## Lessons Learned

Working on this project gave me practical experience with real DevOps workflows and cloud deployment challenges.

One of the biggest things I learned was how different AWS services work together in a deployment pipeline. While building this project, I encountered issues related to ECS task failures, Docker image deployment, CloudWatch logging, and CI/CD pipeline errors. Troubleshooting those problems helped me better understand how ECS, ECR, IAM roles, networking, and GitHub Actions interact in a real environment.

I also learned the importance of proper debugging and reading service logs instead of guessing the issue. Fixing problems like `CannotPullContainerError`, pending ECS tasks, and incorrect Docker build paths improved my confidence in working with containerized applications and cloud infrastructure.

Overall, this project strengthened my understanding of:
- Infrastructure as Code using Terraform
- Docker containerization
- AWS ECS and ECR deployments
- CI/CD automation with GitHub Actions
- CloudWatch logging and monitoring
- Debugging deployment and infrastructure issues

This project gave me hands-on exposure to building and managing a production-style deployment workflow using modern DevOps practices.
