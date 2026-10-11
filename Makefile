YES ?= yes ./y
BENCH_BYTES ?= 10000000000

y: y.S ycc
	./ycc -o $@ $<

.PHONY: bench
bench: y
	@for yes in $(YES); do \
		echo "$$yes: $(BENCH_BYTES) bytes"; \
		time $$yes | head -c $(BENCH_BYTES) > /dev/null; \
		echo; \
	done

.PHONY: clean
clean:
	rm -f y
