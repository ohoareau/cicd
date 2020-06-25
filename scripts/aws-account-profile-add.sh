#!/usr/bin/env bash

mkdir -p ~/.aws

cat << EOF >> ~/.aws/credentials
[$1]
aws_access_key_id=$2
aws_secret_access_key=$3

EOF
