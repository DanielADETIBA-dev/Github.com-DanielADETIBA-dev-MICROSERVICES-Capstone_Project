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
                        sh "sleep 120s"
                        sh "kubectl get deployment -n sock-shop"
                        sh "kubectl get svc -n sock-shop"
                        sh "kubectl get deployment -n web"
                        sh "kubectl get svc -n web"
                        sh "sleep 60s"
                        sh "kubectl get deployment -n monitoring"
                        sh "kubectl get svc -n monitoring"
                    }
                }
            }
        }
    }
}

// stage("Destroy EKS Cluster") {
//             when {
//                 expression {
//                     params.DESTROY_CLUSTER == false
//                 }
//             }
//             steps {
//                 script {
//                     dir('Terraform/eks') {
//                         sh "terraform destroy -auto-approve"
//                     }
//                 }
//             }
//         }
//     }
// }



