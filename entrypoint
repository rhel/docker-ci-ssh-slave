#!/bin/bash

set -ex

# The MIT License
#
#  Copyright (c) 2015, CloudBees, Inc.
#  Copyright (C) 2018, Artyom Nosov
#
#  Permission is hereby granted, free of charge, to any person obtaining a copy
#  of this software and associated documentation files (the "Software"), to deal
#  in the Software without restriction, including without limitation the rights
#  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
#  copies of the Software, and to permit persons to whom the Software is
#  furnished to do so, subject to the following conditions:
#
#  The above copyright notice and this permission notice shall be included in
#  all copies or substantial portions of the Software.
#
#  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
#  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
#  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
#  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
#  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
#  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
#  THE SOFTWARE.

# Usage:
#  docker run pearbox/ci-ssh-slave <public key>
# or
#  docker run -e "CI_SLAVE_SSH_PUBKEY=<public key>" pearbox/ci-ssh-slave

write_key() {
  mkdir -p "$CI_AGENT_HOME/.ssh"
  echo "$1" > "$CI_AGENT_HOME/.ssh/authorized_keys"
  chmod 0700 -R "$CI_AGENT_HOME/.ssh"
}

if [[ $CI_SLAVE_SSH_PUBKEY == ssh-* ]]; then
  write_key "$CI_SLAVE_SSH_PUBKEY"
fi

if [[ $# -gt 0 ]]; then
  if [[ $1 == ssh-* ]]; then
    write_key "$1"
    shift 1
  else
    exec "$@"
  fi
fi

chown -Rf ci:ci "$CI_AGENT_HOME"

# ensure variables passed to docker container are also exposed to ssh sessions
env | grep _ >> /etc/environment

ssh-keygen -A
exec /usr/sbin/sshd -D -e "${@}"
