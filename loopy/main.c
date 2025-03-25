#include "stdio.h"
#include "stdlib.h"
#include "stdint.h"
#include "time.h"

int main(int argc, char** argv) {
	int u = atoi(argv[1]);
	srand(time(NULL));
	int r = rand() % 10000;
	int32_t a[10000] = {0};
	for (int i = 0; i < 10000; i += 1) {
		for (int j = 0; j < 100000; j += 1) {
			a[i] = a[i] + j%u;
		}
		a[i] += r;
	}
	printf("%d\n", a[r]);
}
