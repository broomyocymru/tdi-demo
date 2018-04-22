pipeline {
  agent none

  stages{
    stage('tools check'){
      agent { label 'tf'}
      steps{
          sh 'git --version'
          sh 'terraform --version'
          sh 'inspec --version'
      }
    }

    stage('infra - validate & plan') {
      agent { label 'tf'}
      steps {
          withCredentials([file(credentialsId:'terraform-secrets', variable: 'secrets')]){
            sh 'terraform init -upgrade=true infrastructure'
            sh 'terraform get -update infrastructure'
            sh 'terraform validate -var-file=$secrets infrastructure'
            sh '''
              set +e
              terraform plan -detailed-exitcode -out="plan.out" -var-file="$secrets" infrastructure
              status=$?
              set -e

              echo $status > status

              if [ $? -eq 1 ]
              then
                echo "Terraform Plan Failed"
                exit 1
              fi

            '''

            stash name: "plan", includes: "plan.out"
            stash name: "status", includes: "status"
          }
      }
    }

    stage('infra apply'){
      agent { label 'tf' }
      when {
        expression { readFile('status').trim().contains("2")}
      }
      steps {
        unstash 'plan'
        timeout(time: 24, unit:'HOURS'){
          input 'Do you want to apply changes?'
        }
        sh 'terraform apply plan.out'
      }
    }

    stage('infra sign-off') {
      steps {
        parallel(
          stage('infra tests'){
            agent { label 'tf' }
            steps {
              withCredentials([file(credentialsId:'inspec-secrets', variable: 'secrets')]){
                sh 'AZURE_CREDS_FILE=$secrets inspec exec tests/demo-profile'
              }
            }
          }

          stage('infra report'){
            agent { label 'tf' }
            steps {
              echo 'todo - generate report'
            }
          }
        )
      }
    }

    stage('provisioning - apply'){
      agent { label 'tf'}
      steps{
          echo 'todo - install software'
      }
    }

    stage('provisioning sign-off') {
      steps {
        parallel(
          stage('provisioning tests'){
            agent { label 'tf' }
            steps {
              echo 'todo - provision software'
            }
          }

          stage('provisioning report'){
            agent { label 'tf' }
            steps {
              echo 'todo - generate report'
            }
          }
        )
      }
    }

  }
}
