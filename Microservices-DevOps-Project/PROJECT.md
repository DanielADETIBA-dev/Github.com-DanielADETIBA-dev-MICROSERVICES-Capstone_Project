# DevOps-Project

## Socks-Shop 
> ![Project Image](images/project-diagram.png)

## Table of content

- [Overview](#overview)
- [Prerequisites](#prerequisites )
- [Install the Required Tools](#install-the-required-tools)
- [Getting started](#1-set-up-file-system)
- [Resources](#resources)
- [Author](#author)

## Overview

> ## Kubernetes
>
> ### often abbreviated as “K8s” (because there are 8 letters between the “K” & “s” in Kubernetes), orchestrates containerized applications to run on a cluster of hosts. K8s also allocates storage and persistent volumes to running containers, provides automatic scaling, and works continuously to maintain the desired state of applications, providing resiliency

<br>

 > ## Terraform
 >
>### HashiCorp Terraform is a tool for building, changing, and versioning infrastructure that has an open-source and enterprise version. Unlike AWS CloudFormation, which can only be used on AWS, Terraform is cloud agnostic and can be used to create multi-cloud infrastructure as well as on-prem

<br>

> ## Jenkins
>
> ### Jenkins is a self-contained, open source automation server used to automate tasks associated with building, testing, and delivering/deploying software. Jenkins Pipeline implements continuous deliver pipelines into Jenkins through use of plugins and a Jenkinsfile. The Jenkinsfile can be Declarative or Scripted and contains a list of steps for the pipeline to follow

<br>

> ## AWS EKS
>
> ### is a managed Kubernetes solution provided by AWS, which is a widely used managed K8S platform by AWS consumers

<br>

> ### Separately, Kubernetes and Terraform are powerful and popular tools for DevOps operations. However, when used together, you will see even more benefits for container cluster management

<br>
<br>

## Prerequisites

- [AWS Account](https://aws.amazon.com/premiumsupport/knowledge-center/create-and-activate-aws-account/)
- [GitHub Account](https://github.com/Bukola-Testimony)
- [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)
- Preferred IDE (I used VScode)

## Install the Required Tools

To begin, ensure that you have the necessary tools installed. These tools include:

- Terraform
- An s3 bucket created on AWS for the terraform backend.
- AWS CLI installed and configured on your IDE
<br>

<br>

### Now, Let’s get started — buckle up Chuck

## 1| Set Up File System

First, clone my GitHub repository:

```bash
git clone <https://github.com/Otimstheman/DevOps-Project>
```

Change into the directory to the folder shown below:

```bash
cd DevOps-Project/Terraform/jenkins/
```

## 2| Terraform Init, Plan & Apply

Here we are going to create our Jenkins Server. The terraform configuration files to create the server are in this path.
 <p>
This configuration creates a VPC along with subnets and security groups needed to create the server. Also a script is included to install the following at startup :

- Jenkins
- Terraform
- git
- kubectl

All these dependencies are needed for this project.
</p>
The first step is to initialize the terraform backend by using the following command:

```bash
terraform init
```

Next, you will run the terraform plan command to evaluate the Terraform configuration.

```bash
terraform plan
```

Finally, you will run the command terraform apply to apply the configuration.

```bash
terraform plan
```

Once everything runs successfully, you’ll see an output of the ec2-instance IP

Next, you will navigate over to the AWS console and you will be able to see the following:

- VPC

- subnets

- security groups

- ec2 instance tagged "dev-server"

## 3| Set up Jenkins Server

- Edit the inbound security group

> <p> Note: this has already been included in the terraform security group configuration.
> - Type: CustomTCP  - Port range: 8080

- Next, copy the public IP of the instance to your browser and append port 8080

> e.g 192.34.54.20:8080

- This should open the Jenkins Getting started page.

![](images/JENKINS/jenkins-unlock-page.png)

- SSH into your jenkins server either through your IDE or directly from aws console.

- To unlock, copy the code on the jenkins dashboard to your terminal.
![](images/JENKINS/jenkins-unlock-page.png)

- On the terminal, run:

```bash
sudo cat /var/lib/jenkins/secrets/initialAdminPassword
#Example Output: 95c29cd1d4a54943a8c9c05edcf13a8c
#Note: remember to include "sudo cat" before the unlock code 

```

![](images/JENKINS/jenkins-unlock-code.png)

- enter the code in the text box and click on continue
- On the next page, click on suggested pluggings. Allow the selected pluggins to run.
![](images/JENKINS/jenkins-plugin-installation.png)

- On the next page enter your user details and password.
 and viola! jenkins server is ready for use.
 ![](images/JENKINS/jenkins-is-ready.png)

- Configure jenkins server with all the necesary credentials both for Github and AWS.
![](images/JENKINS/manage-credentials.png)

- Now, Set up the environment variables needed for the pipeline. This require your aws credentials and github credentials. See example below.

```
AWS_ACCESS_KEY_ID: AKIANDPAW23PAWEXAMPLE
AWS_SECRET_ACCESS_KEY:Osie3yutegyu5vjnbn455Example
AWS_DEFAULT_REGION: us-east-1
Github Username and password
```

![credentials](images/JENKINS/jenkins-credentials.png)

<br>
<br>

## 5| Create a Pipeline

Configure Jenkins Pipeline to use the Terraform configuration file and the AWS CLI to provision the Kubernetes cluster.
Click on new item.

![](images/JENKINS/jenkins-pipeline-new-item.png)

- Give your project a name.
Choose pipeline and click `OK` at the bottom of the page.

![](images/JENKINS/pipeline.png)

- Add the github repository url to the pipeline. Indicate the Jenkinsfile and the Github branch. Save the job.
- Push your code to a repository on Github.

## 6| Create the Terraform file for deploying EKS

- Back to your IDE, create a terraform file for deploying kubernetes clusters to AWS EKS. In the git repository, you will find the terraform file I created for this purpose in the path: `Terraform/eks.`

- This file will create an eks cluster with 1 node. The size of the instance is t3.large. You may customise it to your preferences.

<br>
<br>

## 7| Run the Pipeline

- Next, push your code to Github.
- Run the pipeline using the Jenkinsfile. You will find the file at the root of the folder in this repository. All the stages in th pipeline has been defined in the Jenkinsfile.
- The configuration in the jenkinsfile will run the terraform file to build the eks clusters, deploy microservices application and my web application on the cluster using the manifests in the kubernete directory. It will also Expose the services of the applications and attach load balancers to each application. Finally It will output the load balancers' endpoints.

Here is an example of what the jenkins file looks like:

```bash
#!/usr/bin/env groovy
pipeline {
    agent any
    environment {
        AWS_ACCESS_KEY_ID = credentials('AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
        AWS_DEFAULT_REGION = "us-east-1"
    }
    stages {
        stage("Create an EKS Cluster") {
            steps {
                script {
                    dir('Terraform/eks') {
                        sh "terraform init"
                        sh "terraform apply -auto-approve"
                    }
                }
            }
        }  
        stage("Deploy to EKS") {
            steps {
                script {
                    dir('kubernetes') {
                        sh "aws eks --region us-east-1 update-kubeconfig --name Eks-cluster"
                        sh "kubectl apply -f complete-demo.yaml"
                        sh "kubectl apply -f web-deployment.yml"
                        sh "kubectl apply -f manifests-monitoring"
                    }
                }
            }
        }
    }
}

```

<br>

 Click on `Build now`. As the project rus you will see a stage view as shown below. You will also see the build number at the bottom under the `Build history` section.

![](images/JENKINS/jenkins-pipeline-success.png)

To see the console output and other information, click on the build number.

![](images/JENKINS/jenkins-pipeline-console-output.png)

![](images/JENKINS/pipeline-output2.png)
![](images/JENKINS/pipeline-output3.png)

![](images/JENKINS/jenkins-pipeline-steps.png)

![](images/JENKINS/jenkins-pipeline-myweb.png)

![](images/JENKINS/jenkins-pipeline-microservices.png)

<br>

### Final App output

![](images/APP/micoservices3.png)
![](images/APP/micoservices2.png)
![](images/APP/micoservices.png)
<br>

<br>

### Monitoring tools Output

### Prometheus

![](images/PROMETHEUS/prometheus-dashboard-status-targets-endpoints-pods2.png)
![](images/PROMETHEUS/prometheus-dashboard-status-targets-endpoints-pods.png)
![](images/PROMETHEUS/prometheus-dashboard-status-targets.png)
<br>

### Grafana

![](images/GRAFANA/grafana-query3.png)

<br>

## Resources

- [How to deploy EKS with terraform](https://www.techtarget.com/searchcloudcomputing/tutorial/How-to-deploy-an-EKS-cluster-using-Terraform)
- [https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_cluster)
- [https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_node_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_node_group)
- [Deploy EKS Cluster to AWS using Terraform](https://www.youtube.com/watch?v=yk_mm-hHirw&t=1s)
- [CICD Pipeline to deploy Kubernetes Applications using Terraform, EKS, and Jenkins](https://www.youtube.com/watch?v=Mp6prDOhVg8&t=33s)
- [https://github.com/frankisinfotech/terraform](https://github.com/frankisinfotech/terraform/blob/master/aws/eks/cluster.tf)
- [https://github.com/microservices-demo/microservices-demo.github.io](https://github.com/microservices-demo/microservices-demo.github.io)

## Author

- Linkedin - [Adetiba Daniel Timilehin](https://www.linkedin.com/in/daniel-adetiba-625ba7280/)
