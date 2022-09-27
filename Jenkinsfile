def key= "fasha1"
def server= "fasha1@103.183.74.5"
def dir= "literature-backend"
def branch= "production"
def image= "fasha00/literature-be:v1"
def remote= "origin1"
def compose= "be.yaml"

pipeline{
 agent any
 stages{
  stage ('down compose & pull'){
   steps{
     sshagent ([key]) {
       sh """ssh -o StrictHostkeyChecking=0 ${server} << EOF
       cd ${directory}
       sudo docker compose -f ${compose} down
       sudo docker system prune -f
       git pull ${remote} ${branch}
       exit
       EOF"""

   stage ('build'){
    steps{
    sshagent ([key]) {
    sh """ssh -o StrictHostkeyChecking=0 ${server} << EOF
    cd ${dir}
    sudo docker build -t ${image} .
    exit
    EOF"""

   stage ('run') {
    steps{
     sshagent ([credential]) {
     sh """ssh -o StrictHoskeyChecking=0 ${server} << EOF
     cd {dir}
     sudo docker compose -f ${compose} up -d
     exit
     EOF"""

  stage ('docker push'){
   steps{
    sshagent ([key]) {
    sh """ssh -o StrictHostkeyChecking=0 ${server} << EOF
    sudo docker push ${image}
    exit
    EOF"""

    }


   }
  }
  }

     }


    }


   }
  
    }
    }


   }
  

     }
    
    }
     
  }
 }
  	
