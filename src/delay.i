%module Delay
%{ 
/* Header files or function prototypes go here in be included in the 
wrapper code*/ 
#include <time.h> 
extern int nanodelay(int sec, int nsec); 
%} 
/* Parse the function prototypes to generate wrappers */
extern int nanodelay(int sec, int nsec); 
