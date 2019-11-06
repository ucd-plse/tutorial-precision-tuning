CC = /root/llvm-3.0/bin/clang
CFLAGS = -emit-llvm -c
LOGGING_PATH=${HIFP_PRECI}/logging
LLVM_PATH=/root/llvm-3.0/bin

default: funarc

funarc: funarc.c

	$(CC) $(CFLAGS) -I$(LOGGING_PATH) -Wno-unused-value funarc.c -o funarc.bc
	$(LLVM_PATH)/opt -O2 funarc.bc -o original_funarc.bc
	$(LLVM_PATH)/llc original_funarc.bc -o original_funarc.s
	$(LLVM_PATH)/clang original_funarc.s -L$(LOGGING_PATH) -lm -llog -o original_funarc.out

	$(CC) $(CFLAGS) -I$(LOGGING_PATH) -Wno-unused-value funarc_lightweight.c -o funarc_lightweight.bc

clean:
	rm -rf *.bc *~ *.json *.s *.dd *.out *.dot output.txt log.cov sat.cov score.cov temp_funarc m_funarc results-* time.txt

