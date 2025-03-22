pipeline{
    agent any
    stages{
        stage("Project working on"){
            steps{
                echo "Project is working on : solar system"
            }   
        }
        stage("Project building "){
            steps{
                echo "1.Install Dependencies , 2.Dependencies scanning , 3.OWASP Dependency Check  4.Unit Testing 5.Code Coverage 6.SAST - SonarQube" 
            }   
        }
        stage("installing dependencies"){
            steps{
                sh 'npm install'
                sh 'node -v '
                sh 'npm -v'
                echo "Dependencies installed successfully"
            }   
        }
        stage("dependencies scanning"){
            steps{
                sh 'npm audit'
                echo "Dependencies Scanned  successfully"
            }   
        }  
         stage("OWASP Dependency Check"){
            steps{
                dependencyCheck additionalArguments: 
                '''--scan	--format ALL	--project	Workspace''',
                nvdCredentialsId: 'OWAP-CRED', odcInstallation: '12.1.0', skipOnScmChange: true                
                echo "OWASP Dependency Check completed successfully"

            }   
        }
    }
}

                
