#!/bin/bash

# environment variables
export PATH=/root/llvm-3.0/bin:$PATH
export LD_LIBRARY_PATH=/root/llvm-3.0/lib:$LD_LIBRARY_PATH
export CORVETTE_PATH=/root/precimonious

# create configuration file
$CORVETTE_PATH/scripts/pconfig.sh $1 .

# create search space
$CORVETTE_PATH/scripts/search.sh $1 .

# run analysis
$CORVETTE_PATH/scripts/dd2.py $1.bc search_$1.json config_$1.json

# move results
rm -rf results
mkdir results
nconf=`cat log.dd | wc -l` 
nvalid=`cat log.dd | grep ": VALID" | wc -l`
ninvalid=`cat log.dd | grep ": INVALID" | wc -l`
nfail=`cat log.dd | grep ": FAIL" | wc -l`
echo -e "\n\n"
echo -e "Number of configurarions explored by Precimonious:\n" 
echo -e "  TOTAL: $nconf\n"
echo "   --VALID   $nvalid"
echo "   --INVALID $ninvalid"
echo "   --FAILED  $nfail"

echo -e "Number of configurarions explored by Precimonious:\n" >log.txt 
echo -e "  TOTAL: $nconf\n" >>log.txt
echo "   --VALID   $nvalid" >>log.txt
echo "   --INVALID $ninvalid" >>log.txt
echo "   --FAILED  $nfail" >>log.txt

mv -f VALID*.json INVALID*.json FAIL*.json dd2*.json config_temp.json log.cov log.dd log.txt output.txt results/ 2>/dev/null
