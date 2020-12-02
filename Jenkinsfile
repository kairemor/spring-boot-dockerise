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
    
    stage("Kubernetes deploiment and service") {
      steps {
        script {
          sh 'kubectl apply -f spring-deploiment.yaml'
          sh 'kubectl apply -f spring-service.yaml'
        }
      }
    }

    stage("Kubernetes service"){
      steps {
        script {
          sh 'kubectl get service'
        }	
      }
    }
  }
}
