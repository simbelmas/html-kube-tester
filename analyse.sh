#!/bin/zsh -e

# This script asserts that init.sh workload script is left as is.


script_dir=$(dirname $(readlink -f ${0}))
results_file=${script_dir}/analyse_results.csv
tmp_headers_file=${script_dir}/analyse_request_headers

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

cleanup() {
    if [ -e "${tmp_headers_file}" ] ; then
        rm -v ${tmp_headers_file}
    fi
    echo Ingress statistics can be viewed in ${results_file}
}

echo Launching test, press CTRL+C to exit

# Defining cleannup onn sigint
trap cleanup 2

while true ; do
    request_date=$(date '+%s')
    request_data="$(curl -m 2 -s -w "%output{$tmp_headers_file}%{time_total};%{http_code}" -k "${analyse_url}" | tr -d "\r" |tr -d "\n" | tr -d ";")"
    request_headers=$(cat ${tmp_headers_file})
    echo "${request_date};${request_headers};${request_data}" | tee -a ${results_file}
    sleep 1
done