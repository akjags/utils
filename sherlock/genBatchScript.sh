#!/bin/bash

jobName=$1
suid=$2
logDir=$3
runtime=$4
numNodes=$5
memory=$6
jobFile=$7
email="$suid@stanford.edu"

jobText=`cat ${jobFile}`

script1="#!/bin/bash\n#\n#SBATCH --job-name=${jobName}\n#SBATCH --output=${logDir}/${jobName}.%j.out\n#SBATCH --error=${logDir}/${jobName}.%j.err\n#SBATCH --time=${runtime}\n#SBATCH --qos=long\n#SBATCH -p normal\n#SBATCH --nodes=${numNodes}\n#SBATCH --mem=${memory}\n#SBATCH -c 1\n#SBATCH --mail-type=END,FAIL\n#SBATCH --mem-per-cpu=8000\n#SBATCH --mail-user=$email\nmodule load matlab/R2014b\nmatlab -nodesktop <<EOF\n ${jobText}\nEOF"

echo $script1 > $jobName.sbatch
