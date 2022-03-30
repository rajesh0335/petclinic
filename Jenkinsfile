pipeline {
    agent any
    
    tools {
        maven 'M3.8'
    }
    
    stages {
        // 1. Checkout the code from GIT
//         stage('Checkout') {
//             steps {
//                 git branch: 'develop', url: 'https://github.com/akmaharshi/petclinic.git'
//             }
//         }
        
        // 2. Run Maven build
        stage('Build') {
            steps {
                sh "mvn clean package"
            }
        }
        
        // 2.1 SonarQube Integration - token:af2e94713f3a5cb947f94e300855e093a91a968c
        // stage('Code Quality Scan') {
        //     steps {
        //         withSonarQubeEnv('Sonar') {
        //             sh "mvn sonar:sonar"
        //         }
        //     }
        // }
        
        stage('Post-Build Actions') {
            parallel {
            
                // 2.2 Checking the Code Quality 
                // stage('Quality Gate Check') {
                //     steps {
                //         timeout(time: 1, unit: 'HOURS') {
                //             sleep 20
                //             waitForQualityGate abortPipeline: true
                //         }
                //     }
                // }
    
                // 3. Archive Artifacts
                stage('Archive Artifacts') {
                    steps {
                        archiveArtifacts artifacts: 'target/*.?ar', followSymlinks: false
                    }
                }
    
                // 4. Publish Jnuit test results
                stage('Unit tests') {
                    steps {
                        junit 'target/surefire-reports/*.xml' 
                    }
                }
                
                // 5. Artifact Uploader
                stage('Upload Artifact') {
                    steps {
                        nexusArtifactUploader artifacts: [
                            [artifactId: 'spring-petclinic', 
                                classifier: '', 
                                file: 'target/petclinic.war', 
                                type: 'war']
                            ], 
                            credentialsId: 'nexusCred', 
                            groupId: 'org.springframework.samples', 
                            nexusUrl: '3.145.39.41:8081', 
                            nexusVersion: 'nexus3', 
                            protocol: 'http', 
                            repository: 'maven-snapshots', 
                            version: '4.2.6-SNAPSHOT'
                    }
                }
            }
        }
    }
    post {
        success {
            echo "Pipeline is Success"
            notify('Success',"good")
        }
        failure {
            echo "Pipeline is Failed"
            notify('Failed',"#FF0000")
        }
    }
}

def notify(status,colour) {
    emailext (
        to: 'devops.kphb@gmail.com',
        subject: "${status}: Job ${env.JOB_NAME}[${env.BUILD_NUMBER}]",
        body: """
                <p> ${status}: Job ${env.JOB_NAME}[${env.BUILD_NUMBER} </p>
                <p> Please go to <a href="${env.BUILD_URL}">Build URL</a> and verify the build </p> 
        """
    )
    
    slackSend color: "${colour}", channel: "feb2022", message: "${status}: Job ${env.JOB_NAME}[${env.BUILD_NUMBER}]"
}
