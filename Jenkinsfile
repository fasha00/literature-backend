def branch = "master"
def remoteurl = "https://github.com/yuuzukatsu/dumbflix-backend.git"
def remotename = "jenkins"
def workdir = "~/dumbflix-backend/"
def ip = "103.183.74.5"
def username = "fasha1"
def imagename = "dumbflix-backend"
def dockerusername = "yuuzukatsu"
def sshkeyid = "app"

pipeline {
    agent any

    stages {
        stage('Pull From Backend Repo') {
            steps {
                sshagent(credentials: ["${sshkeyid}"]) {
                    sh """
                        ssh -l ${username} ${ip} <<PWD
                        cd ${workdir}
                        git remote add ${remotename} ${remoteurl} || git remote set-url ${remotename} ${remoteurl}
                        git pull ${remotename} ${branch}
                        PWD
                    """
                }
            }
        }
            
        stage('Build Docker Image') {
            steps {
                sshagent(credentials: ["${sshkeyid}"]) {
                    sh """
                        ssh -l ${username} ${ip} <<pwd
                        cd ${workdir}
                        docker build -t ${imagename}:${env.BUILD_ID} .
                        pwd
                    """
                }
            }
        }
            
        stage('Deploy Image') {
            steps {
                sshagent(credentials: ["${sshkeyid}"]) {
                    sh """
                        ssh -l ${username} ${ip} <<pwd
                        cd ${workdir}
                        docker compose down
                        docker tag ${imagename}:${env.BUILD_ID} ${imagename}:latest
                        docker compose up -d
                        pwd
                    """
                }
            }
        }

        stage('Push to Docker Hub') {
            steps {
                sshagent(credentials: ["${sshkeyid}"]) {
			sh """
				ssh -l ${dockerusername} ${ip} <<pwd
				docker tag ${imagename}:${env.BUILD_ID} ${dockerusername}/${imagename}:${env.BUILD_ID}
				docker tag ${imagename}:latest ${dockerusername}/${imagename}:latest
				docker image push ${dockerusername}/${imagename}:latest
				docker image push ${dockerusername}/${imagename}:${env.BUILD_ID}
				docker image rm ${dockerusername}/${imagename}:latest
				docker image rm ${dockerusername}/${imagename}:${env.BUILD_ID}
				docker image rm ${imagename}:${env.BUILD_ID}
				pwd
			"""
		}
            }
        }


        stage('Send Success Notification') {
            steps {
                sh """
                    curl -X POST 'https://api.telegram.org/bot${env.telegramapi}/sendMessage' -d \
		    'chat_id=${env.telegramid}&text=Build ID #${env.BUILD_ID} Backend Pipeline Successful!'
                """
            }
        }

    }
}
