cp ../git_attributes_for_repository testMergeDriver/.gitattributes
(cd testMergeDriver; git checkout branch2; git merge --no-edit branch1)
if [ $? -eq 0 ]; then
	exit_code=0
else
	echo "git merge should not have failed"
	exit_code=1
fi
rm -rf testMergeDriver
exit $exit_code
