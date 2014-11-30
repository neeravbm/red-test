function replaceTextInFile(){
	SOURCE_FILE=$1
	SOURCE_TXT=$2
	TARGET_TXT=$3


	sed -i s/${SOURCE_TXT}/${TARGET_TXT}/ $SOURCE_FILE
}

