#!/bin/bash
if [ "$1" != ""]; then
  echo "Specify port and IP"
else
  ruby tcpServer.rb $1
fi
