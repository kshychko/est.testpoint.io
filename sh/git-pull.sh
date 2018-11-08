#!/bin/bash

# Parse options
while getopts ":t:" opt; do
    case $opt in
        t)
            echo -e "\nTARGET_REPO_NAME: -${OPTARG}"
            TARGET_REPO_NAME="${OPTARG}"
            ;;
        \?)
            echo -e "\nInvalid option: -${OPTARG}"
            usage
            ;;
        :)
            echo -e "\nOption -${OPTARG} requires an argument"
            usage
            ;;
     esac
done


cd /opt/$TARGET_REPO_NAME
if [ -d "specs" ]; then
    echo -e "specs directory exists, no need to create"
    else
    mkdir "specs"
fi


## declare an array variable
REPO_NAMES=("edi3-finance" "edi3-methodology" "edi3-rdp" "edi3-regulatory" "edi3-trade" "edi3-transport")

## now loop through the above array
for i in "${REPO_NAMES[@]}"
do
	cd /opt/

	if [ -d "$i" ]; then
		cd /opt/$i
		git pull origin master
		RESULT=$?
		if [[ ${RESULT} -ne 0 ]]; then
			echo -e "\nCan't pull ${i} repo"
			exit
		fi
#		else
#		git clone $i
	fi
	cd /opt/$TARGET_REPO_NAME/specs
	if [ -d "$i" ]; then
		rm -rf $i
	fi

	mkdir $i

	cp -rf /opt/$i/docs/. /opt/$TARGET_REPO_NAME/specs/$i
done


