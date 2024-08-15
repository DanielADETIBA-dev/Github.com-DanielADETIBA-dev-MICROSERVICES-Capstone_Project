# AltSchool of Cloud Engineering Tinyuka 2023 Capstone Project

## Project Overview

The goal of this project is to deploy the Socks Shop microservices-based application using modern DevOps practices, emphasizing automation, security, and efficiency. The deployment will be managed using Infrastructure as Code (IaaC) to ensure rapid and reliable provisioning on Kubernetes.

## Table of Contents

- [AltSchool of Cloud Engineering Tinyuka 2023 Capstone Project](#altschool-of-cloud-engineering-tinyuka-2023-capstone-project)
  - [Project Overview](#project-overview)
  - [Table of Contents](#table-of-contents)
  - [Setup Details](#setup-details)
    - [Prerequisites](#prerequisites)
  - [Task Instructions](#task-instructions)
    - [Infrastructure as Code (IaaC)](#infrastructure-as-code-iaac)
    - [Readability and Maintainability](#readability-and-maintainability)
    - [Tools for Setup](#tools-for-setup)
  - [Key Evaluation Criteria](#key-evaluation-criteria)
  - [Extra Project Requirements](#extra-project-requirements)
  - [Project Goals Summarized](#project-goals-summarized)
  - [How to Deploy](#how-to-deploy)

## Setup Details

This project involves deploying the Socks Shop example microservices application, which is available on GitHub:

- [Socks Shop Microservices Demo - GitHub](https://github.com/microservices-demo/microservices-demo.github.io)
- [Socks Shop Microservices Demo - Implementation Guide](https://github.com/microservices-demo/microservices-demo/tree/master)

### Prerequisites

Before you begin, ensure you have the following tools installed:

- Kubernetes cluster (self-managed or cloud-based)
- Terraform or Ansible
- Prometheus and Grafana for monitoring
- Alertmanager for alerts
- Ansible Vault (optional, for securing sensitive data)
- IaaS provider account (e.g., AWS, GCP, Azure)

## Task Instructions

### Infrastructure as Code (IaaC)

- Automate the deployment process using Terraform or Ansible.
- Ensure the deployment steps are fully scripted and easily executable.

### Readability and Maintainability

- Emphasize clarity in your deployment scripts.
- Ensure that the setup can be easily updated or replicated by others.

### Tools for Setup

- **Kubernetes:** The application will run on a Kubernetes cluster.
- **Terraform/Ansible:** Used for configuration management and deployment automation.
- **Prometheus:** Deployed for monitoring the application.
- **Grafana:** Used for visualizing metrics.
- **Alertmanager:** Set up for sending alerts based on Prometheus monitoring.
- **HTTPS:** Use Let’s Encrypt to secure the application with HTTPS.

## Key Evaluation Criteria

1. **Deploy Pipeline:** Demonstrate how the application is deployed from code to a running environment.
2. **Monitoring and Alerts:** Implement Prometheus for monitoring and Alertmanager for sending alerts.
3. **Logging:** Ensure the application’s logs are captured and can be analyzed effectively.
4. **Configuration Management:** Use either Terraform or Ansible to manage the deployment.
5. **Security:** Secure the application with HTTPS using Let’s Encrypt.

## Extra Project Requirements

- **HTTPS:** The application must be accessible over HTTPS.
- **Network Security:** Implement network perimeter security rules.
- **Sensitive Data Security:** Use Ansible Vault to encrypt sensitive information.

## Project Goals Summarized

This project focuses on deploying a microservices-based application using IaaC, ensuring that the process is automated, secure, and reproducible. Key areas of emphasis include:

- Quick and reliable deployment
- Effective monitoring and alerting
- Secure access via HTTPS
- Maintenance and readability of the deployment process


 Ensure your code is well-documented, explaining each step of the deployment process.

## How to Deploy

1. Clone the repository:

   ```bash
   git clone https://github.com/yourusername/repository-name.git
   cd repository-name
