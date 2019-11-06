#!/bin/bash

# environment variables
export PATH=/opt/llvm-3.0/bin:$PATH
export LD_LIBRARY_PATH=/opt/llvm-3.0/lib:$LD_LIBRARY_PATH

# building and testing precimonious
cd precimonious/src
scons --config=force -U
scons -U test

# clean build
#scons -Uc
#scons -Uc test
