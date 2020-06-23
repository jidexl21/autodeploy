 #!/bin/bash

dir=$PWD
folder_exists () {
 FND=$(ls -l | grep ^d | grep -wc $1)
 echo $FND
}
is_behind () {
  Pull=$(git status -u $1 | grep "is behind" -c)
  echo $Pull
}
not_on_branch () {
   CBRANCH=$(git rev-parse --abbrev-ref HEAD)
   if [ "$CBRANCH" != "$1" ]; then
    echo 1
   else
    echo 0
   fi
}
for filename in ./*.cfg; do
    foo=""
    module="${filename/autodeploy-/$foo}"
    module="${module/.\//$foo}"
    module="${module/.cfg/$foo}"
   echo $module
    cd $dir
    source $filename
    FX=$(folder_exists $FOLDER)
    toPull=0
    if [ $FX != 1 ]; then
        #echo "folder does not exist!"
        toPull=1
    else
        cd $FOLDER
    fi
    if [[ $toPull -eq 1 ]]; then
      #proceed to next condition
      echo ""
    else
        toPull=$(not_on_branch $BRANCH)
    fi
    if [[ $toPull -eq 1 ]]; then
        #proceed to next condition
        echo ""
    else
        git remote update > /dev/null
        toPull=$(is_behind $BRANCH)
       # echo $toPull
    fi
    if [[ $toPull -eq 1 ]]; then
      echo "`date` - Updating $module ">> deployments.txt
      echo "`date` - Update required for $module"
        pwd
      cd ..
     # continue
        echo "Updating $module ..."
      ./deploy.sh -u $module -s #> /dev/null
      echo "`date` -finished updating $module">> deployments.txt
    fi done
