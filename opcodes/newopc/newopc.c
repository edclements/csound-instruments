#include <csdl.h>

typedef struct  _newopc {

OPDS  h;
MYFLT *out;/* output pointer  */
MYFLT *in1,*in2,*in3; /* input pointers */
MYFLT  var1;  /* internal variables */
MYFLT  var2;

} newopc;

int newopc_init(CSOUND *csound, newopc *p){
 p->var1 = (MYFLT) 0;
 p->var2 = *p->in3;
return OK;
}

int newopc_process_control(CSOUND *csound, newopc *p){
 MYFLT cnt = p->var1 + *(p->in2);
 if(cnt > p->var2) cnt = (MYFLT) 0; /* check bounds */
 *(p->out) = *(p->in1) + cnt; /* generate output */
  p->var1 = cnt; /* keep the value of cnt */
  return OK;
}

int newopc_process_audio(CSOUND *csound, newopc *p){
 int i, n = CS_KSMPS;
 MYFLT *aout = p->out;  /* output signal */
 MYFLT cnt = p->var1 + *(p->in2);
 uint32_t offset = p->h.insdshead->ksmps_offset;
 uint32_t early  = p->h.insdshead->ksmps_no_end;

 /* sample-accurate mode mechanism */
 if(offset) memset(aout, '\0', offset*sizeof(MYFLT));
 if(early) {
        n -= early;
        memset(&aout[n], '\0', early*sizeof(MYFLT));
  }        

  if(cnt > p->var2) cnt = (MYFLT) 0; /* check bounds */
   
  /* processing loop    */
  for(i=offset; i < n; i++) aout[i] = *(p->in1) + cnt;
   
   p->var1 = cnt; /* keep the value of cnt */
   return OK;
}

static OENTRY localops[] = {
{ "newopc", sizeof(newopc), 0, 7, "s", "kki",(SUBR) newopc_init,
(SUBR) newopc_process_control, (SUBR) newopc_process_audio }
};
LINKAGE
