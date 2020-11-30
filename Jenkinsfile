pipeline{
  environment {
    scannerHome = tool 'SonarQubeScanner'
    registry = "simhalp9/springali"
    registryCredential = 'dockerhub'
    dockerImage = ''
  }
  agent any
    stages {
        stage('clean') {
            steps {
                bash 'mvn clean'
            }
        }
        stage('build and test') {
            steps {
                bash 'mvn package'
            }
        }
        stage('Sonarqube') {
 
            steps {
              script {
                  withSonarQubeEnv('sonarqube') {
                  bash "${scannerHome}/bin/sonar-scanner"
                    }
                  }
               }
          }
        stage("SonarQube Quality Gate"){
          steps {
            script {
               timeout(time: 5, unit: 'MINUTES') { 
               def qualitygate = waitForQualityGate() 
               if (qualitygate.status != 'OK') {
               abortPipeline:true
               error "Pipeline aborted due to quality gate failure:   ${qualitygate.status}"
                 }
               else {
               echo "Quality gate passed"
                  }
              }
           }
         }
       }
        stage('Building image') {
            steps{
                script {
                  dockerImage = docker.build registry + ":$BUILD_NUMBER"
                }
             }
          }
          stage('Push Image') {
              steps{
                  script {
                      docker.withRegistry( '', registryCredential )    {
                        dockerImage.push()
                      }
                  }
              }
            }
      
  }
}
