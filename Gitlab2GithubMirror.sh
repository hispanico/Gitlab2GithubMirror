#!/bin/bash
#
# Shell script to config a Gitlab project to automatically mirror on Github.
# -------------------------------------------------------------------------
# File Name:	Gitlab2GithubMirror.sh
# Version:	1.0
# Last updated: Aug 2017
# -------------------------------------------------------------------------
# Released under the GPLv3 Licence
#
# @AUTHORS: Hispanico (hispanico@ninux.org)
# -------------------------------------------------------------------------


# ---------------------------------------------------------------------------
# DEFINITION VARIABLES
# ---------------------------------------------------------------------------

GitlabNamespace=$1
GitlabProjectName=$2
GithubUser=$3

sys_gituser="git"
sys_gitgroup="git"

GitLabReposPath="/var/opt/gitlab/git-data/repositories"
GitLabProjectPath="$GitLabReposPath/$GitlabNamespace/$GitlabProjectName.git"
#==========================================================================

if [ $# -ne 3 ]; then
  echo ""
  echo "Usage: "
  echo "  sh $0 <GitlabNamespace> <GitlabProjectName> <GithubUser>"
  echo ""
  echo "Arguments:"
  echo "  GitlabNamespace:  Namespace on Gitlab Server"
  echo "  GitlabProjectName: Project name Gitlab Server"
  echo "  GithubUser: Github username"
  echo ""
  echo "Examples:"
  echo "  sh $0 MyNameSpace MyProject MyGithubUser"
  echo ""

  exit 1
fi

# ---------------------------------------------------------------------------
# Check if the Gitlab Project exist
# ---------------------------------------------------------------------------
if [ ! -d $GitLabProjectPath ]; then
  echo "Error: Project doesn't exist on Gitlab Server"

  exit 1
fi

# ---------------------------------------------------------------------------
# Main
# ---------------------------------------------------------------------------
# Add github remote to git config

if [ $(grep "git@github.com:$GithubUser/$GitlabProjectName.git" $GitLabProjectPath/config 2>&1 > /dev/null) ]; then
cat << EOF >> $GitLabProjectPath/config
[remote "github"]
	url = git@github.com:$GithubUser/$GitlabProjectName.git
	fetch = +refs/heads/*:refs/remotes/github/*
EOF
fi

#Create custom hooks to github mirroring
[ ! -d $GitLabProjectPath/custom_hooks ] && mkdir $GitLabProjectPath/custom_hooks || :
cat << EOF > $GitLabProjectPath/custom_hooks/post-receive
#!/usr/bin/env bash
git push --mirror github
EOF

chmod +x $GitLabProjectPath/custom_hooks/post-receive
chown -R $sys_gituser:$sys_gitgroup $GitLabProjectPath/custom_hooks/

echo "The Project $GitlabProjectName has been configured"
