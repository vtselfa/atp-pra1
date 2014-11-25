#!/bin/bash
PRA="."

#while read bench; do
#	for line in $(grep Dispatch.Stall reports$1/${bench}.x86_report.out | tail -8 | sed 's/ = /,/g;s/Dispatch\.Stall\.//g' | grep -v ctx); do
#		echo $bench,$line
#	done
#done < $PRA/benchmarks.lst > $PRA/data${1}.csv

{
echo -n "cause "
while read bench; do
        echo -n $bench" " 
done < $PRA/benchmarks.lst 
echo
for cause in used spec uop_queue rob iq lsq rename; do
        echo -n $cause" "
        while read bench; do
                echo -n $(grep Dispatch.Stall.${cause} reports$1/${bench}.x86_report.out | tail -1 | perl -lane 'print $F[2]')" "
        done < $PRA/benchmarks.lst
        echo
done
} > $PRA/data${1}.csv

