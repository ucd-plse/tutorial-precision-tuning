#!/bin/bash

# environment variables
export PATH=/opt/llvm-3.0/bin:$PATH
export LD_LIBRARY_PATH=/opt/llvm-3.0/lib:$LD_LIBRARY_PATH
export CORVETTE_PATH=$HOME/Module-Precimonious/precimonious

# create include.txt and include_global.txt
$CORVETTE_PATH/scripts/dependencies.sh $1 main .
