
Edit tapkit.podspec.

Commit all changes.


pod trunk register kvmisc@163.com 'Kevin Wu' --description='home' --verbose


pod lib lint


git tag -a 1.0.1 -m "Release 1.0.1"

git push origin --tags


pod trunk push tapkit.podspec
