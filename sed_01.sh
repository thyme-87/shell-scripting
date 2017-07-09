#! /bin/bash

# seach for first argument; replace with second argument; on file specified by third argument

#set -x #turn tracing on 
#cp $3 $3'.bak' # create a backup
sed -i 's/'$1'/'$2'/' $3
#set +x #turn tracing off
