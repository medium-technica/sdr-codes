#include <stdio.h>
#include <string.h>
#define OFFSET 0
#define RATE_IQ 2400000
#define RATE_AUDIO 48000
#define BITS_PER_IQ 16

int processIq(FILE *, unsigned int);

int main()
{
 char fName[] = "../../include/wbfm_raw_iq_2.4M_48k.iq";
 FILE *fp = fopen(fName, "rb");
 if (fp == NULL)
 {
  printf("Error opening file: %s\n", fName);
 }
 fseek(fp, 0, SEEK_END);
 unsigned long sizeFBits = ftell(fp) * 8;

 unsigned int bytesPerSample = BITS_PER_IQ / 2;

 unsigned long nSamples = sizeFBits / (2 * BITS_PER_IQ);

 unsigned int samplesPerFrame = RATE_AUDIO;

 unsigned int bytesPerFrame = samplesPerFrame * bytesPerSample;

 printf("No. of Frames = %ld\n", nSamples / samplesPerFrame);

 unsigned int indexByteFrame = 0;
 unsigned int indexFrame = 0;
 while (fseek(fp, indexByteFrame, SEEK_SET) == 0)
 {
  printf("Frame Index: %d\n", indexFrame++);
  if (processIq(fp, bytesPerFrame))
  {
   return 0;
  }
  indexByteFrame += bytesPerFrame;
  return 0;
 }

 return 0;
}

int processIq(FILE *fp, unsigned int N)
{
 short i[N], q[N];
 for (unsigned int n = 0; n < N; n++)
 {
  if ((fread(i + n, sizeof(short), 1, fp) == 1) && (fread(q + n, sizeof(short), 1, fp) == 1))
  {
   printf("%d: %d\t%di\n", n, i[n], q[n]);
  }
  else
  {
   printf("Error reading file!, read position: %d\n", N + n);
   return 1;
  }
 }
 return 0;
}
