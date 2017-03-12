
(cd testMergeDriver; git checkout branch2; git merge --no-edit branch1)
if [ $? -eq 0 ]; then
	echo "git merge should have failed"
	exit_code=1
else
	exit_code=0
fi
rm -rf testMergeDriver
exit $exit_code
