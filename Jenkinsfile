pipeline {
    agent any

    environment {
        JMETER_HOME = "/opt/jmeter"
        JTL_REPORT_FILE = "/opt/jmeter/bin/results/results.jtl"
        HTML_REPORT_DIR = "/opt/jmeter/bin/results/report_output"
    }

    stages {
        stage('Run Test') {
            steps {
                script {
                    sh 'rm -rf results'
                    sh 'rm -f results.jtl'
                    sh 'rm -rf report_output'

                    sh 'mkdir -p results'
                    sh 'mkdir -p report_output'
                    sh 'mkdir -p results/report_output'

                    sh """
                    echo "시작"
                    ${env.JMETER_HOME}/bin/jmeter -n \\
                    -t 250424.jmx \\
                    -l ./results/results.jtl \\
                    -e -o ./results/report_output
                    """ 
                }
            }
        }

        stage('퍼포먼스 리포트') {
            steps {
                perfReport(
                    sourceDataFiles: "${env.JTL_REPORT_FILE}",
                    errorFailedThreshold: 1, 
                    errorUnstableThreshold: 0.5
                )
            }
        }

        stage('HTML Report') {
            steps {
                publishHTML(
                    allowMissing: false,
                    alwaysLinkToLastBuild: false,
                    keepAll: false,
                    reportDir: "${env.HTML_REPORT_DIR}",
                    reportFiles: 'index.html',
                    reportName: 'JMeter Performance Report'
                )
            }
        }
    }

    post {
        always {
            echo 'Build finished.'
            archiveArtifacts artifacts: "${env.HTML_REPORT_DIR}/**/*", allowEmptyArchive: true
        }
    }
}