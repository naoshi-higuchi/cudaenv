#!/bin/sh

/usr/sbin/sshd -D &

exec su - naoshi
