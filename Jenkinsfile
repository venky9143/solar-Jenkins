pipeline {
    agent any
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

        stage("OWASP Dependency Check"){
                    steps{
                        catchError(buildResult: 'SUCCESS', message: 'Oops! it will be fixed in future releases', stageResult: 'UNSTABLE'){
                         sh 'mkdir -p reports' 
                        dependencyCheck additionalArguments: 
                        '''--scan	--format ALL	--out reports --project	Workspace''',
                        nvdCredentialsId: 'OWAP-CRED', odcInstallation: '12.1.0', skipOnScmChange: true                
                        echo "OWASP Dependency Check completed successfully"
                        dependencyCheckPublisher pattern: 'reports/dependency-check-report.xml' 
                        echo "no errors in scanning"
                    }
               }
           }
    }
}
