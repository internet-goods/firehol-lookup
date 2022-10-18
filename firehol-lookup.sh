#!/bin/bash
RUNDATE="$(date "+%Y-%m-%d")"
echo $RUNDATE
mkdir $RUNDATE
cd $RUNDATE
echo "dest_ip,threat_list_name" > firehol-lookup.csv
for netsetfilename in *.*set; do
#make csv lookup file, remove internal ips since we use this for more than just egress filtering
    echo Generating $netsetfilename.csv
    cat $netsetfilename |awk -v env_var="$netsetfilename" '{print $0","env_var}' > $netsetfilename.csv
    cat $netsetfilename.csv >> firehol-lookup.raw
done

echo "dest_ip,threat_list_name" > firehol-lookup.csv
cat firehol-lookup.raw >> firehol-lookup.csv
