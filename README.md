# HabitApp – End-to-End CI/CD, DevSecOps & GitOps Project

An end-to-end DevOps project that automates the build, testing, code quality analysis, security scanning, containerization, and Kubernetes deployment of a Java Spring Boot Habit Tracker application using Jenkins, Docker, Helm, and Argo CD.

---

## 1. Project Overview

HabitApp is a Java-based Habit Tracker application built using Spring Boot. It provides a web dashboard and REST API to manage daily habits.

This project demonstrates an automated software delivery workflow using modern DevOps and GitOps practices.

The CI/CD pipeline automates application building, testing, static code analysis, container image security scanning, Docker image publishing, and Helm-based deployment updates.

Argo CD monitors the Git repository and synchronizes the desired application configuration with the Kubernetes cluster.

### Project Objectives

- Automate application build and testing.
- Integrate SonarQube for code quality analysis.
- Integrate Trivy for container vulnerability scanning.
- Build and publish Docker images.
- Automate Kubernetes deployment configuration using Helm.
- Implement GitOps-based deployment using Argo CD.
- Maintain deployment history and support recovery through Git-based changes.

---

## 2. Project Architecture

```text
                  DEVELOPER
                      |
                      v
                 GITHUB REPO
                      |
                 Git Push
                      |
                      v
                  JENKINS
                      |
          +-----------+-----------+
          |           |           |
          v           v           v
       MAVEN       SONARQUBE     TRIVY
       BUILD       ANALYSIS      SCAN
          |           |           |
          +-----------+-----------+
                      |
                      v
                 DOCKER BUILD
                      |
                      v
                 DOCKER HUB
                      |
                      v
              UPDATE HELM VALUES
                      |
                      v
                 GITHUB REPO
                      |
                      v
                  ARGO CD
                      |
                AUTO SYNC
                      |
                      v
                KUBERNETES
                      |
                      v
                HABITAPP POD
                      |
                      v
                APPLICATION
```

### Workflow Explanation

1. Developer pushes application changes to GitHub.
2. Jenkins retrieves the latest source code.
3. Maven builds the application and executes tests.
4. SonarQube performs static code analysis.
5. Jenkins verifies the SonarQube Quality Gate.
6. Trivy scans the container image for vulnerabilities.
7. Docker builds the application image.
8. The image is pushed to Docker Hub.
9. Jenkins updates the image tag in the Helm configuration.
10. Argo CD detects the Git repository change.
11. Argo CD synchronizes the Helm configuration with Kubernetes.
12. Kubernetes deploys the updated application.

---

## 3. Technology Stack

| Category | Technology |
|---|---|
| Programming Language | Java 21 |
| Backend Framework | Spring Boot 3.3.4 |
| Build Tool | Maven |
| Frontend | HTML, CSS, JavaScript |
| Source Code Management | Git and GitHub |
| CI/CD Automation | Jenkins |
| Code Quality | SonarQube |
| Security Scanning | Trivy |
| Containerization | Docker |
| Container Registry | Docker Hub |
| Container Orchestration | Kubernetes (K3s) |
| Package Management | Helm |
| GitOps | Argo CD |
| Infrastructure | AWS EC2 Ubuntu |

---

## 4. Repository Structure

```text
HabitApp/
│
├── src/
│   └── main/
│       ├── java/
│       └── resources/
│
├── pom.xml
├── Dockerfile
├── Jenkinsfile
├── sonar-project.properties
├── README.md
│
├── helm/
│   └── habitapp/
│       ├── Chart.yaml
│       ├── values.yaml
│       └── templates/
│           ├── configmap.yaml
│           ├── deployment.yaml
│           ├── service.yaml
│           ├── ingress.yaml
│           └── secret.yaml
│
└── argocd/
    └── application.yaml
```

### Important Files

- `pom.xml` – Maven project dependencies and build configuration.
- `Dockerfile` – Instructions to build the application container image.
- `Jenkinsfile` – CI/CD pipeline definition.
- `sonar-project.properties` – SonarQube project analysis configuration.
- `helm/habitapp/` – Helm chart and Kubernetes resource templates.
- `argocd/application.yaml` – Argo CD Application configuration.
- `README.md` – Project documentation.

---

## 5. Application Details

**Application Name:** HabitApp – Habit Tracker

**Backend:** Java and Spring Boot

**Frontend:** HTML, CSS and JavaScript

**Storage:** In-memory ConcurrentHashMap

### Application Features

- Create new habits.
- View existing habits.
- Update habit details.
- Complete habits.
- Delete habits.
- Track habit streaks.

### Local Application Requirements

- JDK 21 or later.
- Maven 3.6 or later.
- Git.

### Build the Application

```bash
mvn clean package
```

### Run the Application

```bash
java -jar target/habit-tracker.jar
```

Application URL:

```text
http://localhost:8080
```

---

## 6. Jenkins CI/CD Pipeline

