#!/bin/bash

source /var/lib/jenkins/JobScripts/shell_functions.sh

createJobConfigFromTemplate(){
    path_job_template=$1
    JOB_NAME=$2

    cp "${path_job_template}" "/tmp/config.xml"
    replaceTextInFile /tmp/config.xml {feature_branch} ${JOB_NAME}
}

createJob(){
        JOB_NAME=$1
        JOB_CONFIG=$2
        JENKINS_CLI_JAR=/var/lib/jenkins/jenkins-cli.jar
        JENKINS_URL=http://162.243.157.72:8080/

        echo " INFO : Creating Job : $JOB_NAME "
        java -jar ${JENKINS_CLI_JAR} -s $JENKINS_URL create-job ${JOB_NAME} < ${JOB_CONFIG}

        export RC=$?
        if [ $RC -ne 0 ]; then
                echo " Error While Creating JOB : $JOB_NAME !!! "
                echo " Failed with Error Code : $RC "
                return 1
        else
                echo " INFO : Created Job : $JOB_NAME "
                return 0
        fi
}

deleteJob(){
	JOB_NAME=$1
	JENKINS_CLI_JAR=/var/lib/jenkins/jenkins-cli.jar
        JENKINS_URL=http://162.243.157.72:8080/
	echo " INFO :Deleting Job : $JOB_NAME "
	java -jar ${JENKINS_CLI_JAR} -s $JENKINS_URL delete-job ${JOB_NAME}
	export RC=$?
        if [ $RC -ne 0 ]; then
                echo " Error While deleting JOB : $JOB_NAME !!! "
                echo " Failed with Error Code : $RC "
                return 1
        else
                echo " INFO : deleted Job : $JOB_NAME "
                return 0
        fi
}
