#!/bin/sh

set -e

apk add --no-cache docker
addgroup bernd docker
rc-update add docker default
service docker start
