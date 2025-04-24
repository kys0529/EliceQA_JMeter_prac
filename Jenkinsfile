pipeline {
    agent any

    environment {
        JMETER_HOME = "/opt/jmeter"
        JMX_FILE = "${JMETER_HOME}/bin/250424.jmx"
        JTL_REPORT_FILE = "${JMETER_HOME}/bin/results/results.jtl"
        HTML_REPORT_DIR = "${JMETER_HOME}/bin/results/report_output"
    }

    stages {
        stage('Run Test') {
            steps {
                script {
                    // 결과 디렉토리 초기화
                    sh 'rm -rf ${JMETER_HOME}/bin/results'
                    sh 'mkdir -p ${HTML_REPORT_DIR}'

                    // JMeter 테스트 실행
                    sh """
                    echo "시작"
                    ${JMETER_HOME}/bin/jmeter -n \\
                    -t ${JMX_FILE} \\
                    -l ${JTL_REPORT_FILE} \\
                    -e -o ${HTML_REPORT_DIR}
                    """
                }
            }
        }

        stage('퍼포먼스 리포트') {
            steps {
                script {
                    if (fileExists("${JTL_REPORT_FILE}")) {
                        perfReport(
                            sourceDataFiles: "${JTL_REPORT_FILE}",
                            errorFailedThreshold: 1,
                            errorUnstableThreshold: 0.5
                        )
                    } else {
                        echo "⚠️ 퍼포먼스 리포트를 생성할 JTL 파일이 존재하지 않음"
                    }
                }
            }
        }

        stage('HTML Report') {
            steps {
                script {
                    if (fileExists("${HTML_REPORT_DIR}/index.html")) {
                        publishHTML([
                            allowMissing: false,
                            alwaysLinkToLastBuild: true,
                            keepAll: true,
                            reportDir: "${HTML_REPORT_DIR}",
                            reportFiles: 'index.html',
                            reportName: 'JMeter Performance Report'
                        ])
                    } else {
                        echo "⚠️ HTML 리포트 디렉토리가 존재하지 않음"
                    }
                }
            }
        }
    }

    post {
        always {
            echo 'Build finished.'
            archiveArtifacts artifacts: "${HTML_REPORT_DIR}/**/*", allowEmptyArchive: true
        }
    }
}