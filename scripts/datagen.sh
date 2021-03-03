#!/usr/bin/bash

# the point is to parallelize...

scale=$1
dir=$2
threads=$3

binary=/usr/local/bin/dsdgen
# annoying..
cd /root

# iterate through each thread.

for t in `seq $threads`; do
   echo "kicking off thread $t"
   $binary -scale $scale -dir $dir -parallel $threads -child $t >/dev/null 2>/dev/null &
   genpids="$genpids $!"
done

# wait for the threads to finish

for pid in $genpids; do
    wait $pid || let "RESULT=1"
done

if [ "$RESULT" == "1" ]; then
    exit 1
fi

echo "all jobs done"

