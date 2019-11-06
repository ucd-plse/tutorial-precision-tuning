#!/bin/bash

# environment variables
export PATH=/root/llvm-3.0/bin:$PATH
export LD_LIBRARY_PATH=/root/llvm-3.0/lib:$LD_LIBRARY_PATH
export HIFP_PRECI=/root/HiFPTuner/precimonious

echo "Run the following to compare performance:"
echo "time ./original_$1.out"

# apply suggested configuration to bitcode file
if [ -d "results-hifptuner" ]; then
    #echo "** Applying HiFPTuner configuration" 
    $HIFP_PRECI/scripts/main.py $1.bc results-hifptuner/dd2_valid_$1.bc.json &>/dev/null
    mv $1.bc.out hifptuner_tuned_$1.out
    echo "time ./hifptuner_tuned_$1.out"
fi

if [ -d "results-preci" ]; then
    #echo "** Applying precimonious configuration" 
    $HIFP_PRECI/scripts/main.py $1.bc results-preci/dd2_valid_$1.bc.json &>/dev/null
    mv $1.bc.out preci_tuned_$1.out
    echo "time ./preci_tuned_$1.out"
fi
