CFLAGS = -msse2 --std gnu99 -O0 -Wall

GIT_HOOKS := .git/hooks/pre-commit

format:
	astyle --style=kr --indent=spaces=4 --indent-switches --suffix=none *.[ch]

perf: sse_analysis
	# drop cache
	echo "echo 1 > /proc/sys/vm/drop_caches" | sudo sh
	# **** 3 line => sse_prefetch , sse , naive ****
	# perf.analysis => store perf , sse.exec => execution time
	3>perf.analysis \
	perf stat -r 100 -e cache-misses,cache-references,L1-dcache-load-misses,L1-dcache-store-misses,L1-dcache-prefetch-misses,L1-icache-load-misses \
	--log-fd 3 \
	./sse_analysis \ > sse.txt
	# plot
	gnuplot plot/exec.gp

all: $(GIT_HOOKS) sse_analysis

debug: $(GIT_HOOKS) main.c
	$(CC) $(CFLAGS) -DDEBUG -o sse_debug main.c

sse_analysis: $(GIT_HOOKS) main.c
	$(CC) $(CFLAGS) -DANALYSIS -o sse_analysis main.c

$(GIT_HOOKS):
	@scripts/install-git-hooks
	@echo

clean:
	$(RM) sse_analysis *.analysis *.txt *.png
