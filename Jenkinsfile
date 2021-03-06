pipeline {

  agent any

  stages {

    stage('Checkout Source') {
      steps {
        git url:'https://github.com/kairemor/spring-boot-dockerise.git', branch:'master'
      }
    }
    
    // stage('Sonarqube code quality test'){
    //   steps {
    //     script {
    //       sh 'mvn sonar:sonar \
    //                                                   -Dsonar.projectKey=demo-project \
    //                                                   -Dsonar.host.url=http://localhost:9000 \
    //                                                   -Dsonar.login=d28c71e7d3049c3eb5478b36cfef8ccf620cd307'
    //     }
    //   }
    // }
    
    stage("Build jar file"){
      steps {
        script {
	        sh 'mvn clean install'
        }
      }
    }

    stage("Build Docker  image") {
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

  stage("Docker image remove local") {
    steps {
      script {
        sh 'docker rmi registry.hub.docker.com/kairemor/spring-boot:latest'
      }      
    }
  }

  stage("Kubernetes remove previous deploiment ") {
    steps {
      script {
        sh 'kubectl delete deployments.v1.apps gs-spring-boot-docker'
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
