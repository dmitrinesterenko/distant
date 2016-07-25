#!/usr/bin/env bash

# Config

project_name=$PROJECT_NAME

test_cmd=bin/rspec

current_branch=$(git rev-parse --abbrev-ref HEAD)

current_sha1=$(git rev-parse --verify HEAD)

log_path=log/distant/$project_name/$current_branch/$current_sha1

logfile=$log_path/test.log

statusfile=$log_path/status

timestamp=$log_path/timestamp

function passing {
  `cat $statusfile` == 0
}

function __status__ {
  echo $([ "$passing" ] && echo 'passing' || echo 'failing')
}

function color {
  echo $([ "$passing" ] && echo 'green' || echo 'red')
}

function shield {
  echo '<img src="https://img.shields.io/badge/build-'$(__status__)'-'$(color)'.svg">'
}



# Ensure the expected directory structure is in place
mkdir -p $log_path

# Print the output of $test_cmd so we can show the output on failed builds
$test_cmd 2>&1 | tee $logfile &> /dev/null

# Print the exit code of $test_cmd so we know if the build passed or failed
echo ${PIPESTATUS[0]} > $statusfile

# Print the date so we know which is the latest build
# TODO use `date` instead of `ruby`
echo $(ruby -e 'puts Time.now.utc.to_i') > $timestamp

# Put the files on s3 so they can be read via ajax in the PR
aws s3 sync ./log/distant/$project_name/ s3://distant/$project_name/ &> /dev/null

shield
