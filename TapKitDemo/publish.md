
Edit tapkit.podspec.

Commit all changes.


git tag -a 1.0.1 -m "Release 1.0.1"

git push origin --tags

pod trunk register kvmisc@163.com 'Kevin Wu' --description='home' --verbose

pod lib lint

pod trunk push tapkit.podspec