Jenkins automates the application delivery process.

**Jenkins Job:** `HabitApp-CI`

### Pipeline Stages

| Stage | Description |
|---|---|
| Git Checkout | Retrieves source code from GitHub |
| Maven Build | Compiles the Java application |
| Maven Test | Executes automated tests |
| SonarQube Analysis | Performs static code analysis |
| Quality Gate | Checks SonarQube quality status |
| Trivy Scan | Scans the container image for vulnerabilities |
| Docker Build | Creates the Docker image |
| Docker Hub Push | Publishes the image to Docker Hub |
| GitOps Update | Updates the Helm image tag in GitHub |

### Pipeline Flow

```text
GitHub Checkout
      |
      v
Maven Build
      |
      v
Maven Test
      |
      v
SonarQube Analysis
      |
      v
Quality Gate
      |
      v
Trivy Security Scan
      |
      v
Docker Build
      |
      v
Docker Hub Push
      |
      v
GitOps Helm Update
      |
      v
Pipeline Success
```

### Pipeline Result

The pipeline has successfully completed the following tasks:

- Maven build and tests.
- SonarQube Quality Gate verification.
- Trivy vulnerability scanning.
- Docker image publishing.
- GitOps Helm configuration update.

---

## 7. SonarQube – Code Quality Analysis

SonarQube is integrated into the Jenkins pipeline to analyze application source code.

### Purpose

- Static code analysis.
- Code quality assessment.
- Detection of code issues.
- Quality Gate verification.
- Maintainability analysis.

### Quality Gate

Jenkins checks the SonarQube Quality Gate before continuing the pipeline.

**Verified project result:** Quality Gate PASSED.

---

## 8. Trivy – Container Security Scanning

Trivy is integrated into the pipeline to scan container images for known vulnerabilities.

### Security Scanning Objectives

- Identify known vulnerabilities.
- Detect vulnerable operating system packages.
- Identify vulnerable application dependencies.
- Review image security before publishing.

The pipeline includes a Trivy security scanning stage.

---

## 9. Docker – Containerization

Docker packages the HabitApp application and its runtime requirements into a container image.

### Docker Image

**Docker Hub Repository:**

https://hub.docker.com/r/rokit45/habitapp

**Image Repository:**

```text
rokit45/habitapp
```

Example published image:

```text
rokit45/habitapp:10
```

The image tag changes when a new version is built and published.

### Docker Commands

Build image:

```bash
docker build -t rokit45/habitapp:latest .
```

Run container:

```bash
docker run -d -p 8080:8080 rokit45/habitapp:latest
```

List images:

```bash
docker images
```

List running containers:

```bash
docker ps
```

---

## 10. Kubernetes – Application Deployment

The application is deployed to a Kubernetes cluster running on K3s.

### Deployment Information

| Component | Configuration |
|---|---|
| Kubernetes Distribution | K3s |
| Namespace | habitapp-gitops |
| Deployment | habitapp-gitops |
| Container Registry | Docker Hub |
| Application Image | rokit45/habitapp |
| Deployment Management | Helm and Argo CD |

### Kubernetes Commands

Check cluster nodes:

```bash
kubectl get nodes
```

Check application pods:

```bash
kubectl get pods -n habitapp-gitops
```

Check deployments:

```bash
kubectl get deployments -n habitapp-gitops
```

Check services:

```bash
kubectl get services -n habitapp-gitops
```

Check rollout status:

```bash
kubectl rollout status deployment/habitapp-gitops -n habitapp-gitops
```

---

## 11. Helm – Kubernetes Package Management

Helm manages the Kubernetes application configuration through reusable chart templates.

### Helm Chart Location

```text
helm/habitapp/
```

### Chart Components

- `Chart.yaml` – Chart metadata.
- `values.yaml` – Application configuration values.
- `templates/deployment.yaml` – Kubernetes Deployment.
- `templates/service.yaml` – Kubernetes Service.
- `templates/configmap.yaml` – Application configuration.
- `templates/ingress.yaml` – Ingress configuration.
- `templates/secret.yaml` – Kubernetes Secret template.

### Helm Commands

Validate chart:

```bash
helm lint helm/habitapp
```

Render Kubernetes manifests:

```bash
helm template habitapp helm/habitapp
```

List Helm releases:

```bash
helm list -n habitapp-gitops
```

---

## 12. Argo CD – GitOps Continuous Delivery

Argo CD is used to implement GitOps-based Kubernetes deployment.

It continuously monitors the configured Git repository and synchronizes the desired application configuration with the Kubernetes cluster.

### Argo CD Configuration

**Application Name:**

```text
habitapp-gitops
```

**Repository:**

https://github.com/rokit-cloud/HabitApp

**Branch:**

```text
main
```

**Helm Chart Path:**

```text
helm/habitapp
```

**Kubernetes Namespace:**

```text
habitapp-gitops
```

### Sync Policy

