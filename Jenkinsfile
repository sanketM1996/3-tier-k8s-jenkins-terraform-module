
pipeline {
    agent any

    tools {
        nodejs 'nodejs23'
    }

    environment {
        SCANNER_HOME = tool 'sonar-scanner'
    }

    stages {

        stage('Git Checkout') {
            steps {
                git branch: 'main',
                    url: 'https://github.com/sanketM1996/3-tier-k8s-jenkins-terraform-module.git'
            }
        }

        stage('Frontend Compilation') {
            steps {
                dir('client') {
                    sh 'find . -name "*.js" -exec node --check {} +'
                }
            }
        }

        stage('Backend Compilation') {
            steps {
                dir('api') {
                    sh 'find . -name "*.js" -exec node --check {} +'
                }
            }
        }

        stage('GitLeaks Scan') {
            steps {
                sh 'gitleaks detect --source ./client --exit-code 1'
                sh 'gitleaks detect --source ./api --exit-code 1'
            }
        }

        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv('sonar') {
                    sh '''
                        $SCANNER_HOME/bin/sonar-scanner \
                            -Dsonar.projectName=NodeJS-Project \
                            -Dsonar.projectKey=NodeJS-Project
                    '''
                }
            }
        }

        stage('Quality Gate Check') {
            steps {
                timeout(time: 1, unit: 'HOURS') {
                    waitForQualityGate(
                        abortPipeline: false,
                        credentialsId: 'sonar-token'
                    )
                }
            }
        }

        stage('Trivy FS Scan') {
            steps {
                sh 'trivy fs --format table -o fs-report.html .'
            }
        }

        stage('Build-Tag & Push Backend Docker Image') {
            steps {
                script {
                    withDockerRegistry(credentialsId: 'docker-cred') {
                        dir('api') {
                            sh '''
                                docker build \
                                    -t sanketmahajan/3tierjenkinsbackend:latest .

                                trivy image \
                                    --format table \
                                    -o backend-image-report.html \
                                    sanketmahajan/3tierjenkinsbackend:latest

                                docker push \
                                    sanketmahajan/3tierjenkinsbackend:latest
                            '''
                        }
                    }
                }
            }
        }

        stage('Build-Tag & Push Frontend Docker Image') {
            steps {
                script {
                    withDockerRegistry(credentialsId: 'docker-cred') {
                        dir('client') {
                            sh '''
                                docker build \
                                    -t sanketmahajan/3tierjenkinsfrontend:latest .

                                trivy image \
                                    --format table \
                                    -o frontend-image-report.html \
                                    sanketmahajan/3tierjenkinsfrontend:latest

                                docker push \
                                    sanketmahajan/3tierjenkinsfrontend:latest
                            '''
                        }
                    }
                }
            }
        }
        stage('Manual Approval for Production') {
            steps {
                timeout(time: 1, unit: 'HOURS') {
                    input message: 'Approve deployment to PRODUCTION?', ok: 'Deploy'
                }
            }
        }
        stage('K8s Deployment') {
            steps {
                script {
                    withKubeConfig(
                        caCertificate: '',
                        clusterName: 'ecommerce-dev-eks',
                        contextName: '',
                        credentialsId: 'k8-token',
                        namespace: 'prod',
                        restrictKubeConfigAccess: false,
                        serverUrl: 'https://2C5F0D0E728A1371C4944AF8EDB60D64.gr7.ap-south-1.eks.amazonaws.com'
                    ) {
                        sh 'kubectl apply -k k8s/'
                        sleep 30
                    }
                }
            }
        }
    }
}



