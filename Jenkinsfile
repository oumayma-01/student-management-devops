pipeline {
    agent any
    
    tools {
        maven 'Maven'
        jdk 'JDK'
    }
    
    stages {
        stage('Git Checkout') {
            steps {
                echo 'Récupération du code source depuis GitHub...'
                checkout scm
            }
        }
        
        stage('Maven Build') {
            steps {
                echo 'Compilation du projet avec Maven (sans tests)...'
                sh 'mvn clean compile -DskipTests'
            }
        }
        
        stage('Maven Package') {
            steps {
                echo 'Packaging du projet...'
                sh 'mvn package -DskipTests'
            }
        }
    }
    
    post {
        success {
            echo 'Build réussi ! ✅'
        }
        failure {
            echo 'Build échoué ! ❌'
        }
    }
}
