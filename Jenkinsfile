def key = "app"
def server = "fasha1@103.183.74.5"
def dir = "literature-backend"
def branch = "Production"
def image = "fasha00/literature-be"
def remote = "origin1"
def compose = "be.yaml"
def rname = "origin1"
def rurl = "git@github.com:fasha00/literature-backend.git"
def TOKEN = "5684772497:AAHh9tVwnCXiXw-0Civw2cKEqcZzEvCyY7s"
def chatid = "-804006874"

pipeline {
    agent any
    stages{
        stage ('set git remote and pull app') {
            steps {
                sshagent([key]) {
		    sh """ssh -T -o StrictHostkeyChecking=no ${server} << EOF
                    cd ${dir}
                    git remote add ${rname} ${rurl} || git remote set-url ${rname} ${rurl}
                    git pull ${rname} ${branch}
		    exit
                    EOF"""
                }
            }
        }
            
        stage ('build image') {
            steps {
                sshagent([key]) {
                    sh """ssh -o StrictHostkeyChecking=no ${server} << EOF
                          cd ${dir}
                          docker build -t ${image}:v1 .
			  exit
                          EOF"""
                }
            }
        }
            
        stage ('deploy app') {
            steps {
                sshagent([key]) {
                    sh """ssh -o StrictHostkeyChecking=no ${server} << EOF
                          cd ${dir}
			  docker compose -f ${compose} down
			  docker system prune -f
                          docker compose -f ${compose} up -d
			  exit
                          EOF"""
                }
            }
        }

        stage ('push docker') {
            steps {
                sshagent([key]) {
                   sh """ssh -o StrictHostkeyChecking=no ${server} << EOF
	                 docker image push ${image}:v1
			 exit
	                 EOF"""
		      }
            }
        }


        stage ('Send Success Notification') {
            steps {
                sh """
                        curl -X POST 'https://api.telegram.org/bot${TOKEN}/sendMessage' -d \
		      'chat_id=${chatid}&text=Build Number #${env.BUILD_NUMBER} literature success !'
                  """
            }
        }

    }
}
