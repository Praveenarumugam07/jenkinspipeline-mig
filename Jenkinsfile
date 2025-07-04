pipeline {
    agent any

    environment {
        PROJECT_ID = "qwiklabs-gcp-01-dc65655def10"
        REGION = "europe-west1"
        MIG_NAME = "flask-mig"
        TEMPLATE_NAME = "flask-template"
        BASE_INSTANCE_NAME = "flask-instance"
    }

    stages {
        stage('Build') {
            steps {
                echo "✅ No build step needed for Python Flask app."
            }
        }

        stage('Test') {
            steps {
                echo "🔍 Testing Python syntax in app.py"
                sh 'python3 -m py_compile app.py'
            }
        }

        stage('Deploy to GCP') {
            steps {
                echo "🚀 Deploying to GCP Managed Instance Group using existing instance template"

                script {
                    def migExists = sh(
                        script: "gcloud compute instance-groups managed list --project=${PROJECT_ID} --regions=${REGION} --filter=\"name=(${MIG_NAME})\" --format=\"value(name)\"",
                        returnStdout: true
                    ).trim()

                    if (migExists) {
                        echo "🔄 MIG '${MIG_NAME}' exists. Updating with new template..."
                        sh """
                            gcloud compute instance-groups managed rolling-action replace ${MIG_NAME} \\
                              --project=${PROJECT_ID} \\
                              --region=${REGION} \\
                              --version=template=${TEMPLATE_NAME}
                        """
                    } else {
                        echo "✨ Creating new MIG '${MIG_NAME}'..."
                        sh """
                            gcloud compute instance-groups managed create ${MIG_NAME} \\
                              --project=${PROJECT_ID} \\
                              --base-instance-name=${BASE_INSTANCE_NAME} \\
                              --template=${TEMPLATE_NAME} \\
                              --size=1 \\
                              --region=${REGION}
                        """
                    }
                }
            }
        }
    }

    post {
        success {
            echo "✅ Pipeline completed successfully. Flask app deployed on MIG."
        }
        failure {
            echo "❌ Pipeline failed. Check logs for details."
        }
    }
}
