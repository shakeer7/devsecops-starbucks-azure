<div align="center">

# ☕ Starbucks Clone — DevSecOps on Azure AKS & Azure Pipelines

### End-to-end CI/CD with Azure DevOps Pipelines, Trivy, SonarQube, Azure Container Registry & AKS

[![Azure Pipelines](https://img.shields.io/badge/CI%2FCD-Azure%20Pipelines-0078D4?style=for-the-badge&logo=azuredevops&logoColor=white)](#-cicd-pipeline-azure-devops-pipelines)
[![Docker](https://img.shields.io/badge/Container-Docker-2496ED?style=for-the-badge&logo=docker&logoColor=white)](#-docker-build-and-run)
[![Kubernetes](https://img.shields.io/badge/Orchestration-Kubernetes-326CE5?style=for-the-badge&logo=kubernetes&logoColor=white)](#%EF%B8%8F-deploy-application-to-azure-kubernetes-service-aks)
[![Azure AKS](https://img.shields.io/badge/Cloud-Azure%20AKS-0078D4?style=for-the-badge&logo=microsoftazure&logoColor=white)](#%EF%B8%8F-azure-infrastructure-with-terraform)
[![Azure ACR](https://img.shields.io/badge/Registry-Azure%20ACR-0089D6?style=for-the-badge&logo=microsoftazure&logoColor=white)](#-push-image-to-azure-container-registry-acr)
[![Security](https://img.shields.io/badge/Security-Trivy%20%7C%20SonarQube-1904DA?style=for-the-badge&logo=aquasecurity&logoColor=white)](#-security-scanning-with-trivy)
[![Monitoring](https://img.shields.io/badge/Monitoring-Prometheus%20%7C%20Grafana-E6522C?style=for-the-badge&logo=prometheus&logoColor=white)](#-monitoring-with-prometheus-and-grafana)

</div>

---

## 📖 Overview

This project demonstrates an enterprise-grade **DevSecOps** pipeline for deploying a **React-based Starbucks Clone** application on **Azure Kubernetes Service (AKS)** using **Azure DevOps Pipelines** running exclusively on **Microsoft-hosted cloud agents**.

It seamlessly integrates:
- **Continuous Integration & Continuous Deployment (CI/CD)** via **Azure DevOps Pipelines** with automated testing, SonarQube static code analysis, and Trivy filesystem/container vulnerability scanning.
- **Infrastructure as Code (IaC)** using **Terraform** to provision Azure Virtual Networks, Subnets, Network Security Groups, Azure Container Registry (ACR), Azure Kubernetes Service (AKS), and Linux Tooling Virtual Machines.
- **Container Registry** on **Azure Container Registry (ACR)** with native Managed Identity role assignments (`AcrPull`).
- **Kubernetes Orchestration** on **Azure AKS** with automated scaling, health probes, and Azure Public Load Balancers.
- **Full-Stack Observability** with **Prometheus** and **Grafana** deployed via Helm charts.

---

## 📑 Table of Contents

- [Architecture](#-architecture)
- [Features](#-features)
- [Technology Stack](#-technology-stack)
- [Project Structure](#-project-structure)
- [Prerequisites](#-prerequisites)
- [Local Development](#-local-development)
- [Docker Build & Run](#-docker-build-and-run)
- [Security Scanning with Trivy](#-security-scanning-with-trivy)
- [Azure Infrastructure with Terraform](#%EF%B8%8F-azure-infrastructure-with-terraform)
- [Push Image to Azure Container Registry (ACR)](#-push-image-to-azure-container-registry-acr)
- [CI/CD Pipeline (Azure DevOps Pipelines)](#-cicd-pipeline-azure-devops-pipelines)
- [Deploy Application to Azure Kubernetes Service (AKS)](#%EF%B8%8F-deploy-application-to-azure-kubernetes-service-aks)
- [Access Application via Azure Load Balancer](#-access-application-via-azure-load-balancer)
- [Monitoring with Prometheus and Grafana](#-monitoring-with-prometheus-and-grafana)
- [Useful Commands](#-useful-commands)
- [Security Best Practices](#%EF%B8%8F-security-best-practices)
- [Author & Support](#-author)

---

## 🏗️ Architecture

```text
Developer Commit
      │
      ▼
Azure DevOps Repository / Git
      │
      ▼
Azure DevOps Pipelines (Microsoft-hosted Agent: ubuntu-latest)
      │
      ├── 1. Code Quality: npm ci ➔ npm test ➔ SonarQube ➔ Trivy FS Scan
      ├── 2. Build: React Production Build Artifact ('react-build')
      ├── 3. Containerization: Docker Build ➔ Trivy Image Scan ➔ Azure ACR Push
      └── 4. Deployment: Azure CLI (az aks get-credentials) ➔ Apply k8s/ ➔ Rollout Verification
      │
      ▼
Azure Cloud Environment (Resource Group: rg-starbucks-devsecops)
      ├── Azure Container Registry (ACR: acrstarbucksdevsecops.azurecr.io)
      ├── Azure Virtual Network (vnet-starbucks: 10.0.0.0/16)
      │     ├── Subnet: snet-aks (10.0.1.0/24)
      │     └── Subnet: snet-tooling (10.0.2.0/24)
      │
      ├── Tooling Virtual Machines (Ubuntu 22.04 LTS / 24.04 LTS)
      │     ├── vm-starbucks-app (Dev VM)
      │     ├── vm-sonarqube (Code Quality Server)
      │     └── vm-trivy (Security Scanner)
      │
      ├── Azure Kubernetes Service (AKS: aks-starbucks)
      │     ├── Managed Agent Pool (Autoscaling 1-3 nodes)
      │     ├── Pods (starbucks replicas)
      │     └── Service (Type: LoadBalancer ➔ Azure Public IP)
      │
      └── Observability & Monitoring
            ├── Prometheus (Metrics Scraper)
            └── Grafana (Dashboards & Visualizations)
```

---

## 🚀 Features

| DevSecOps Capability | Azure Implementation |
|---|---|
| **CI/CD Platform** | Azure DevOps Pipelines with 4 automated stages |
| **Agent Infrastructure** | 100% Microsoft-hosted cloud agents (`ubuntu-latest`) — No self-hosted management |
| **Infrastructure as Code** | Terraform (`azurerm` provider) provisioning VNet, NSG, ACR, AKS, and Linux VMs |
| **Cloud Provider** | Microsoft Azure (`eastus` / configurable) |
| **Container Registry** | Azure Container Registry (ACR) with role-based `AcrPull` authorization |
| **Kubernetes Orchestration** | Azure Kubernetes Service (AKS) with automated node scaling & health probes |
| **Static Code Analysis** | SonarQube static code analysis with quality gates |
| **Security Scanning** | Trivy vulnerability scanner for both source code dependencies and Docker container images |
| **Public Exposure** | Azure Standard Load Balancer distributing traffic to pods on port 80 |
| **Monitoring & Metrics** | Prometheus and Grafana deployed via Helm |

---

## 🛠️ Technology Stack

| Category | Tool / Technology |
|---|---|
| **Frontend Application** | ReactJS 18, TailwindCSS |
| **Containerization** | Docker, Nginx Alpine |
| **CI/CD Platform** | Azure DevOps Pipelines |
| **Cloud Platform** | Microsoft Azure |
| **Cloud Orchestration** | Azure Kubernetes Service (AKS) |
| **Container Registry** | Azure Container Registry (ACR) |
| **Infrastructure as Code** | Terraform (HashiCorp `azurerm` provider) |
| **Cloud CLI Tools** | Azure CLI (`az`), `kubectl`, `kubelogin` |
| **Security Scanning** | Trivy (Filesystem & Image Scanner), SonarQube |
| **Package Manager** | Helm 3 |
| **Monitoring & Visualization** | Prometheus, Grafana |

---

## 📂 Project Structure

```text
devsecops-azure/
├── azure-pipelines.yml          # Azure DevOps Pipelines CI/CD definition
├── sonar-project.properties     # SonarQube project analysis configuration
│
├── k8s/
│   ├── deployment.yaml          # Kubernetes Deployment referencing ACR image
│   └── service.yaml             # Kubernetes LoadBalancer Service (Azure Public IP)
│
├── terraform/
│   ├── provider.tf              # AzureRM provider configuration
│   ├── variables.tf             # Configurable Azure variables (RG, region, VM sizes)
│   ├── main.tf                  # VNet, NSG, ACR, AKS, Role Assignment & Tooling VMs
│   ├── outputs.tf               # Outputs (ACR login server, AKS cluster, VM IPs, SSH key)
│   └── terraform.tfvars.example # Sample environment variable overrides
│
├── monitoring/
│   └── promotheus_configfile.txt # Prometheus scrape configuration
│
├── src/                         # Starbucks React frontend source code
├── public/                      # Static web assets
├── Dockerfile                   # Multi-stage Dockerfile (Node 20 build -> Nginx Alpine)
├── package.json                 # Project dependencies and test scripts
└── README.md                    # Project documentation
```

---

## ⚙️ Prerequisites

- **Azure CLI (`az`)**: [Install Azure CLI](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli)
- **Terraform (`>= 1.5.0`)**: [Install Terraform](https://developer.hashicorp.com/terraform/downloads)
- **kubectl**: [Install kubectl](https://kubernetes.io/docs/tasks/tools/)
- **kubelogin**: [Install kubelogin](https://azure.github.io/kubelogin/install.html)
- **Helm 3**: [Install Helm](https://helm.sh/docs/intro/install/)
- **Docker**: [Install Docker](https://docs.docker.com/get-docker/)
- **Node.js 20 & npm**: [Install Node](https://nodejs.org/)

Verify your CLI installations:

```bash
az version
terraform -version
kubectl version --client
kubelogin --version
helm version
docker --version
node --version
```

---

## 🖥️ Local Development

1. **Install dependencies:**
   ```bash
   npm install
   ```

2. **Run tests:**
   ```bash
   npm test -- --watchAll=false
   ```

3. **Start local development server:**
   ```bash
   npm start
   ```
   Open `http://localhost:3000` in your browser.

---

## 🐳 Docker Build and Run

1. **Build container image:**
   ```bash
   docker build -t starbucks:latest .
   ```

2. **Run container locally (Port 80 mapped to 8080):**
   ```bash
   docker run -d -p 8080:80 --name starbucks-app starbucks:latest
   ```

3. **Verify running container:**
   ```bash
   docker ps
   curl -I http://localhost:8080
   ```

4. **Stop container:**
   ```bash
   docker stop starbucks-app && docker rm starbucks-app
   ```

---

## 🔐 Security Scanning with Trivy

Trivy scans both the codebase and container images for known vulnerabilities (CVEs), secrets, and misconfigurations.

### 1. Filesystem Scan
```bash
trivy fs . --severity HIGH,CRITICAL --format table
```

### 2. Container Image Scan
```bash
trivy image starbucks:latest --severity HIGH,CRITICAL --format table
```

---

## ☁️ Azure Infrastructure with Terraform

The Terraform files in [`terraform/`](file:///c:/Users/shakeer/Desktop/devsecops%20-%20azure/terraform) provision the complete Azure infrastructure.

### 1. Authenticate to Azure
```bash
az login
az account set --subscription "<YOUR_SUBSCRIPTION_ID>"
```

### 2. Initialize and Review Plan
```bash
cd terraform
terraform init
terraform plan
```

### 3. Deploy Azure Resources
```bash
terraform apply -auto-approve
```

### 4. Retrieve Outputs
```bash
terraform output
```

The deployment provisions:
- **Resource Group:** `rg-starbucks-devsecops`
- **Virtual Network & Subnets:** `vnet-starbucks` (`snet-aks`, `snet-tooling`)
- **Azure Container Registry (ACR):** `acrstarbucksdevsecops.azurecr.io`
- **Azure Kubernetes Service (AKS):** `aks-starbucks` with managed identity and role assignment to pull from ACR
- **Tooling Linux VMs:** `vm-starbucks-app`, `vm-sonarqube`, `vm-trivy`

---

## 📤 Push Image to Azure Container Registry (ACR)

1. **Log in to ACR:**
   ```bash
   az acr login --name acrstarbucksdevsecops
   ```

2. **Tag image for ACR:**
   ```bash
   docker tag starbucks:latest acrstarbucksdevsecops.azurecr.io/starbucks:latest
   ```

3. **Push image to ACR:**
   ```bash
   docker push acrstarbucksdevsecops.azurecr.io/starbucks:latest
   ```

---

## 🚀 CI/CD Pipeline (Azure DevOps Pipelines)

The complete Azure-native pipeline is defined in [`azure-pipelines.yml`](file:///c:/Users/shakeer/Desktop/devsecops%20-%20azure/azure-pipelines.yml) running entirely on **Microsoft-hosted cloud agents (`ubuntu-latest`)** with 4 production DevSecOps stages:

```text
Stage 1: Code Quality, SonarQube & Security
   ├── Setup Node.js 20 & npm ci
   ├── npm test (Unit Tests)
   ├── SonarQube Static Code Analysis (sonarqube-scanner)
   └── Trivy File System CVE & Secrets Scan
   │
   ▼
Stage 2: Build React App (npm run build ➔ Publish Artifact 'react-build')
   │
   ▼
Stage 3: Containerize & ACR Push (Download Artifact ➔ Docker Build ➔ Trivy Image Scan ➔ Push to ACR)
   │
   ▼
Stage 4: Deploy to AKS (AzureCLI@2 ➔ az aks get-credentials ➔ Apply k8s/ ➔ Rollout Verification)
```

### 1. Azure DevOps Pipeline Prerequisites

1. **Service Connection:**
   - In Azure DevOps, go to **Project Settings ➔ Service Connections ➔ New Service Connection**.
   - Select **Azure Resource Manager** ➔ **Service Principal (automatic)**.
   - Select your Subscription and Resource Group `rg-starbucks-devsecops`.
   - Name the connection: `azure-service-connection` (matches variable in [`azure-pipelines.yml`](file:///c:/Users/shakeer/Desktop/devsecops%20-%20azure/azure-pipelines.yml)).
   - Grant access permissions to all pipelines.

2. **SonarQube Pipeline Variables:**
   - In Azure DevOps, go to **Pipelines ➔ Library** (or edit Pipeline ➔ **Variables**).
   - Add `SONAR_HOST_URL`: `http://<SONARQUBE_IP_OR_URL>:9000`
   - Add `SONAR_TOKEN`: `<YOUR_SONARQUBE_TOKEN>` (mark as secret).

### 2. Run Pipeline

1. In Azure DevOps, navigate to **Pipelines ➔ New Pipeline**.
2. Select **Azure Repos Git** (or **GitHub**).
3. Select **Existing Azure Pipelines YAML file** and point to [`/azure-pipelines.yml`](file:///c:/Users/shakeer/Desktop/devsecops%20-%20azure/azure-pipelines.yml).
4. Click **Run**. All jobs execute on Microsoft-hosted `ubuntu-latest` agents.

---

## ☸️ Deploy Application to Azure Kubernetes Service (AKS)

To deploy manually or verify the deployment:

### 1. Connect kubectl to AKS
```bash
az aks get-credentials \
  --resource-group rg-starbucks-devsecops \
  --name aks-starbucks \
  --overwrite-existing
```

### 2. Apply Kubernetes Manifests
```bash
kubectl apply -f k8s/
```

### 3. Verify Deployment & Pods
```bash
kubectl get deployments -l app=starbucks
kubectl get pods -l app=starbucks -o wide
```

### 4. Check Rollout Status
```bash
kubectl rollout status deployment/starbucks
```

---

## 🌐 Access Application via Azure Load Balancer

Retrieve the external IP provisioned by the Azure Standard Load Balancer:

```bash
kubectl get svc starbucks-service
```

Example Output:
```text
NAME                TYPE           CLUSTER-IP     EXTERNAL-IP      PORT(S)        AGE
starbucks-service   LoadBalancer   10.0.125.43    20.232.145.89    80:31250/TCP   2m
```

Open your browser and navigate to:
```text
http://<EXTERNAL-IP>
```

---

## 📊 Monitoring with Prometheus and Grafana

Observability on AKS is deployed using the official Prometheus Community Helm chart.

### 1. Add Prometheus Helm Repository
```bash
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
```

### 2. Deploy kube-prometheus-stack
```bash
helm install monitoring prometheus-community/kube-prometheus-stack \
  --namespace monitoring \
  --create-namespace
```

### 3. Verify Monitoring Pods
```bash
kubectl get pods -n monitoring
```

### 4. Retrieve Grafana Admin Password
```bash
kubectl get secret monitoring-grafana -n monitoring -o jsonpath="{.data.admin-password}" | base64 --decode
echo ""
```
*Default username: `admin`*

### 5. Access Grafana Dashboard
Port-forward Grafana to localhost:
```bash
kubectl port-forward svc/monitoring-grafana 3000:80 -n monitoring
```
Access Grafana at `http://localhost:3000`.

---

## 🧪 Useful Commands

| Action | Command |
|---|---|
| View AKS Nodes | `kubectl get nodes -o wide` |
| View Starbucks Pods | `kubectl get pods -l app=starbucks` |
| View Starbucks Service | `kubectl get svc starbucks-service` |
| Stream Pod Logs | `kubectl logs -l app=starbucks -f` |
| Describe Deployment | `kubectl describe deployment starbucks` |
| Restart Deployment | `kubectl rollout restart deployment starbucks` |
| Rollback Deployment | `kubectl rollout undo deployment starbucks` |
| Check AKS Cluster Status | `az aks show --resource-group rg-starbucks-devsecops --name aks-starbucks --output table` |
| Check ACR Repositories | `az acr repository list --name acrstarbucksdevsecops --output table` |

---

## 🛡️ Security Best Practices

- **Zero Hardcoded Secrets:** Authentication uses Azure Service Connections, avoiding static credentials in source code.
- **Role-Based Access Control (RBAC):** AKS accesses ACR via native Azure Managed Identity (`AcrPull` role assignment).
- **Vulnerability Scanning:** Codebase dependencies and container images are scanned on every pipeline run using Trivy.
- **Code Quality Gates:** Static code analysis via SonarQube ensures quality before build & packaging.
- **Resource Constraints:** Kubernetes manifests enforce CPU and memory `requests` and `limits` to prevent noisy-neighbor and OOM issues.
- **Health Probes:** Liveness and readiness probes verify application status before routing traffic.
- **Network Segmentation:** Azure VNet separates AKS node traffic from tooling virtual machines.

---

## 👨‍💻 Author

<div align="center">

**Shakeer Mohammed**

*DevOps | Cloud Architect | Kubernetes | Azure | DevSecOps Enthusiast*

📧 [mds.shakeer@gmail.com](mailto:mds.shakeer@gmail.com) &nbsp;|&nbsp; 📍 Hyderabad, India

</div>

---

## ⭐ Support

If you found this project helpful for your Azure DevSecOps journey, please consider giving the repository a **star** ⭐!