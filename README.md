Distant
---

__NOTE__ this is still a work in progress.

Distant is a distributed integration server. Think Git vs. SVN, except for CIs

## Installation

Install `aws`

    brew install awscli


Configure `aws` with your credentials

    aws configure


Create a bucket for distant

    aws s3 mb s3://<my-bucket>/distant


## Usage

Run this command before you open a PR

    ./distant.sh

This script will run your tests, and upload the status of the tests to s3. The
script will print a Github Markdown badge which you can add to your PRs to
indicate the build status of your current branch.


## TODO

- [ ] This is really just a spike. Needs to be less pointy
