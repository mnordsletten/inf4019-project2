#!/bin/bash 

test1_ip=10.1.7.225
test1_user=debian
test2_ip=10.1.7.224
test2_user=fedora
production_ip=10.1.7.226
production_user=centos
test_fail=false

# Copy over dockerfile
ssh $test1_user@$test1_ip 'rm -Rf $HOME/docker_distribute;
	      git clone -q https://git.cs.hioa.no/s238051/docker_distribute.git'

# Build and run dockerfile
ssh $test1_user@$test1_ip 'cd $HOME/docker_distribute/docker_files;
	      sudo docker build -t="test2/web" . > /dev/null;
	      sudo docker run --rm test2/web /commands_test1'
if [ $? -ne 0 ]; then
	echo Test 1 failed, will not go into production
	test_fail=true
else
	echo Test 1 cleared
fi

# Then we do the same for test machine number 2
ssh $test2_user@$test2_ip 'rm -Rf $HOME/docker_distribute;
	      git clone -q https://git.cs.hioa.no/s238051/docker_distribute.git'

# Build and run dockerfile
ssh $test2_user@$test2_ip 'cd $HOME/docker_distribute/docker_files;
	      sudo docker build -t="test2/web" . > /dev/null;
	      sudo docker run --rm test2/web /commands_test2'
if [ $? -ne 0 ]; then
	echo Test 2 failed, will not go into production
	test_fail=true
else
	echo Test 2 cleared
fi

if [ "$test_fail" = true ]; then
	echo Tests have failed, exiting
	exit 1
else
	echo Tests have passed
	read -r -p "Do you want to go into production? [y/N] " response
	response=${response,,}	
	if [[ $response =~ ^(yes|y)$ ]]; then
		echo Going into production
	else
		echo Not in production, exiting
		exit 1
	fi
fi

# Then we do the same for the production machine
ssh $production_user@$production_ip 'rm -Rf $HOME/docker_distribute;
	      git clone -q https://git.cs.hioa.no/s238051/docker_distribute.git'

# Build and run dockerfile
ssh $production_user@$production_ip 'cd $HOME/docker_distribute/docker_files;
	      sudo docker build -t="test2/web" . > /dev/null;
	      sudo docker run --rm test2/web /commands_test2'
