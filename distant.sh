#!/usr/bin/env bash

# Config

test_cmd=bin/rspec

current_branch=$(git rev-parse --abbrev-ref HEAD)

current_sha1=$(git rev-parse --verify HEAD)

log_path=log/distant/$current_branch/$current_sha1

logfile=$log_path/test.log

statusfile=$log_path/status

timestamp=$log_path/timestamp



# Ensure the expected directory structure is in place
mkdir -p $log_path

# Print the output of $test_cmd so we can show the output on failed builds
$test_cmd 2>&1 | tee $logfile

# Print the exit code of $test_cmd so we know if the build passed or failed
echo ${PIPESTATUS[0]} 2>&1 | tee $statusfile

# Print the date so we know which is the latest build
# TODO use `date` instead of `ruby`
echo $(ruby -e 'puts Time.now.utc.to_i') > $timestamp

# Put the files on s3 so they can be read via ajax in the PR
aws s3 sync ./log/distant/ s3://distant/

# TODO echo GITHUB_MARKDOWN_BUILD_STATUS_BADGE_WITH_LINK_TO_VIEW_ON_S3
