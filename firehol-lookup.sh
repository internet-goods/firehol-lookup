#!/bin/bash
#creates csv lookups from firehol ip nightly
#todo build process from https://www.recordedfuture.com/threat-intelligence-lifecycle/
#1Direction: First, the objectives of this intelligence cycle must be defined, generally by an authoritative figure. Objectives are identified based on certain essential elements of information (EEIs) needed to make timely and accurate decisions. Those EEIs might include things like the nature of the attack, the actors involved, the space where an attack will happen, and so on.

RUNDATE="$(date "+%Y-%m-%d")"
echo $RUNDATE
#2Collection: Next, in response to the criteria laid out in the EEIs, data is gathered from multiple sources, including human intelligence, imagery, electronic sources, intercepted signals, or publicly available sources.
git clone https://github.com/firehol/blocklist-ipsets $RUNDATE
cd $RUNDATE

#3Processing: After data is gathered, it must be processed into a comprehensible form. That can include translating it from a foreign language, decrypting it, or sorting data based on how reliable or relevant it is.
echo "dest_ip,threat_list_name" > firehol-lookup.csv
for netsetfilename in *.*set; do
#make csv lookup file, remove internal ips since we use this for more than just egress filtering
    echo Generating $netsetfilename.csv
    cat $netsetfilename |awk -v env_var="$netsetfilename" '{print $0","env_var}' > $netsetfilename.csv
    cat $netsetfilename.csv >> firehol-lookup.raw
done

echo "dest_ip,threat_list_name" > firehol-lookup.csv
cat firehol-lookup.raw >> firehol-lookup.csv

#5Dissemination: The finished product of this process must get to the right hands to be effective, so the intelligence cycle must loop back upon itself. These reports and assessments are delivered to clients or the leadership who commissioned the cycle in the first place.

#6Feedback: After review of this new intelligence, authority figures will take action, including issuing new directions to gather further intelligence. The process is refined with the aim of producing more accurate, relevant, and timely assessments based on the success of previous intelligence.

