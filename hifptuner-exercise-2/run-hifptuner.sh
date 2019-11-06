#!/bin/bash

# environment variables
export PATH=/root/llvm-3.0/bin:$PATH
export LD_LIBRARY_PATH=/root/llvm-3.0/lib:$LD_LIBRARY_PATH
export HIFP_PRECI=/root/HiFPTuner/precimonious
export HIFPTUNER_PATH=/root/HiFPTuner

#### 1. detect communities and generate corresponding configuration files
# link to json library 
$HIFPTUNER_PATH/scripts/compile.sh $1_lightweight.bc

# run dependence analysis 
export PATH=/root/llvm-3.8/bin:$PATH
export LD_LIBRARY_PATH=/root/llvm-3.8/lib:$LD_LIBRARY_PATH
$HIFPTUNER_PATH/scripts/analyze.sh json_$1_lightweight.bc

# detect communities
$HIFPTUNER_PATH/scripts/config.sh


#### 2. dynamic tuning
# create precision configuration file
export PATH=/root/llvm-3.0/bin:$PATH
export LD_LIBRARY_PATH=/root/llvm-3.0/lib:$LD_LIBRARY_PATH
$HIFP_PRECI/scripts/pconfig.sh $1 .

# create search space
$HIFP_PRECI/scripts/search.sh $1 .

# run analysis
python -O $HIFP_PRECI/scripts/dd2_prof.py $1.bc search_$1.json config_$1.json sorted_partition.json

#### 3. save log and result files
rm -rf results-hifptuner; mkdir results-hifptuner
nconf=`cat log.dd | wc -l` 
nconf=`expr $nconf - 1`
nvalid=`cat log.dd | grep ": VALID" | wc -l`
ninvalid=`cat log.dd | grep ": INVALID" | wc -l`
nfail=`cat log.dd | grep ": FAIL" | wc -l`
echo -e "\n\n"
echo -e "Number of configurarions explored by HiFPTuner:\n" 
echo -e "  TOTAL: $nconf\n"
echo "   --VALID   $nvalid"
echo "   --INVALID $ninvalid"
echo "   --FAILED  $nfail"

echo -e "Number of configurarions explored by HiFPTuner:\n" >log.txt
echo -e "  TOTAL: $nconf\n" >>log.txt
echo "   --VALID   $nvalid" >>log.txt
echo "   --INVALID $ninvalid" >>log.txt
echo "   --FAILED  $nfail" >>log.txt

mv auto-tuning_analyze_time.txt auto-tuning_config_time.txt sorted_partition.json results-hifptuner/ 2>/dev/null
mv partition.json topolOrder_pro.json varDepPairs_pro.json edgeProfilingOut.json results-hifptuner/ 2>/dev/null
mv VALID*.json INVALID*.json FAIL*.json dd2*.json config_temp.json log.cov log.dd log.txt output.txt results-hifptuner/ 2>/dev/null
rm -rf config_temp.json *.s *.dd *.dot output.txt log.cov sat.cov score.cov temp_funarc m_funarc time.txt
