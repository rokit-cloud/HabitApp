pipeline {
    agent any

    environment {
        IMAGE_NAME = 'rokit45/habitapp'
    }

    stages {

        stage('Checkout') {
            steps {
                git branch: 'main',
                    url: 'https://github.com/rokit-cloud/HabitApp.git'
            }
        }


        stage('Skip Bot Commit') {
            steps {
                script {
                    env.SKIP_CI = sh(
                        script: "if git log -1 --pretty=%B | grep -Fq '[skip ci]'; then echo true; else echo false; fi",
                        returnStdout: true
                    ).trim()
                    echo "Skip CI commit: ${env.SKIP_CI}"
                }
            }
        }

        stage('Environment Check') {
            when { expression { env.SKIP_CI != 'true' } }
            steps {
                sh '''
                    echo "===== JAVA VERSION ====="
                    java -version

                    echo "===== MAVEN VERSION ====="
                    mvn -version

                    echo "===== DOCKER VERSION ====="
                    docker --version

                    echo "===== TRIVY VERSION ====="
                    trivy --version
                '''
            }
        }

        stage('Build & Test') {
            when { expression { env.SKIP_CI != 'true' } }
            steps {
                sh 'mvn -B clean verify'
            }
        }

        stage('SonarQube Analysis') {
            when { expression { env.SKIP_CI != 'true' } }
            steps {
                withSonarQubeEnv('SonarQube') {
                    sh '''
                        mvn -B sonar:sonar \
                          -Dsonar.projectKey=HabitApp \
                          -Dsonar.projectName=HabitApp
                    '''
                }
            }
        }

        stage('Quality Gate') {
            when { expression { env.SKIP_CI != 'true' } }
            steps {
                timeout(time: 5, unit: 'MINUTES') {
                    waitForQualityGate(abortPipeline: true)
                }
            }
        }

        stage('Docker Build') {
            when { expression { env.SKIP_CI != 'true' } }
            steps {
                sh '''
                    echo "===== BUILDING DOCKER IMAGE ====="

                    docker build \
                      -t ${IMAGE_NAME}:${BUILD_NUMBER} \
                      -t ${IMAGE_NAME}:latest \
                      .
                '''
            }
        }

        stage('Trivy Security Scan') {
            when { expression { env.SKIP_CI != 'true' } }
            steps {
                sh '''
                    echo "===== TRIVY SECURITY SCAN ====="

                    trivy image \
                      --exit-code 1 \
                      --severity HIGH,CRITICAL \
                      ${IMAGE_NAME}:${BUILD_NUMBER}
                '''
            }
        }

        stage('Docker Hub Push') {
            when { expression { env.SKIP_CI != 'true' } }
            steps {
                withCredentials([
                    usernamePassword(
                        credentialsId: 'dockerhub-creds',
                        usernameVariable: 'DOCKERHUB_USERNAME',
                        passwordVariable: 'DOCKERHUB_PASSWORD'
                    )
                ]) {
                    sh '''
                        set +x

                        echo "$DOCKERHUB_PASSWORD" | docker login \
                          --username "$DOCKERHUB_USERNAME" \
                          --password-stdin

                        docker push ${IMAGE_NAME}:${BUILD_NUMBER}
                        docker push ${IMAGE_NAME}:latest

                        docker logout
                    '''
                }
            }
        }


        stage('GitHub Helm Update') {
            when { expression { env.SKIP_CI != 'true' } }
            steps {
                withCredentials([
                    string(credentialsId: 'github-write-token', variable: 'GITHUB_TOKEN')
                ]) {
                    sh '''
                        set -eu
                        set +x

                        VALUES_FILE="helm/habitapp/values.yaml"
                        test -f "$VALUES_FILE"

                        python3 - "$BUILD_NUMBER" "$VALUES_FILE" <<'PYTHON_EOF'
import re
import sys

tag, path = sys.argv[1], sys.argv[2]
with open(path, "r", encoding="utf-8") as f:
    content = f.read()

pattern = r'(?m)^([ \\t]*)tag:[ \\t]*["\\']?[^"\\' \\t\\r\\n]+["\\']?[ \\t]*$'
updated, count = re.subn(pattern, lambda m: m.group(1) + 'tag: "' + tag + '"', content)

if count != 1:
    raise SystemExit("Expected exactly one image tag in values.yaml; found " + str(count))

with open(path, "w", encoding="utf-8") as f:
    f.write(updated)

print("Helm image tag updated to:", tag)
PYTHON_EOF

                        git config user.name "habitapp-jenkins"
                        git config user.email "habitapp-jenkins@users.noreply.github.com"
                        git add "$VALUES_FILE"

                        if git diff --cached --quiet; then
                            echo "Helm image tag already up to date; no commit needed."
                            exit 0
                        fi

                        git commit -m "chore(gitops): update HabitApp image to ${BUILD_NUMBER} [skip ci]"

                        ASKPASS="$(mktemp)"
                        trap 'rm -f "$ASKPASS"' EXIT

                        cat > "$ASKPASS" <<'ASKPASS_EOF'
#!/bin/sh
case "$1" in
    *Username*) printf '%s\\n' 'x-access-token' ;;
    *) printf '%s\\n' "$GITHUB_TOKEN" ;;
esac
ASKPASS_EOF

                        chmod 700 "$ASKPASS"
                        GIT_ASKPASS="$ASKPASS" GIT_TERMINAL_PROMPT=0 \
                            git push origin HEAD:main

                        echo "GitHub Helm values.yaml pushed successfully."
                    '''
                }
            }
        }

        stage('Archive Artifact') {
            when { expression { env.SKIP_CI != 'true' } }
            steps {
                archiveArtifacts(
                    artifacts: 'target/*.jar',
                    fingerprint: true
                )
            }
        }
    }

    post {
        always {
            junit(
                testResults: 'target/surefire-reports/*.xml',
                allowEmptyResults: true
            )
        }

        success {
            echo 'SUCCESS: HabitApp CI Pipeline completed!'
            echo 'Maven Build & Tests: PASSED'
            echo 'SonarQube Quality Gate: PASSED'
            echo 'Trivy Security Scan: PASSED'
            echo 'Docker Hub Push: SUCCESS'
        }

        failure {
            echo 'FAILED: HabitApp CI Pipeline.'
            echo 'Check Console Output for the failed stage.'
        }
    }
}
