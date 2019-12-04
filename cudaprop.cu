#include <stdio.h>

int getSPcores(cudaDeviceProp devProp)
{  
    int cores = 0;
    int mp = devProp.multiProcessorCount;
    switch (devProp.major){
     case 2: // Fermi
      if (devProp.minor == 1) cores = mp * 48;
      else cores = mp * 32;
      break;
     case 3: // Kepler
      cores = mp * 192;
      break;
     case 5: // Maxwell
      cores = mp * 128;
      break;
     case 6: // Pascal
      if (devProp.minor == 1) cores = mp * 128;
      else if (devProp.minor == 0) cores = mp * 64;
      else printf("Unknown device type\n");
      break;
     case 7: // Volta
      if (devProp.minor == 0) cores = mp * 64;
      else printf("Unknown device type\n");
      break;
     default:
      printf("Unknown device type\n"); 
      break;
      }
    return cores;
}


int main() {
  int nDevices;

  cudaGetDeviceCount(&nDevices);
  for (int i = 0; i < nDevices; i++) {
    cudaDeviceProp prop;
    cudaGetDeviceProperties(&prop, i);
    printf("Device Number: %d\n", i);
    printf("  Device name: %s\n", prop.name);
    printf("  Number of CUDA cores: %d\n", getSPcores(prop));
    printf("  Warp Size: %d\n", prop.warpSize);
    printf("  Max Threads Per Block: %d\n", prop.maxThreadsPerBlock);
    printf("  Max Grid Size: (%d, %d, %d)\n", prop.maxGridSize[0],prop.maxGridSize[1],prop.maxGridSize[2]);
    printf("  Max Block Size: (%d, %d, %d)\n", prop.maxThreadsDim[0],prop.maxThreadsDim[1],prop.maxThreadsDim[2]);
    printf("  Max Threads Per Multiprocessor: %d\n", prop.maxThreadsPerMultiProcessor);
    printf("  Total Global Memory: %zu GB\n", prop.totalGlobalMem>>30);
    printf("  Shared Memory per Block: %zu kB\n", prop.sharedMemPerBlock>>10);
    printf("  Register per Block: %d kB \n\n", prop.regsPerBlock/1024);

  }
}