- Automated synchronization enabled.
- Self-healing enabled.
- Automatic pruning disabled.

### GitOps Workflow

```text
Jenkins Updates Helm Values
            |
            v
       GitHub Main
            |
            v
         Argo CD
            |
            v
      Detect Changes
            |
            v
       Auto Sync
            |
            v
       Kubernetes
            |
            v
   Updated Application
```

### Argo CD Commands

List applications:

```bash
kubectl get applications -n argocd
```

Check application status:

```bash
kubectl get application habitapp-gitops -n argocd
```

---

## 13. Accessing the Application

The application can be accessed locally through Kubernetes port forwarding.

### Start Port Forwarding

```bash
kubectl port-forward -n habitapp-gitops svc/habitapp-gitops 18084:8080
```

Open the following URL in your browser:

```text
http://localhost:18084
```

**Note:** This is a local port-forwarding URL. It is not a permanent public application URL.

---

## 14. Deployment Verification

The following commands can be used to verify the application deployment.

Check pods:

```bash
kubectl get pods -n habitapp-gitops
```

Check deployment:

```bash
kubectl get deployment habitapp-gitops -n habitapp-gitops
```

Check service:

```bash
kubectl get svc habitapp-gitops -n habitapp-gitops
```

Check Argo CD:

```bash
kubectl get application habitapp-gitops -n argocd
```

Check application logs:

```bash
kubectl logs deployment/habitapp-gitops -n habitapp-gitops --tail=50
```

---

## 15. Deployment History and Recovery

Kubernetes maintains deployment revision history.

Check rollout history:

```bash
kubectl rollout history deployment/habitapp-gitops -n habitapp-gitops
```

### GitOps Recovery Approach

For a GitOps-managed application, the recommended recovery process is:

1. Identify a previously working application image tag.
2. Update the image tag in the Helm values file in GitHub.
3. Commit the change to the main branch.
4. Allow Argo CD to synchronize the updated configuration.
5. Verify the deployment and application health.

This keeps GitHub as the source of truth for the desired deployment state.

---

## 16. Monitoring and Application Logs

Kubernetes provides commands to inspect application health and logs.

Check all cluster pods:

```bash
kubectl get pods -A
```

Check nodes:

```bash
kubectl get nodes
```

View application logs:

```bash
kubectl logs deployment/habitapp-gitops -n habitapp-gitops --tail=50
```

### Future Monitoring Integration

Prometheus and Grafana can be integrated to provide:

- Application performance monitoring.
- CPU and memory utilization.
- Kubernetes cluster monitoring.
- Dashboard visualization.
- Alerts and notifications.

These are planned monitoring enhancements, not part of the currently verified deployment.

---

## 17. Security and Best Practices

This project demonstrates several DevSecOps practices:

- GitHub for source code version control.
- Jenkins credentials for pipeline authentication.
- SonarQube for static code quality analysis.
- Trivy for container vulnerability scanning.
- Docker image publishing through Docker Hub.
- Kubernetes namespace-based application organization.
- Argo CD automated synchronization.
- Git-based deployment configuration management.

**Security Note:** Do not commit passwords, access tokens, private keys, or other sensitive credentials to the GitHub repository.

---

## 18. Current Application Limitation

The application currently uses an in-memory `ConcurrentHashMap` for storing habit information.

Therefore:

- Data is not persistent across application restarts.
- Separate application replicas do not share in-memory data.
- A persistent database is required for production-grade data storage.

---

## 19. Future Enhancements

Potential improvements include:

- MySQL or PostgreSQL database integration.
- Persistent Kubernetes storage where required.
- Prometheus and Grafana monitoring.
- Kubernetes Ingress and external application access.
- Improved secrets management.
- Horizontal scaling.
- Automated deployment notifications.
- Production-grade backup and recovery.

---

## 20. Project Links

| Resource | Link |
|---|---|
| GitHub Repository | https://github.com/rokit-cloud/HabitApp |
| Docker Hub | https://hub.docker.com/r/rokit45/habitapp |
| README | https://github.com/rokit-cloud/HabitApp/blob/main/README.md |
| Jenkins Pipeline | Configured in Jenkins as HabitApp-CI |
| Argo CD Configuration | `argocd/application.yaml` |
| Helm Chart | `helm/habitapp/` |

---

## 21. Project Outcome

HabitApp demonstrates an end-to-end DevOps workflow that connects source code management, continuous integration, code quality analysis, container security scanning, Docker image publishing, Helm-based Kubernetes configuration, and GitOps-based deployment.

The project showcases practical experience with:

- CI/CD pipeline automation.
- DevSecOps integration.
- Docker containerization.
- Kubernetes deployment.
- Helm chart management.
- Argo CD GitOps.
- Deployment verification and recovery workflows.

---

## Author

**Rokit**

GitHub: https://github.com/rokit-cloud

**Project:** HabitApp – End-to-End CI/CD and GitOps Implementation
