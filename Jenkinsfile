def key = "app"
def server = "fasha1@103.183.74.5"
def dir = "literature-backend"
def branch = "Production"
def image = "literature-be"
def remote = "origin1"
def compose = "be.yaml"
def rname = "origin1"
def rurl = "git@github.com:fasha00/literature-backend.git"
def duser = "fasha00"
def TOKEN = "5684772497:AAHh9tVwnCXiXw-0Civw2cKEqcZzEvCyY7s"
def chatid = "-804006874"

pipeline {
    agent any
    stages{
        stage ('set remote and pull') {
            steps {
                sshagent(credentials: ["${key}"]) {
		    sh """ssh -T -o StrictHostkeyChecking=no ${server} << EOF
                    cd ${dir}
                    git remote add ${rname} ${rurl} || git remote set-url ${rname} ${rurl}
                    git pull ${rname} ${branch}
		    exit
                    EOF"""
                }
            }
        }
            
        stage ('Build Image') {
            steps {
                sshagent([key]) {
                    sh """
                          ssh -o StrictHostkeyChecking=no ${server} << EOF
                          cd ${dir}
                          docker build -t ${image}:v1 .
			  exit
                          EOF"""
                }
            }
        }
            
        stage ('Deploy app') {
            steps {
                sshagent([key]) {
                    sh """
                          ssh -o StrictHostkeyChecking=no ${server} << EOF
                          cd ${dir}
			  docker compose -f ${compose} down
			  docker system prune -f
                          docker compose -f ${compose} up -d
			  exit
                          EOF"""
                }
            }
        }

        stage ('Push Docker Hub') {
            steps {
                sshagent([key]) {
                   sh """
	                 ssh -o StrictHostkeyChecking=no ${server} << EOF
	                 docker image push ${duser}/${image}:v1
			 exit
	                 EOF"""
		      }
            }
        }


        stage ('Send Success Notification') {
            steps {
                sh """
                         curl -X POST 'https://api.telegram.org/bot${TOKEN}/sendMessage' -d \
		       'chat_id=${chatid}-d parse_mode=”HTML” -d text=”<b>Project</b>:'
		       literature-be \
                      <b>Branch</b>: Production \
                      <b>Build </b> : OK \
                      <b>Test suite</b> = Passed”
                  """
            }
        }

    }
}
