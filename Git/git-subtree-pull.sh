#!/bin/bash
if [ $# -lt 2 ]
	then
		echo "Usage: git-subtree-push <PREFIX_PATH> <REMOTE REPO> [<REMOTE BRANCH>]"
		exit 1
fi

path=$1
branch=`git symbolic-ref HEAD 2>/dev/null | cut -d"/" -f 3`
remote=$2
remoteBranch=$3

if [ $# -lt 3 ]
	then
		remoteBranch="master"
fi

git ls-remote $remote &>/dev/null
if [ "$?" -ne 0 ]
	then
		echo "Unable to find '$remote' remote repository"
		exit 1
fi

git ls-remote --exit-code $remote -h $remoteBranch &>/dev/null
if [ "$?" -ne 0 ]
	then
		echo "Unable to find branch '$remoteBranch' under '$remote' repo"
		exit 1
fi

currDir=`pwd`
if [ ! -d "$currDir/.git" ]
	then
		echo -e "Unable to find .git directory.\nYou are got in repository root"
		exit 1
fi

if [ ! -d "$path" ]
	then
		echo -e "Unable to locate '$path' path prefix"
		exit 1
fi

git checkout ${branch}_split || exit 1
git pull $2 $3 || exit 1
lastMsg=`git log -1 --pretty=%s`
git checkout ${branch} || exit 1
git subtree merge -P $path --squash -m "Merged \'$lastMsg\' onto ${branch}" ${branch}_split || exit 1