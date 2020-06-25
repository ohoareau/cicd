#!/usr/bin/env bash

cat << EOF >> ~/.terraformrc
credentials "app.terraform.io" {
  token = "$1"
}

EOF
