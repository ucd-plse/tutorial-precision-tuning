# SC19 Precision Tuning Tutorial

#### Precimonious source: https://github.com/ucd-plse/precimonious
#### HiFPTuner source: https://github.com/ucd-plse/HiFPTuner

## Build Precimonious and HiFPTuner via docker
### Pull Docker Image from Docker Hub
```
docker pull ucdavisplse/precision-tuning
docker run -ti --name=precision-tuning ucdavisplse/precision-tuning
```
###  Or Build Docker Image by Yourself
```
git clone https://github.com/ucd-plse/tutorial-precision-tuning.git
cd tutorial-precision-tuning 
docker build -t docker-precision-tuning .
docker run -ti --name=precision-tuning docker-precision-tuning
```

## Precimonious Exercises

__(For more detailed instructions on how to run Precimonious that may be
helpful for those looking to modify parameters or adapt the precision
search to another target, see `Note` below)__

### Exercise : simpsons
Change to working directory
```
cd /root/precimonious/exercise-1
```
Creates LLVM bitcode file and optimized executable for later use
```
make clean
make
```
Run analysis on simpsons. The number of configurations will depend on the machine used for the experiment. The number of configurations usually ranges from 70 to 110.
```
./run-analysis.sh simpsons
```
You can find all output files at:
```
ls results
```
Apply result configuration
```
./run-config.sh simpsons
```
Compare performance
```
time ./original_simpsons.out
time ./tuned_simpsons.out
```
Reference results
```
ls reference
```
### Exercise 2 : funarc
Steps for Exercise-2 are similar to Exercise-1
```
cd /root/precimonious/exercise-2
make clean
make
./run-analysis.sh funarc
./run-config.sh funarc
time ./original_funarc.out
time ./tuned_funarc.out
```
## HiFPTuner Exercises
### Exercise : simpsons
Change to working directory
```
cd /root/HiFPTuner/exercise-1
```
Create LLVM bitcode file for simpsons, "simpsons.bc" 
(the generated executable, "original_simpsons.out", will be used later for performance comparison)
```
make clean
make
```
Run HiFPTuner on "simpsons.bc"
```
./run-hifptuner.sh simpsons
```
You can find all output files at:
```
./results-hifptuner
  result file
  - dd2_valid_simpsons.bc.json   : the precision configuration file HiFPTuner generated for simpsons
  log files
  - log.txt, log                 : search log of HiFPTuner
  - sorted_partition.json        : the community structure of floating-point variables
  - auto-tuning_analyze_time.txt : dependence analysis time
  - auto-tuning_config_time.txt  : community detecton time
```
Generate the tuned executable : "hifptuner_tuned_simpsons.out"
```
./run-config.sh simpsons
```
Now time the execution of the original executable and the tuned executable and observe the seepup.
```
time ./original_simpsons.out
time ./hifptuner_tuned_simpsons.out
```
-------------------------------------------
Compare HiFPTuner with Precimonious:

Run Precimonious on "simpsons.bc"
```
./run-preci.sh simpsons
```
You can find all output files at:
```
./results-preci
  result file
  - dd2_valid_simpsons.bc.json   : the precision configuration file Precimonious generated for simpsons
  log files
  - log.txt, log                 : search log of Precimonious
```
Generate the tuned executable: "preci_tuned_simpsons.out"
```
./run-config.sh simpsons
```
Time the execution of the tuned executable of HiFPTuner and Precimonious, and compare them:
```
time ./original_simpsons.out
time ./hifptuner_tuned_simpsons.out
time ./preci_tuned_simpsons.out
```
Compare the search time of HiFPTuner and Precimonious:
```
cat results-hifptuner/log.txt
cat results-preci/log.txt
```
### Exercise 2: funarc
Exercise 2 contains test "funarc.c" and its configuration files and can be run with the same steps shown in Exercise 1
```
cd /root/HiFPTuner/exercise-2
make clean
make

./run-hifptuner.sh funarc
./run-config.sh funarc
time ./original_funarc.out
time ./hifptuner_tuned_funarc.out

./run-preci.sh funarc
./run-config.sh funarc
time ./original_funarc.out
time ./preci_tuned_funarc.out
time ./hifptuner_tuned_funarc.out
cat results-preci/log.txt
cat results-hifptuner/log.txt
```

## Note: More Detailed Instructions for Running Precimonious

For the following instructions, note that `$(TARGET)` refers to the
name of the target source code file without its file extension, i.e.
`simpsons.c` becomes `simpsons`.

0. Target source code must be annotated with code for checking
   error thresholds, measuring timing, logging results, and dummy
   calls to any lowered-precision functions that are candidates for
   switching out with existing calls. See source code of examples.
1. Annotated source code, auxiliaries, and
   utilities must be compiled to bitcode and then linked to generate
   `$(TARGET).bc`. See slides-sc19.pdf and Makefile of examples.
   For example, if working on Precimonious Exercise: simpsons, the error threshold can be changed by anonotate file `$simpsons.c` in two steps:
   - change the `epsilon` value in the line `long double epsilon = -8.0;`
   - uncomment the line `// cov_spec_log("spec.cov", threshold, 1, (long double)s1);`
2. Remove file `spec.cov`, if it exists. 
3. Execute `original_$(TARGET).out` to do one-time generation of
   `spec.cov` which contains error threshold information for the
   ensuing execution of the Precimonious search.
4. Comment out generating line of code for `spec.cov` in `$(TARGET)`
   source code. This line contains a call to the function `cov_spec_log()`.
5. Repeat step 1 to recompile and relink target source code,
   auxiliaries, and utilities.
6. Execute `$CORVETTE_PATH/scripts/dependencies.sh $(TARGET)
   $(TARGET_FUNC)` to generate `include.txt` and `include_global.txt`
   which contain lists of discovered functions and global variables to be
   included in the search space. For the examples, `$(TARGET_FUNC)` is
   `main`.
7. Manually create `exclude.txt` and `exclude_local.txt` which contain
   lists of functions and local variables to be excluded from the
   search space.
8. If running one of the examples, execute the included
   `run-analysis.sh` script a la `./run-analysis.sh $(TARGET)`. This
   script performs the following actions (along with pretty-printing
   results):
    - ensures correct environment variables are set for LLVM and
     Precimonious scripts
    - creates a JSON file containing the initial configuration via
      `$CORVETTE_PATH/scripts/pconfig.sh $(TARGET)`
    - creates a JSON file detailing the search space via
      `$CORVETTE_PATH/scripts/search.sh $(TARGET)`
    - runs the search via `$CORVETTE_PATH/scripts/dd2.py $(TARGET).bc
      search_$(TARGET).json config_$(TARGET).json`
   
   The above steps may be run individually.
