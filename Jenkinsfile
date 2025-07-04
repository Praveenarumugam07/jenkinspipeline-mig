pipeline {
    agent any

    environment {
        PROJECT_ID = 'qwiklabs-gcp-01-b75146721872'
        REGION = 'europe-west1-b'
        TEMPLATE = 'flask-template'
        MIG = 'flask-mig'
        SERVICE_ACCOUNT_KEY = credentials('gcp-service-account-json') // Jenkins secret id for GCP key
    }

    stages {

        stage('Dev: Checkout Code') {
            steps {
                git url: 'https://github.com/Praveenarumugam07/jenkinspipeline-mig.git', branch: 'main'
            }
        }

        stage('Test: Install and Test Locally') {
            steps {
                sh '''
                sudo apt update
                sudo apt install -y python3-pip
                pip3 install -r requirements.txt
                python3 app.py &
                sleep 5
                curl http://localhost
                pkill python3
                '''
            }
        }

        stage('Deploy: Update MIG Template') {
            steps {
                withCredentials([file(credentialsId: 'gcp-service-account-json', variable: 'GOOGLE_APPLICATION_CREDENTIALS')]) {
                    sh '''
                    gcloud auth activate-service-account --key-file=$GOOGLE_APPLICATION_CREDENTIALS
                    gcloud config set project $PROJECT_ID

                    # Build a new instance template with timestamp for rolling update
                    NEW_TEMPLATE=flask-template-$(date +%Y%m%d%H%M%S)
                    gcloud compute instance-templates create $NEW_TEMPLATE \
                        --source-instance-template=$TEMPLATE \
                        --metadata=startup-script="$(cat startup.sh)"

                    # Update MIG with new template
                    gcloud compute instance-groups managed rolling-action start-update $MIG \
                        --version=template=$NEW_TEMPLATE \
                        --region=$REGION

                    echo "Deployment completed with template $NEW_TEMPLATE"
                    '''
                }
            }
        }
    }
}
