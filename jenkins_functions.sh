#!/bin/bash

source /var/lib/jenkins/JobScripts/shell_functions.sh

create_new_job(){

    path_job_template=$1
    feature_branch_name=$2

    new_job_name="${feature_branch_name}CodeQuality"
    #Add a check if old job already exists or not
    if [ -d "/var/lib/jenkins/jobs/${new_job_name}" ]; then
        echo "This job already exists. Give another name."
        exit 1
    else
        mkdir "/var/lib/jenkins/jobs/${new_job_name}"
        cp "${path_job_template}" "/var/lib/jenkins/jobs/${new_job_name}/config.xml"

	replaceTextInFile /var/lib/jenkins/jobs/${new_job_name}/config.xml {feature_branch} ${feature_branch_name}
        echo " Restart jenkins server"
	echo "A job create at /var/lib/jenkins/jobs/${new_job_name}/config.xml"
    fi
}

