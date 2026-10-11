YES ?= yes
BENCH_BYTES ?= 10000000000

.PHONY: bench
bench:
	@echo "$(YES): $(BENCH_BYTES) bytes"
	@time $(YES) | head -c $(BENCH_BYTES) > /dev/null
