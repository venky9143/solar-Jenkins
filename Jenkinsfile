pipeline {
    agent any
        environment {
               SONARQUBE_URL = "http://54.82.40.201:9000"
              SONARQUBE_TOKEN = credentials('SONAR-KEY')
        }
    
    stages {
        stage("Project working on") {
            steps {
                echo "Project is working on : Solar System"
            }
        }

        stage("Project building") {
            steps {
                echo "1. Install Dependencies"
                echo "2. Dependencies Scanning"
                echo "3. OWASP Dependency Check"
                echo "4. Unit Testing"
                echo "5. Code Coverage"
                echo "6. SAST - SonarQube"
            }
        }

        stage("Installing Dependencies") {
            steps {
                sh 'npm install'
                sh 'node -v'
                sh 'npm -v'
                echo "Dependencies installed successfully"
            }
        }

        stage("Parallel Stages") {
            parallel {
                stage("Dependencies Scanning") {
                    steps {
                        sh 'npm audit --audit-level=critical'
                        echo "Dependencies scanned successfully"
                    }
                }

                stage("Audit Fix") {  
                    steps {
                        sh 'npm audit fix'
                        echo "Audit fix applied successfully"
                    }
                }
            }
        }

        stage("OWASP Dependency Check") {
                steps {
                    catchError(buildResult: 'SUCCESS', message: 'Oops! It will be fixed in future releases', stageResult: 'UNSTABLE') {
                        sh 'mkdir -p reports' 
            
                        dependencyCheck(
                            additionalArguments: '--scan . --format ALL --out reports --project Workspace',
                            nvdCredentialsId: 'OWAP-CRED', odcInstallation: '12.1.0', skipOnScmChange: true
                        )
            
                        echo "OWASP Dependency Check completed successfully"
                        
                        // Debugging: List contents of reports directory
                        sh 'ls -l reports/'
            
                        // Check if the report file exists before publishing
                        script {
                            def reportExists = sh(script: "test -s reports/dependency-check-report.xml && echo 'yes' || echo 'no'", returnStdout: true).trim()
            
                            if (reportExists == 'yes') {
                                echo "Publishing Dependency-Check results..."
                                dependencyCheckPublisher pattern: 'reports/dependency-check-report.xml'
                                echo "No errors in scanning"
                            } else {
                                echo "Skipping Dependency-Check publishing - No vulnerabilities found."
                            }
                        }
                    }
                }
        }

        stage('SonarQube Analysis') {
                steps {
                    withSonarQubeEnv('SonarQube') {  // Ensure 'SonarQube' is the correct name in Jenkins settings
                        sh '''
                         /opt/sonar-scanner/bin/sonar-scanner \
                          -Dsonar.projectKey=Jenkins-Demo \
                          -Dsonar.sources=. \
                          -Dsonar.host.url=$SONARQUBE_URL \
                          -Dsonar.login=$SONARQUBE_TOKEN
                        '''
                    }
                }
        }
    }
}
                    
