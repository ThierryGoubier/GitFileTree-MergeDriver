#!/usr/bin/env bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )"
echo $DIR
cd $DIR
mkdir ../test
tests_status=0
(cd ../test; pwd; ../scripts/setup.sh; ../scripts/failIfNotSet.sh)
if [ $? -ne 0 ]; then
	tests_status=1
fi
(cd ../test; ../scripts/setup.sh; ../scripts/succeedIfSet.sh)
if [ $? -ne 0 ]; then
	tests_status=1
fi
exit $tests_status