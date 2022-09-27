def key = 'backend'
def ip = "fasha3@103.186.1.224"
def dir = "literature-backend"
def branch = "Production"
def image = "fasha00/literature-be:v1"
def remote = "origin1"
def compose = "be.yaml"
def rname = "origin1"
def rurl = "git@github.com:fasha00/literature-backend.git"
def duser = "fasha00"
def username = "fasha3"

pipeline {
    agent any
    stages{
        stage ('set remote and pull') {
            steps {
                sshagent(credentials: ["${key}"]) {
		    sh """ssh -o StrictHostKeyChecking=no ${ip} << EOF
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
                sshagent ([key]) {
                    sh """
                          ssh -o StrictHostkeyChecking=no ${server} << EOF
                          cd ${dir}
                          docker build -t ${imagename}:v1 .
                          EOF"""
                }
            }
        }
            
        stage ('Deploy app') {
            steps {
                sshagent ([key]) {
                    sh """
                          ssh -o StrictHostkeyChecking=no ${server} << EOF
                          cd ${dir}
                          docker compose -f ${compose} down
                          docker compose -f ${compose} up -d
                          EOF"""
                }
            }
        }

        stage ('Push Docker Hub') {
            steps {
                sshagent ([key]) {
                   sh """
	                 ssh -o StrictHostkeyChecking=no ${server} << EOF
	                 docker image push ${duser}/${image}
	                 EOF"""
		      }
            }
        }


        stage ('Send Success Notification') {
            steps {
                sh """
                      curl -X POST 'https://api.telegram.org/bot${env.telegramapi}/sendMessage' -d \
		      'chat_id=${env.telegramid}&text=Build ID #${env.BUILD_ID} Backend Pipeline Successful!'
                  """
            }
        }

    }
}
