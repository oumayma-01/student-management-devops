pipeline {
    agent any
    
    tools {
        maven 'Maven'  // Nom de Maven configuré dans Jenkins
        jdk 'JDK'      // Nom du JDK configuré dans Jenkins
    }
    
    stages {
        stage('Git Checkout') {
            steps {                echo 'Récupération du code source depuis GitHub...'
                git branch: 'main', 
                    url: 'https://github.com/oumayma-01/student-management-devops.git'
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
