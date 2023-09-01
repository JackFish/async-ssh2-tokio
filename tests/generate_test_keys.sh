#!/bin/bash

# change to script dir
cd "${0%/*}" || exit 1

# generate keys if not present
[ -e "server.ed25519" ] || ssh-keygen -t ed25519 -q -f "server.ed25519" -N "" || exit 1
[ -e "client.ed25519" ] || ssh-keygen -t ed25519 -q -f "client.ed25519" -N "" || exit 1
[ -e "client.dsa" ] || ssh-keygen -t dsa -q -f "client.dsa" -N "" || exit 1
[ -e "client.prot.ed25519" ] || ssh-keygen -t ed25519 -q -f "client.prot.ed25519" -N "test" || exit 1

# copy files into the Dockerfile folders
cp server.ed25519 sshd-test/ssh_host_ed25519_key
cp server.ed25519.pub sshd-test/ssh_host_ed25519_key.pub
cp client.ed25519 async-ssh2-tokio/id_ed25519
cp client.ed25519.pub async-ssh2-tokio/id_ed25519.pub
cp client.dsa.pub sshd-test/id_dsa.pub
cp client.dsa async-ssh2-tokio/id_dsa
cp client.prot.ed25519 async-ssh2-tokio/prot.id_ed25519
cp client.prot.ed25519.pub async-ssh2-tokio/prot.id_ed25519.pub
cp server.ed25519.pub async-ssh2-tokio

# setup authorized keys
rm -f authorized_keys
cat client.ed25519.pub >> authorized_keys
cat client.prot.ed25519.pub >> authorized_keys
cat client.dsa.pub >> authorized_keys
mv authorized_keys sshd-test
