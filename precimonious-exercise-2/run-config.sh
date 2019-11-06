#!/bin/bash

# environment variables
export PATH=/root/llvm-3.0/bin:$PATH
export LD_LIBRARY_PATH=/root/llvm-3.0/lib:$LD_LIBRARY_PATH
export CORVETTE_PATH=/root/precimonious

# apply suggested configuration to bitcode file
echo "** Applying precimonious configuration" 
$CORVETTE_PATH/scripts/main.py $1.bc results/dd2_valid_$1.bc.json
mv $1.bc.out tuned_$1.out
echo "Run the following to compare performance:"
echo "time ./original_$1.out"
echo "time ./tuned_$1.out"
