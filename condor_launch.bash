#!/bin/bash

# Este script ejecuta en el cluster usando el planificador condor
# tantas instancias del simulador multi2sim como benchmarks haya en el fichero benchmarks.lst
# Se le puede pasar un argumento y este se añadirá a los directorios de resultados,
# que se generaran en el directorio de la práctica. Los directorios generados son reports, stdout y stderr,
# con los reportes de estadísticas de la memoria y la CPU, la salida estandar y la salida
# de error de los benchmarks, respectivamente.

# Variables de entorno, ajustar si es necesario
PRA="$HOME/atp/pra1"
M2S="$PRA/multi2sim-4.2/bin/m2s"

# Crear directorios de salida
rm -rf $PRA/reports$1
mkdir $PRA/reports$1

rm -rf $PRA/stdout$1
mkdir $PRA/stdout$1

rm -rf $PRA/stderr$1
mkdir $PRA/stderr$1

# Generar fichero condor
echo +GPBatchJob = true > launch.condor.tmp
echo +LongRunningJob = true >> launch.condor.tmp
echo Executable = $M2S >> launch.condor.tmp
echo Universe = vanilla >> launch.condor.tmp
echo Rank = -LoadAvg >> launch.condor.tmp
echo 'Environment = "LD_LIBRARY_PATH=$ENV(LD_LIBRARY_PATH) PRA='"$PRA"'"' >> launch.condor.tmp
while read bench; do
	echo >> launch.condor.tmp
	echo -n "Arguments = " >> launch.condor.tmp
	echo --x86-sim detailed --x86-config $PRA/configs/cpuconfig.1c1t.conf --mem-config $PRA/configs/memconfig.1c1t.L1idL2.conf --x86-max-inst 1000000  --ctx-config $PRA/configs/ctxconfigs/ctxconfig.$bench --x86-report $PRA/reports$1/${bench}.x86_report.out --mem-report $PRA/reports$1/${bench}.mem_report.out >> launch.condor.tmp
	echo Output = $PRA/stdout$1/$bench.stdout >> launch.condor.tmp
	echo Error = $PRA/stderr$1/$bench.stderr >> launch.condor.tmp
	echo Queue >> launch.condor.tmp
done < $PRA/benchmarks.lst
echo >> launch.condor.tmp

# Lanzar condor
condor_submit launch.condor.tmp

