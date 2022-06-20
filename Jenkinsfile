pipeline {

    agent {
        label 'master'
    }

    options {
        skipDefaultCheckout(true)
    }

    environment {
        IMAGE = 'postgres'
        TAG = '13'
        CONTAINER_NAME = 'postgres'
        EXTERNAL_PORT = '5432'
        INTERNAL_PORT = '5432'
    }

    stages {
        stage('Reset Workspace') {
            steps {
                deleteDir()
                sh 'ls -al'
            }
        }

        stage('Deploy Container') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'demo-postgres-credentials', usernameVariable: 'POSTGRES_USER', passwordVariable: 'POSTGRES_PASSWORD')]) {
                    sh './deploy.sh ${IMAGE} ${TAG} ${CONTAINER_NAME} ${EXTERNAL_PORT} ${INTERNAL_PORT} ${POSTGRES_USER} ${POSTGRES_PASSWORD}'
                }
            }
        }
    }

    post {
        always {
            echo 'Delete the following files'
            sh 'ls -hal'
            deleteDir()
            sh 'ls -hal'
        }
        
        success {
            echo "Job Succeded"
        }

        unsuccessful {
            echo 'Job Failed'
        }
    }
}