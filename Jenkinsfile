node {
    def app

    stage('Clone repository') {
        /* Let's make sure we have the repository cloned to our workspace */
        checkout scm
    }

    stage('Copy file for docker build') {
        sh "cp restore.sh build_container/restore.sh"
    }

    stage('Build image') {
        app = docker.build("nutellinoit/sidecar-restore-volumes","--pull --no-cache build_container/")
    }


    stage('Push image') {
        docker.withRegistry('https://registry.hub.docker.com', 'docker-hub-credentials') {
            app.push("latest")
            app.push("${env.BUILD_NUMBER}")
        }
    }
}
