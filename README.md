# afronews
## Before Developing
- Make sure you are on staging branch then run a `git pull origin staging` or more verbose command `git fetch` and `git merge origin/staging`, to make sure everything is up to date locally with `staging`
- Create a development branch off of staging (`git checkout -b branch_name`)
- Run `pod install` to get the updated dependencies from cocoapods

## When checking branch in
It can be hard to predict what changes make it to `staging` before your development branch gets merged into staging but when your branch gets out of date what you should do is
- Run `git fetch` to grab what is remote in staging
- Run `git rebase origin/staging` to apply changes from staging to local development branch (fix conflicts along the way)

## When merging
- If no changes to `Podfile` please do not commit changes to `Podfile.lock`
- Always [Squash and Merge](https://blog.carbonfive.com/2017/08/28/always-squash-and-rebase-your-git-commits/) into `staging`
