pipeline {
    agent any

    environment {
        PROJECT_ID = 'qwiklabs-gcp-01-dc65655def10'
        REGION = 'europe-west1' // e.g. asia-south1
        TEMPLATE_NAME = 'flask-template'
        MIG_NAME = 'flask-mig'
    }

    stages {

        stage('Clone Repository') {
            steps {
                git credentialsId: 'github-creds', url: 'https://github.com/Praveenarumugam07/jenkinspipeline-mig.git', branch: 'main'
            }
        }

        stage('Build') {
            steps {
                sh '''
                echo "No build step needed for Python app."
                '''
            }
        }

        stage('Test') {
            steps {
                sh '''
                echo "Testing syntax"
                python3 -m py_compile app.py
                '''
            }
        }

        stage('Deploy to GCP') {
            steps {
                sh '''
                echo "Creating instance template with startup script"

                gcloud compute instance-templates create $TEMPLATE_NAME \
                  --project=$PROJECT_ID \
                  --machine-type=e2-micro \
                  --metadata-from-file startup-script=startup-script.sh \
                  --tags=http-server \
                  --region=$REGION

                echo "Creating managed instance group using the template"

                gcloud compute instance-groups managed create $MIG_NAME \
                  --project=$PROJECT_ID \
                  --base-instance-name=flask-instance \
                  --size=1 \
                  --template=$TEMPLATE_NAME \
                  --region=$REGION

                echo "Deployment completed."
                '''
            }
        }
    }

    post {
        success {
            echo 'Pipeline executed successfully!'
        }
        failure {
            echo 'Pipeline failed. Check logs.'
        }
    }
}
