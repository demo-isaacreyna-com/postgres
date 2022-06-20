pipeline {

    agent {
        label 'master'
    }

    options {
        skipDefaultCheckout(true)
    }

    environment {
        GIT_BRANCH = 'main'
        CREDENTIALS_GITHUB = 'github-isaacdanielreyna'
        GIT_URL = 'https://github.com/demo-isaacreyna-com/postgres.git'
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

        stage('Git Checkout') {
            steps {
                script {
                    // Determine if feature branch or a pull request
                    if (env.CHANGE_BRANCH) {
                        GIT_BRANCH = env.CHANGE_BRANCH
                    } else if (env.BRANCH_NAME) {
                        GIT_BRANCH = env.BRANCH_NAME
                    }
                }
                echo "GIT_BRANCH: ${GIT_BRANCH}"
                git branch: "${GIT_BRANCH}",
                credentialsId: "${CREDENTIALS_GITHUB}",
                url: "${GIT_URL}"
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