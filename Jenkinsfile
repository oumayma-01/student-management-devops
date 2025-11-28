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
                echo 'Compilation du projet avec Maven...'
                sh 'mvn clean compile'
            }
        }
        
        stage('Maven Test') {
            steps {
                echo 'Exécution des tests unitaires...'
                sh 'mvn test'
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
