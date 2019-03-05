#include "stdio.h"
#include "string.h"
#include "stdlib.h"
#include <sys/time.h>

void memcpy_speed(unsigned long count, unsigned long buf_size, unsigned long iters){
	struct timeval start, end;
	unsigned char * buf1;
	unsigned char * buf2;

	buf1 = malloc(buf_size);
	buf2 = malloc(buf_size);

	memset(buf1, 1, buf_size);
	memset(buf2, 0, buf_size);

	gettimeofday(&start, NULL);
	for(int i = 0; i < iters; ++i){
		memcpy(buf2, buf1, buf_size);
	}   
	gettimeofday(&end, NULL);

	printf("%lu. %lu iteration(s)\n", count, iters);
	printf("- Total elapsed time 	= %5lu	us\n", end.tv_usec - start.tv_usec);
	printf("- Average latency 	= %5lu	ns\n", (end.tv_usec - start.tv_usec) * 1000 / iters);	
	printf("- Average speed		= %5.3f	MB/s\n", ((buf_size * iters) / (1.024 * 1.024)) / ((end.tv_sec - \
		start.tv_sec) * 1000 * 1000 + (end.tv_usec - start.tv_usec)));
	
	free(buf1);
	free(buf2);
}

void main() {
	unsigned long page_size[3] = {4096, 8192, 16384};
	unsigned long count[3] = {1, 1024, 10000};
	
	for (int i = 0; i < 3; i++) {
		printf("\n==================== %lu B page ====================\n", page_size[i]);

		for (int j = 0; j < 3; j++) {
			memcpy_speed(j + 1, page_size[i], count[j]);
		}
	}
}
