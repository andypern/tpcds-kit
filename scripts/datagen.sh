#!/usr/bin/bash

# the point is to parallelize...

scale=$1
dir=$2
threads=$3

binary=/usr/bin/dsdgen
# annoying..
cd /root

# iterate through each thread.

for t in {1..$threads}; do
   echo "kicking off thread $t"
   $binary -scale $scale -dir $dir -parallel $threads -child $t &
done


