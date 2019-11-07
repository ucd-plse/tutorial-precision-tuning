# SC19 Precision Tuning Tutorial

## Build Precimonious and HiFPTuner via docker
### Pull Docker Image from Docker Hub
```
docker pull ucdavisplse/precision-tuning
docker run -ti --name=precision-tuning hguo15/precision-tuning
```
###  Or Build Docker Image by Yourself
```
git clone https://github.com/ucd-plse/tutorial-precision-tuning.git
cd tutorial-precision-tuning 
docker build -t docker-precision-tuning .
docker run -ti --name=precision-tuning docker-precision-tuning
```

## Precimonious Exercises
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
Exercise 2 contains test "funarc.c" and its configuration files and can be run with the same steps shown in Exercise 1.
