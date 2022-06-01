#include <stdio.h>
#include <string.h>
#define N 2400000
#define OFFSET 100

int main() {
	char fname[] = "/home/abraham/github/medium-technica/sdr-codes/include/testhex.bin";
	FILE *fp = fopen(fname, "rb");
	if (fp == NULL) {
		printf("Error opening file: %s\n", fname);
	}
	
	short i[N], q[N];
	fseek(fp, OFFSET, SEEK_SET);
	for (long n=0; n<N; n++) {
		if ((fread(i+n, sizeof(short), 1, fp) == 1) && (fread(q+n, sizeof(short), 1, fp) == 1))
			printf("%ld: %d\t%di\n", n, i[n], q[n]);
		else
			printf("Error reading file: %s\n", fname);
	}
	
	return 0;
}
