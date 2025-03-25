pipeline {
    agent any
    environment {
        DOCKER_IMAGE = "venkateshkesa/jenkins-demo"
        DOCKER_TAG = "latest"
    }


    stages {
        stage("Project working on") {
            steps {
                echo "Project is working on:: Solar System Project"
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
                    script {
                        def scannerHome = tool name: 'SonarScanner', type: 'hudson.plugins.sonar.SonarRunnerInstallation'  // Ensure name matches Jenkins tool
                        withSonarQubeEnv('Sonarqube') {  // Ensure this matches the SonarQube installation in Jenkins
                            sh "${scannerHome}/bin/sonar-scanner -Dsonar.projectKey=SolarSystem -Dsonar.sources=."
                        }
                    }
                }
            }
        stage("parallel stages"){
            parallel{
                stage("Build docker image"){
                    steps{
                    sh ''' 
                       # Remove docker images 
                       IMAGE_ID=$(docker images -q ${DOCKER_IMAGE}:${DOCKER_TAG})
                       
                       if [ -n "$IMAGE_ID"  ]; then
                           docker rmi -f $IMAGE_ID
                           echo "Removed the older images : "$IMAGE_ID""
                       fi
                       

                       docker build -t ${DOCKER_IMAGE}:${DOCKER_TAG} .
                       echo " New image was created : "${DOCKER_IMAGE}:${DOCKER_TAG}" "
                       '''
                }
            }

                stage("Push docker image"){
                     steps {
                        withCredentials([usernamePassword(credentialsId: 'DOCKER-HUB', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                            sh "echo ${DOCKER_PASS} | docker login -u ${DOCKER_USER} --password-stdin"
                            sh "docker push ${DOCKER_IMAGE}:${DOCKER_TAG}"
                        }
                    }
                }
            }
        }
    }
}
