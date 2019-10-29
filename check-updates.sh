 #!/bin/bash
dir=$PWD
for filename in ./*.cfg; do
    foo=""
    module="${filename/autodeploy-/$foo}"
    module="${module/.\//$foo}"
    module="${module/.cfg/$foo}"
#    echo $module
    cd $dir
    source $filename
    cd $FOLDER
    git remote update > /dev/null
    toPull=$(git status -u no | grep "is behind" -c)
    if [ $toPull -eq 1 ] 
    then
      echo "Update required for $module"
      ./deploy.sh -u $module -s  
    fi
done
