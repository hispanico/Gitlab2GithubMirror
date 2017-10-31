# How to automatically mirror a Gitlab project to Github

Sometimes you need to auto-sync Gitlab repos to Github, so here's what you have to do.

We need to add a post-receive hook in Gitlab's repo, on the Gitlab's server, which will trigger every time you do a push to the Gitlab's repo.

## First Configuration setup
Create the ssh-key for git user on the Gitlab server:
```
su git
bash
ssh-keygen
cat ~/.ssh/id_rsa.pub
```

Add this pub key to Github with write access: https://github.com/Organization/RepoName/settings/keys

Check the connection to GitHub on the Gitlab server:
```
su git
ssh -T git@github.com
```

## For each Gitlab Project
Run Gitlab2GithubMirror.sh script on the Gitlab server to configure your project.

## Details
```
Usage:
  sh Gitlab2GithubMirror.sh <GitlabNamespace> <GitlabProjectName> <GithubUser>

Arguments:
  GitlabNamespace:  Namespace on Gitlab Server
  GitlabProjectName: Project name Gitlab Server
  GithubUser: Github username

Examples:
  sh Gitlab2GithubMirror.sh MyNameSpace MyProject MyGithubUser

```
