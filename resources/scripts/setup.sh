mkdir testMergeDriver
cd testMergeDriver
git init
cp ../../initial/* .
git add *
git commit -a -m "0:0"
git checkout -b branch1
cp ../../branch1/* .
git add *
git commit -a -m "0:1"
git checkout master
git checkout -b branch2
cp ../../branch2/* .
git add *
git commit -a -m "0:2"
