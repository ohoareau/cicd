#!/usr/bin/env bash

export SHELL_WRAPPER=true

eval "$(cat /root/.bash_custom)"

exec bash "$@"