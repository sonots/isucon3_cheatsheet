#!/bin/sh
host=$1
rsync -auv ~/isucon4/webapp/go $host:~/webapp/go
