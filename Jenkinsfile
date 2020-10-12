node{
    
    def mavenHome = tool name: 'maven', type: 'maven'
    def mavenCMD = "${mavenHome}/bin/mvn"
    
    stage('Git Checkout'){
        checkout([$class: 'GitSCM', branches: [[name: '*/master']], doGenerateSubmoduleConfigurations: false, extensions: [], submoduleCfg: [], userRemoteConfigs: [[url: 'https://github.com/saylikale/Spring-Boot-Mongo-Microservices.git']]])
    }
   
   /*
    stage('SonarQube Report Execution'){
        sh "${mavenCMD} clean sonar:sonar"
    }
    */
	
    stage('Packaging of the code'){
        sh "${mavenCMD} clean package"
    }
    
    stage('Docker Build Image and Push to Nexus'){
        sh "docker build -t 35.154.42.145:10001/spring-boot-mongo:${BUILD_NUMBER} ."
        withCredentials([string(credentialsId: 'nexus_dockerrepo_pwd', variable: 'nexus_dockerrepo_pwd')]) {
            sh "docker login -u sayali --password-stdin ${nexus_dockerrepo_pwd} 35.154.42.145:10001"    
        }
		sh "docker push 35.154.42.145:10001/spring-boot-mongo:${BUILD_NUMBER}"
    }
	
	stage('Remove local Image from Jenkins Server'){
		sh "docker rmi -f 35.154.42.145:10001/spring-boot-mongo:${BUILD_NUMBER}"
	}
	
	stage('Deploy to Docker Swarm Cluster'){
	sshagent(['swarm_ssh_pwd']) {
		withCredentials([string(credentialsId: 'nexus_dockerrepo_pwd', variable: 'nexus_dockerrepo_pwd')]) {
                        sh "scp -o StrictHostKeyChecking=no docker-compose.yml ubuntu@15.206.203.210"
			sh "ssh -o StrictHostKeyChecking=no ubuntu@15.206.203.210 docker login -u sayali -p ${nexus_dockerrepo_pwd} http://35.154.42.145:10001/repository/spring-boot-mongo/"
			sh "ssh -o StrictHostKeyChecking=no ubuntu@15.206.203.210 buildNo=${BUILD_NUMBER} docker stack deploy --prune --compose-file docker-compose.yml springboot ${buildNo} --with-registry-auth"
    }
	}
	}
}
