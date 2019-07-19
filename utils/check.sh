#!/bin/bash

#check if ssh keys have already been setup

lines=$(ls ~/.ssh | tr '\n' '\n' | grep -ic rsa)

#if no keys have been setup then set them up
if [ $lines -gt 1 ]
then
    echo "SSH keys have already been setup"
fi
if [ $lines -lt 1 ]
then
    echo "SSH keys have not been setup"
    echo "Enter email for git account:" 
    read newmail
    ssh-keygen -t rsa -b 4096 -C $newmail
    ssh-add ~/.ssh/id_rsa
fi
echo "show key?"(y/n)
read showval
show=$(echo $showval | grep -ic y)
if [ $show -gte 1]
then 
    cat ~/.ssh/id_rsa.pub
fi 
