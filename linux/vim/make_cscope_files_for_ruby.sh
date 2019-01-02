#!/bin/bash

echo "Delete cscope and tags file"
rm -rf cscope.files cscope.out
rm -rf tags

echo "Make cscope.files"
find -name "*.rb" >> cscope.files

echo "Make ctags"
ctags --languages=ruby -R *

echo "Clean-up and make cscope and tags done"
