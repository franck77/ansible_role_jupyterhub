__How to contribute to a SGITHUB project__

* Fork the repository you want to contribute in your userspace
*  git clone it on your VM (don't forget to change [my-github-username] matching yours in the following command)
```
$ git clone git@sgithub.fr.world.socgen:[my-github-username]/[project-name]
```
* add mainstream repository as a remote called upstream
```
$ git remote add upstream git@sgithub.fr.world.socgen:GTSMKTSSB/[project-name]
```
* Create your feature branch
```
$ git checkout -b my-new-feature
```
* Do the changes you need
* Commit your changes
```
$ git commit -am 'Add some feature'
```
* Get last changes for mainstream
```
$ git pull --rebase upstream
```
* Fix conflicts if needed
* Push your changes to your userland
```
$ git push --force-with-lease origin my-new-feature
```
* Create a pull request to the upstream repo using SGITHUB interface

__Good practices to collaborate to a github project__

* Do one commit per module! Never commit 2 modules' changes in the same commit
* More generally, one independent change = one commit, because if we ever need to revert we will revert the whole commit
* On the other hand, keep interdependent changes together in one commit, for the same reason: we should not have to revert several commits at the same time to keep it working
* Do not use `git commit -a`. Aside from being contrary to the above, you will end up committing stuff you don't actually want (NFS locks, editor swap files, backup files, binaries...).
* If you see such useless files in `git status`, please consider adding the relevant pattern in `.gitignore` (e.g. `.nfs*`), others will thank you.
* Tag the module you're working on in the commit message to make filtering easier (ex: `[module] Fix this`)
* Your commit title should be short, GitHub cuts it at 72 characters
* If you need to put more information, you can add a blank line, then a longer text (the blank line is important). Example:
```
[module] Add an example

Here you can put a more detailed explanation of your commit if you feel like it is needed.
```
* __Always create a dedicaded branch for the Pull Request__
* Only comment Pull request changes in the "Files changed" tabs.
* Do not store binary files in git. Git is meant for text files, binary files will make the repo become huge and unusable.

## NEVER MERGE A PULL REQUEST YOU ASK, IT SHOULD BE DONE BY SOMEONE ELSE
