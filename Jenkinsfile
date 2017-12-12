pipeline {
  agent none

  stages{
    stage('tools check'){
      agent { label 'tf'}
      steps{
          sh 'git --version'
          sh 'terraform --version'

      }
    }

    stage('validate & plan infra') {
      agent { label 'tf'}
      steps {
          withCredentials([file(credentialsId:'terraform-secrets', variable: 'secrets')]){
            sh 'terraform init -upgrade=true infrastructure'
            sh 'terraform get -update infrastructure'
            sh 'terraform validate -var-file=$secrets infrastructure'
            sh '''
              terraform plan -detailed-exitcode -out="plan.out" -var-file="$secrets" infrastructure || true
              status=$?
              echo "$status" > status

              if [ $? -eq 1 ]
              then
                echo "Terraform Plan Failed"
                exit 1
              fi

            '''
            sh 'echo "$status"'

            stash name: "plan", includes: "plan.out"
            stash name: "status", includes: "status"
          }
      }
    }

    stage('apply infra'){
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

    stage('test infra'){
      agent { label 'tf' }
      steps {
        sh 'echo todo'
      }
    }

  }
}
