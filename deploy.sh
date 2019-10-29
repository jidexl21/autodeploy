

#!/bin/bash

interactive="-i"
unit=
silent=0

while [ "$1" != "" ]; do
    case $1 in
        -u | --unit )           shift
                                unit="-$1"
                                ;;
        -s | --silent )    	silent=1
                                ;;
        -h | --help )           usage
                                exit
                              ;;
        * )                     usage
                                exit 1
    esac
    shift
done

CFG_FILE="./autodeploy$unit.cfg"
if [ -f "$CFG_FILE" ]; then
    echo "deploying unit '$unit'"
else 
    echo "Configuration for unit '$unit' not found"
    exit 0
fi

if [ $silent -eq 1 ]
then
	interactive=""
fi

source "utils/check.sh" $interactive
source "./autodeploy$unit.cfg"

rm -rf $FOLDER
git clone $REPO --branch $BRANCH --single-branch
cd $TARGET_DIR

echo "about to complete deployment on '$TARGET_DIR'"
echo "document type: '$BUILD_TYPE'"

case $BUILD_TYPE in
		"react")
		echo "commencing deployment for react application"
		npm install
		echo "done with npm install"
		npm run build

		echo "done with npm run build"
                ls $DEPLOYMENT_DIR/$FOLDER 
		#mkdir -p $DEPLOYMENT_DIR/$FOLDER
		cp -r build/* $DEPLOYMENT_DIR/$FOLDER
		##cd $DEPLOYMENT_DIR/$FOLDER
		#pwd
		echo "done with deployment"
		sudo service nginx stop
		sudo service nginx start
			;;
		*)
		echo "commencing deployment for dotnetcore application"
		#dotnet run -c Release
		#rm -rf $DEPLOYMENT_DIR/$FOLDER
		#mkdir -p $DEPLOYMENT_DIR/$FOLDER
		dotnet build
		#Stop Services
		sudo service nginx stop
		echo "about to start service: $SERVICE_NAME"
		sudo systemctl stop $SERVICE_NAME.service
		dotnet publish -c Release --output  $DEPLOYMENT_DIR/$FOLDER
		#Restart Services
		sudo systemctl start $SERVICE_NAME.service
		sudo service nginx start

esac
