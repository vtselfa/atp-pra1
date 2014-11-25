#!/bin/bash
PRA="."

while read bench; do
	for line in $(grep Dispatch.Stall reports$1/${bench}.x86_report.out | tail -8 | sed 's/ = /,/g;s/Dispatch\.Stall\.//g' | grep -v ctx); do
		echo $bench,$line
	done
done < $PRA/benchmarks.lst > $PRA/data${1}.csv

