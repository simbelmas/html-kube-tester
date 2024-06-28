#!/bin/zsh -e

# This script asserts that init.sh workload script is left as is.

date_format='+%s'

script_dir=$(dirname $(readlink -f ${0}))
results_file=${script_dir}/analyse_results.csv
tmp_headers_file=${script_dir}/analyse_request_headers

if [[ -z "${1}" ]] ; then
    echo "First parameter must be url"
    exit 1
else
    analyse_url=${1}
fi

cleanup() {
    if [ -e "${tmp_headers_file}" ] ; then
        rm -v ${tmp_headers_file}
    fi
    echo Ingress statistics can be viewed in ${results_file}
}

insert_event () {
    insert_date=$(date ${date_format})
    echo "${insert_date};;;;2;\"Event from SIGUSR1\"" | tee -a ${results_file}
}

# Signnals handling
trap cleanup 2
trap insert_event 30

# Explanations
echo Process id to send signal is $$
echo To insert event in log, send SIGUSR1 to $$
echo following command cann be used: kill -s SIGUSR1 $$
echo
echo Launching test, press CTRL+C to exit
echo

# Result file handling
if [[ "${2}" == "keep_results" ]] ; then
    keep_results=true
else
    keep_results=false
    echo '"Date (Epoch)";"Request duration";"HTTP Response code";"App availability";"Event";"Response content"' | tee ${results_file}
fi

# Statistics generation
while true ; do
    request_date=$(date ${date_format})
    request_data="$(curl -m 2 -s -w "%output{$tmp_headers_file}%{time_total};%{http_code}" -k "${analyse_url}" | tr -d "\r" |tr -d "\n" | tr -d ";")"
    request_headers=$(cat ${tmp_headers_file})
    response_success=$( [[ "$(echo ${request_headers} | cut -f2 -d';')" == "200" ]] && echo 1 || echo 0)
    echo "${request_date};${request_headers};${response_success};;\"${request_data}\"" | tee -a ${results_file}
    sleep 1
done