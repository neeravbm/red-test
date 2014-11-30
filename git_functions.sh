#!/bin/bash
create_branch() {
	GIT_CODEBASE_DIR=$1
	SOURCE_BRANCH_NAME=$2
	TARGET_BRANCH_NAME=$3

	cd ${GIT_CODEBASE_DIR}
	git branch | grep -w ${TARGET_BRANCH_NAME} > /dev/null
	if [ $? -eq 0 ]; then
		echo "Target Branch already exists"
		exit 1
	else
		git checkout ${SOURCE_BRANCH_NAME}
		git branch ${TARGET_BRANCH_NAME}
		echo "New Branch Created ${TARGET_BRANCH_NAME}"
		git checkout ${TARGET_BRANCH_NAME}
		git push origin ${TARGET_BRANCH_NAME}
	fi
}
