#include <stdio.h> 
#include <csound/csound.h>

/* performance thread function prototype */
uintptr_t csThread(void *clientData);

/* userData structure declaration */
typedef struct {
  int result;
  CSOUND *csound;
  int PERF_STATUS;
} userData;

PUBLIC userData *csoundStartPerformance(CSOUND *);

PUBLIC int csoundEndPerformance(userData *);

/*-----------------------------------------------------------
 * main function
 *-----------------------------------------------------------*/
/*
int main(int argc, char *argv[])
{
  int userInput = 200;
  void *ThreadID;
  userData *ud;
  ud = (userData *)malloc(sizeof(userData));
  MYFLT *pvalue;
  csoundInitialize(&argc, &argv, 0);
  ud->csound = csoundCreate(NULL);
  ud->result = csoundCompile(ud->csound, argc, argv);
  if (csoundGetChannelPtr(ud->csound, &pvalue, "pitch",
          CSOUND_INPUT_CHANNEL | CSOUND_CONTROL_CHANNEL) != 0) {
    printf("csoundGetChannelPtr could not get the \"pitch\" channel");
    return 1;
  }
  if (!ud->result) {
    ud->PERF_STATUS = 1;
    ThreadID = csoundCreateThread(csThread, (void*)ud);
  }
  else {
    printf("csoundCompiled returned an error");
    return 1;
  }
  printf("\nEnter a pitch in Hz(0 to Exit) and type return\n");
  while (userInput != 0) {
    *pvalue = (MYFLT)userInput;
    scanf("%d", &userInput);
  }
  ud->PERF_STATUS = 0;
  csoundDestroy(ud->csound);
  free(ud);
  return 0;
}
*/

userData *csoundStartPerformance(CSOUND *csnd)
{
  userData *ud;
  ud = (userData *)malloc(sizeof(userData));
  ud->csound = csnd;
  ud->PERF_STATUS = 1;
  csoundCreateThread(csThread, (void*)ud);
  return ud;
}

int csoundEndPerformance(void *data)
{
  userData *udata = (userData *)data;
  udata->PERF_STATUS = 0;
  csoundDestroy(udata->csound);
  free(udata);
  return 0;
}

/*-----------------------------------------------------------
 * definition of our performance thread function
 *-----------------------------------------------------------*/
uintptr_t csThread(void *data)
{
  userData *udata = (userData *)data;
  if (!udata->result) {
    while ((csoundPerformKsmps(udata->csound) == 0) &&
           (udata->PERF_STATUS == 1));
    csoundDestroy(udata->csound);
  }
  udata->PERF_STATUS = 0;
  return 1;
} 
