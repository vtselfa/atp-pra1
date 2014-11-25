#!/bin/bash

# Este script ejecuta tantas instancias del simulador multi2sim como benchmarks haya en el fichero benchmarks.lst
# Se le puede pasar un argumento y este se añadirá a los directorios de resultados,
# que se generaran en el directorio de la práctica. Los directorios generados son reports, stdout y stderr,
# con los reportes de estadísticas de la memoria y la CPU, la salida estandar y la salida
# de error de los benchmarks, respectivamente.

# Variables de entorno, ajustar si es necesario
PRA="."
M2S="$PRA/multi2sim/bin/m2s"

# Crear directorios de salida
rm -rf $PRA/reports$1
mkdir $PRA/reports$1

rm -rf $PRA/stdout$1
mkdir $PRA/stdout$1

rm -rf $PRA/stderr$1
mkdir $PRA/stderr$1

while read bench; do
        $M2S --x86-sim detailed --x86-config $PRA/configs/cpuconfig.1c1t.conf --mem-config $PRA/configs/memconfig.1c1t.L1idL2.conf --x86-max-inst 1000000 --ctx-config $PRA/configs/ctxconfigs/ctxconfig.$bench --x86-report $PRA/reports$1/${bench}.x86_report.out --mem-report $PRA/reports$1/${bench}.mem_report.out >$PRA/stdout$1/$bench.stdout 2>$PRA/stderr$1/$bench.stderr
done < $PRA/benchmarks.lst
