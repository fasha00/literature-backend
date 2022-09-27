def branch = "Production"
def remoteurl = "git@github.com:fasha00/literature-backend.git"
def remotename = "origin1"
def workdir = "~/literature-backend/"
def ip = "103.183.74.5"
def username = "fasha1"
def imagename = "literature-backend"
def dockerusername = "fasha00"
def sshkeyid = "fasha1"

pipeline {
    agent any

    stages {
        stage('Pull From Backend Repo') {
            steps {
                sshagent(credentials: ["${sshkeyid}"]) {
                    sh """
                        ssh -l ${username} ${ip} <<pwd
                        cd ${workdir}
                        git remote add ${remotename} ${remoteurl} || git remote set-url ${remotename} ${remoteurl}
                        git pull ${remotename} ${branch}
                        pwd
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
