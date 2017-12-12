pipeline {
  agent none

  stages{
    agent { label 'tf'}
    stage('tools check'){
      steps{
          sh 'git --version'
          sh 'terraform --version'

      }
    }

    stage('validate & plan infra') {
      agent { label 'tf'}
      steps {
          withCredentials([file(credentialsId:'terraform-live', variable: 'secrets')]){
            sh 'terraform init -upgrade=true infrastructure'
            sh 'terraform get -update infrastructure'
            sh 'terraform validate -var-file=%secrets% infrastructure'
            sh '''
              terraform plan -detailed-exitcode -out="plan.out" -var-file="%secrets%" infrastructure
              set status=%errorLevel%
              echo "%status%" > status
              if "%status%" equ "1" (echo "Plan Failed" & EXIT /b 1)
            '''
            sh 'echo "%status%"'

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
