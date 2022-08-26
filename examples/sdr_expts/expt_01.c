#include <stdio.h>
#include <math.h>
#include <limits.h>
#include <stdlib.h>
#include <time.h>

#define SAMPLES_PER_SECOND 8000

int main(int argc, char *argv[]) {
	int* frequency = (int*)malloc(1 * sizeof(int));
	frequency[0] = 440;
	unsigned int nFreqComponents = 1;
	float duration = 1;
	float volume = 0.1;
	switch (argc) {
		case 2:
			frequency[0] = (int)atoi(&argv[1][0]);
			break;
		case 3:
			frequency[0] = (int)atoi(&argv[1][0]);
			duration = (float)atof(&argv[2][0]);
			break;
		case 4:
			frequency[0] = (int)atoi(&argv[1][0]);
			duration = (float)atof(&argv[2][0]);
			volume = (float)atof(&argv[3][0])/100; 
		default:
			break;
	}
		
	if (argc > 4) {
		free(frequency);
		nFreqComponents = argc - 3;
		frequency = (int*)malloc(nFreqComponents * sizeof(int));
		duration = (float)atof(&argv[argc-2][0]);
		volume = (float)atof(&argv[argc-1][0])/100;
		for (int j=0; j<nFreqComponents; j++) {
			frequency[j] = (int)atoi(&argv[j+1][0]);
		}
	}
	/*
	for (int j=0; j<nFreqComponents; j++) {
		printf("Frequency %d = %d\n", j+1, frequency[j]);
	}
	
	printf("Volume = %f, Duration = %f\n",volume, duration); 
	*/
	/*
	for (int i=0; i<argc; i++) {
		printf("%d, %i\n", i, atoi(&argv[i][0]));
	}
	printf("%d, %f\n", frequency, volume);
	*/
	//clock_t clocks_begin = clock();
	//double seconds_elapsed = 0;
	//double tick = 0;
	
	double t = 0;
	volume /= nFreqComponents;
	float _2pi = 2 * M_PI;
	double tStep = (double)1 / SAMPLES_PER_SECOND;
	while(duration>=t) {
		double x = 0;
		for (int i=0; i<nFreqComponents; i++) {
			x += sin(frequency[i] * t * _2pi);
		}
		t += tStep;
		x = x * volume;
		short y = SHRT_MAX * x;
		fwrite(&y, sizeof(short), 1, stdout);
		/*
		if (t - tick >= 1) {
			printf("%d, %d, %f\n", i, x, t);
			tick = t;
		}
		*/
	}
}
