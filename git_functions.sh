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

delete_branch() {
	GIT_CODEBASE_DIR=$1
        TARGET_BRANCH_NAME=$3
	cd ${GIT_CODEBASE_DIR}
	for remote in `git branch -r`; do git branch --track $remote; done
	git fetch --all
	git pull --all
	git checkout -b origin/${TARGET_BRANCH_NAME}
	git branch | grep -w ${TARGET_BRANCH_NAME} > /dev/null
        if [ $? -eq 0 ]; then
		git checkout master
		git merge ${TARGET_BRANCH_NAME}
		git push
		git branch -d ${TARGET_BRANCH_NAME}
		git branch -d origin/${TARGET_BRANCH_NAME}
		git push origin --delete ${TARGET_BRANCH_NAME}
        else
		echo "This branch not exists"
		exit 1
        fi
}

