#!/bin/zsh -e

# This script asserts that init.sh workload script is left as is.


script_dir=$(dirname $(readlink -f ${0}))
results_file=${script_dir}/analyse_results.csv

if [[ -z "${1}" ]] ; then
    echo "First parameter must be url"
    exit 1
else
    analyse_url=${1}
fi

if [[ "${2}" == "keep_results" ]] ; then
    keep_results=true
else
    keep_results=false
    echo '' > ${results_file}
fi

echo Launching test, press CTRL+C to exit

while true ; do
    echo "$(date -Iseconds);$(curl -m 2 -s -w ";%{time_total};%{http_code}" -k "${analyse_url}" | tr -d "\n")" | tee -a ${results_file}
    sleep 1
done