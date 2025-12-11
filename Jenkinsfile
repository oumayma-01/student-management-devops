//docker push change commit test
// This pipeline defines the CORE Continuous Integration (CI) process, including database interaction:
// 1. Git Checkout
// 2. Tool Verification
// 3. Build/Compile
// 4. SonarQube Static Analysis
// 5. Database Integration Tests (Docker)
// 6. Package Application
pipeline {
    // Define variables for SonarQube parameters for clarity
    environment {
        SONAR_PROJECT_KEY = 'student-management-key'
        SONAR_PROJECT_NAME = 'Student Management App'
    }

    // The pipeline can run on any available agent (your VM).
    agent any
    
    stages {
        stage('1. Git Checkout') {
            steps {
                echo 'Retrieving source code from GitHub...'
                git branch: 'main', 
                    url: 'https://github.com/oumayma-01/student-management-devops.git'
                sh 'echo " Source code successfully retrieved"'
            }
        }

        stage('2. Tool Verification') {
            steps {
                echo ' Verifying required tools (Maven, Docker, Java)...'
                sh 'ls -la'
                sh 'mvn --version'
                sh 'docker --version'
                sh 'java -version'
                sh 'echo " All tools are installed and verified"'
            }
        }

        stage('3. Build Application') {
            steps {
                echo ' Compiling the project with Maven...'
                sh 'mvn clean compile'
                sh 'echo " Application successfully compiled"'
            }
        }
        
        stage('4. SonarQube Analysis (Basic)') {
            steps {
                echo ' Executing basic SonarQube static code analysis...'
                withSonarQubeEnv('SonarQube-Local') { 
                    // This command uses the project key/name defined in the environment block.
                    sh "mvn sonar:sonar -Dsonar.projectKey=${SONAR_PROJECT_KEY} -Dsonar.projectName=\"${SONAR_PROJECT_NAME}\""
                }
                echo ' SonarQube analysis triggered. Check your SonarQube dashboard for results.'
            }
        }
        
        // --- STAGE 5: RESTORED DATABASE TESTS ---
        stage('5. Database Tests (Docker/MySQL)') {
            steps {
                echo ' Starting MySQL 8.0 container for integration tests...'
                sh '''
                    # Start a dedicated, isolated MySQL container for testing
                    docker run -d \\
                        --name test-mysql \\
                        -e MYSQL_ROOT_PASSWORD=root \\
                        -e MYSQL_DATABASE=student_db \\
                        -e MYSQL_USER=testuser \\
                        -e MYSQL_PASSWORD=testpass \\
                        -p 3306:3306 \\
                        mysql:8.0
                    
                    echo " Waiting 30 seconds for MySQL to start..."
                    sleep 30
                    
                    # Ping the database to ensure it's ready
                    docker exec test-mysql mysqladmin ping -h localhost -u root -proot || sleep 10
                    
                    echo " MySQL started and Database created: student_db"
                '''
                
                echo ' Executing integration tests with the database...'
                // Overrides application configuration to connect to the Docker container
                sh '''
                    mvn test \\
                        -Dspring.datasource.url=jdbc:mysql://localhost:3306/student_db \\
                        -Dspring.datasource.username=root \\
                        -Dspring.datasource.password=root \\
                        -Dspring.jpa.hibernate.ddl-auto=update \\
                        -Dspring.jpa.database-platform=org.hibernate.dialect.MySQL8Dialect
                '''
                
                sh 'echo " Tests executed successfully with database"'
            }
            post {
                // Actions that always run after the Tests stage, regardless of success/failure
                always {
                    junit 'target/surefire-reports/*.xml'
                    sh 'echo " JUnit test reports generated"'
                    
                    // Cleanup of the temporary database container (important for this stage)
                    sh '''
                        echo " Cleaning up MySQL container..."
                        docker stop test-mysql || true 
                        docker rm test-mysql || true 
                        echo " Test database cleaned up"
                    '''
                }
            }
        }
        
        // --- STAGE 6: RESTORED PACKAGE APPLICATION ---
        stage('6. Package Application') {
            steps {
                echo ' Creating the final JAR package (skipping tests)...'
                sh 'mvn package -DskipTests'
                
                echo ' Verifying created JAR artifacts...'
                sh 'ls -la target/*.jar'
                sh 'echo " JAR successfully created and ready for archival/deployment"'
            }
        }
    }
    
    // --- RESTORED GLOBAL POST BLOCK (MANDATORY FOR CLEANUP) ---
    post {
        always {
            echo ' Pipeline execution finished. Final cleanup verification.'
            // Safety measure to ensure container is removed even if a preceding step failed to clean up
            sh '''
                echo " Final container cleanup (safety)..."
                docker stop test-mysql || true
                docker rm test-mysql || true
            '''
        }
        success {
            echo ' SUCCESS! CI Pipeline completed successfully!'
            // Archive the artifact so it can be downloaded from the Jenkins dashboard
            archiveArtifacts artifacts: 'target/*.jar', fingerprint: true
            sh 'echo " JAR archived - Ready for future deployment (CD)"'
        }
        failure {
            echo ' Pipeline FAILED! Check the logs for details.'
        }
        cleanup {
            sh 'echo " Post-build cleanup phase completed."'
        }
    }
}
