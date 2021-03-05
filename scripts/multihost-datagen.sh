#!/usr/bin/bash

# the point is to parallelize...
# this is a hack.  Basically, run this on each client
# with args: scale dir threads totalthreads client-id
# threads = number of threads on this host to use
# totalthreads = total across all clients. you gotta use math for this :)
# client-id : if you have 10 clients, then the number should be one of 1,2,3..10.  you gotta keep track on your own
# can probably make this smarter by having a wrapper do the control..one day.


scale=$1
dir=$2
threads=$3
totalthreads=$4
clientid=$5

binary=/usr/local/bin/dsdgen
# this is because the tsidx file needs to exist in the CWD.
cd /root


#lets say totalthreads=512, and each client does 64.  
# if i'm on client-1, then i'd want to run -child 1..64.
# if i'm on client-2, 65..128
# 

#lazy stuff
step=$(($threads - 1))

if [ $clientid == 1 ] ; then

    childstart=1
else
    childstart=$(($clientid * $threads - $step))
fi 


# iterate through each thread.

for t in `seq $threads`; do
   echo "kicking off thread $t"
   $binary -scale $scale -dir $dir -parallel $totalthreads -child $childstart >/dev/null 2>/dev/null &
     ((childstart=childstart+1))
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

