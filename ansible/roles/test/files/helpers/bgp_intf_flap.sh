#!/bin/bash
#
# bgp-nei-flap.sh
# function: to up down the bgp neighbors interfaces 
#           for special times
# author: Vincent Meng
# date: 2019-10-15 16:30:30
# modified: 
###########################################################

function usage
{
    echo -e "\n"
    echo "bgp-nei-flap.sh used for to run continuing up/down the bgp neighbor interfaces."
    echo "Usage example:"
    echo "    ./bgp-nei-flap.sh <flap_times> <flap-intval> <start-nei-num> <end-nei-num>"
    echo "    flap_times -- the all up/down neighbors times in this schedule;"
    echo "    flap-intval -- the up down down actions schedule interval seconds;"
    echo "    start-nei-num -- the schedule up/down neighbor first number;"
    echo "    end-nei-num -- the schedule up/down neighbor end number;"
    echo -e "\n"
}

function bgp_nei_down
{
    if=$flap_fnei_num
    while(( $if<=$flap_enei_num ))
    do
	tmp_if=`expr $if \* 4`
        sudo ip link set dev Ethernet$tmp_if down
	let "if++"
    done
}

function bgp_nei_up
{
    if=$flap_fnei_num
    while(( $if<=$flap_enei_num ))
    do
	tmp_if=`expr $if \* 4`
        sudo ip link set dev Ethernet$tmp_if up
	let "if++"
    done
}

flap_times=$1
flap_int=$2
flap_fnei_num=$3
flap_enei_num=$4

i=1

if (( $# < 4 ))
then
    usage
else
    while(( $i <= $flap_times ))
    do
        let "i++"
        bgp_nei_down
        sleep $flap_int
        bgp_nei_up
        sleep $flap_int
   done
fi
