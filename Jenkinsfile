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
                    sh 'docker run -d --network=demo_network --env POSTGRES_HOST=postgres --env POSTGRES_USER=$POSTGRES_USER --env POSTGRES_PASSWORD=$POSTGRES_PASSWORD --env POSTGRES_DB=demo --name $CONTAINER_NAME -p $EXTERNAL_PORT:$INTERNAL_PORT -t $IMAGE:$TAG'
                }
            }
        }
    }

    post {
        always {
            sh 'docker logout'

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