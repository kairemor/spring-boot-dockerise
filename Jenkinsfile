pipeline {

  agent any

  stages {

    stage('Checkout Source') {
      steps {
        git url:'https://github.com/kairemor/spring-boot-dockerise.git', branch:'master'
      }
    }
    
      stage("Build image") {
            steps {
                script {
                    myapp = docker.build("kairemor/spring-boot:${env.BUILD_ID}")
                }
            }
        }
    
      stage("Push image") {
            steps {
                script {
                    docker.withRegistry('https://registry.hub.docker.com', 'dockerhub') {
                            myapp.push("latest")
                            myapp.push("${env.BUILD_ID}")
                    }
                }
            }
        }

    
    stage('Deploy App') {
      steps {
        script {
          kubernetesDeploy(configs: "hellowhale.yaml", kubeconfigId: "kubeconfigazure")
        }
      }
    }

  }

}
