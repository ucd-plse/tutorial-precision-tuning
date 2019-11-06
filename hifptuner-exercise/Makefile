CC = /root/llvm-3.0/bin/clang
CFLAGS = -emit-llvm -c
LOGGING_PATH=${HIFP_PRECI}/logging
LLVM_PATH=/root/llvm-3.0/bin

default: simpsons

simpsons: simpsons.c

	$(CC) $(CFLAGS) -I$(LOGGING_PATH) -Wno-unused-value simpsons.c -o simpsons.bc
	$(LLVM_PATH)/opt -O2 simpsons.bc -o original_simpsons.bc
	$(LLVM_PATH)/llc original_simpsons.bc -o original_simpsons.s
	$(LLVM_PATH)/clang original_simpsons.s -L$(LOGGING_PATH) -lm -llog -o original_simpsons.out

	$(CC) $(CFLAGS) -I$(LOGGING_PATH) -Wno-unused-value simpsons_lightweight.c -o simpsons_lightweight.bc

clean:
	rm -rf *.bc *~ *.json *.s *.dd *.out *.dot output.txt log.cov sat.cov score.cov temp_simpsons m_simpsons results-* time.txt

