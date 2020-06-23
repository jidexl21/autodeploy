#!/bin/bash

interactive="-i"
unit=
silent=0

while [ "$1" != "" ]; do
    case $1 in
        -u | --unit )           shift
                                unit="-$1"
                                ;;
        -s | --silent )         silent=1
                                ;;
        -h | --help )           usage
                                exit
                              ;;
        * )                     usage
                                exit 1
    esac
    shift
done
echo "./autodeploy$unit.cfg"
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


source "./utils/check.sh" $interactive
source $CFG_FILE

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
                npm run build:development

                echo "done with npm run build"
                ls $DEPLOYMENT_DIR/$FOLDER
                #mkdir -p $DEPLOYMENT_DIR/$FOLDER
                cp -r build/* $DEPLOYMENT_DIR/$FOLDER
                ##cd $DEPLOYMENT_DIR/$FOLDER
                #pwd
                echo "done with deployment"
                #systemctl stop nginx
                #systemctl start nginx
                        ;;
                *)
                echo "commencing deployment for dotnetcore application"
                #dotnet run -c Release
                #rm -rf $DEPLOYMENT_DIR/$FOLDER
                #mkdir -p $DEPLOYMENT_DIR/$FOLDER
                dotnet build
                #Stop Services
                #eval "sudo systemctl stop nginx"
                echo "about to start service: $SERVICE_NAME"
                eval "sudo systemctl stop $SERVICE_NAME"
                dotnet publish -c Release --output  $DEPLOYMENT_DIR/$FOLDER
                #Restart Services
                eval "sudo systemctl start $SERVICE_NAME"
                #eval "sudo systemctl start nginx"

esac
