pipeline {
  agent none

  stages{
    stage('tools check'){
      steps{
          bat 'git --version'
          bat 'terraform --version'
      }
    }

    stage('validate & plan infra') {
      agent { label 'tf'}
      steps {
          withCredentials([file(credentialsId:'terraform-live', variable: 'secrets')]){
            bat 'terraform init -upgrade=true infrastructure'
            bat 'terraform get -update infrastructure'
            bat 'terraform validate -var-file=%secrets% infrastructure'
            bat '''
              terraform plan -detailed-exitcode -out="plan.out" -var-file="%secrets%" infrastructure
              set status=%errorLevel%
              echo "%status%" > status
              if "%status%" equ "1" (echo "Plan Failed" & EXIT /b 1)
            '''
            bat 'echo "%status%"'

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
        bat 'terraform apply plan.out'
      }
    }

    stage('test infra'){
      steps {
        bat 'echo todo'
      }
    }

    stage('plan provisioning'){
      steps {
        bat 'echo todo'
      }
    }

    stage('apply provisioning'){
      steps {
        bat 'echo todo'
      }
    }

    stage('test provisioning'){
      steps {
        bat 'echo todo'
      }
    }


  }
}
