#!/bin/bash

# Kill the process named "aaa"
ps -ef | grep aaa | grep -v grep | awk '{print $2}' | xargs kill -9
