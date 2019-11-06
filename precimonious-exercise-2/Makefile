CC = /root/llvm-3.0/bin/clang
CFLAGS = -emit-llvm -c
LOGGING_PATH=/root/precimonious/logging/
LLVM_PATH=/root/llvm-3.0/bin

default: funarc

funarc: funarc.c

	$(CC) $(CFLAGS) -I$(LOGGING_PATH) -Wno-unused-value funarc.c -o temp_funarc.bc
	$(CC) $(CFLAGS) $(LOGGING_PATH)/cov_checker.c -o cov_checker.bc
	$(CC) $(CFLAGS) $(LOGGING_PATH)/timers.c -o timers.bc
	$(CC) $(CFLAGS) $(LOGGING_PATH)/cov_serializer.c -o cov_serializer.bc
	$(CC) $(CFLAGS) $(LOGGING_PATH)/cov_log.c -o cov_log.bc
	$(CC) $(CFLAGS) $(LOGGING_PATH)/cov_rand.c -o cov_rand.bc

	$(LLVM_PATH)/llvm-link -o funarc.bc temp_funarc.bc cov_checker.bc cov_serializer.bc cov_log.bc cov_rand.bc timers.bc

	$(LLVM_PATH)/opt -O2 funarc.bc -o original_funarc.bc
	$(LLVM_PATH)/llc original_funarc.bc -o original_funarc.s
	$(LLVM_PATH)/clang original_funarc.s -lm -o original_funarc.out

clean:
	rm -rf *.bc *~ *.json *.s *.dd *.out output.txt log.cov sat.cov score.cov temp_funarc m_funarc results

