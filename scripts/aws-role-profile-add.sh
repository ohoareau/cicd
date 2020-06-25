#!/usr/bin/env bash

mkdir -p ~/.aws

cat << EOF >> ~/.aws/config
[profile $1]
source_profile=$2
role_arn=$3

EOF
