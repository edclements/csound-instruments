#include <csdl.h>
#include <pstream.h>

typedef struct _padsynth {
    OPDS h;
    PVSDAT *fout;
    PVSDAT *fin;
    MYFLT
    *cf,*kdepth, *gain;
    unsigned long
    lastframe;
} padsynth;

int padsynth_init(CSOUND *csound, padsynth *p)
{
    long N = p->fin->N; /* fftsize */
    if (p->fout->frame.auxp==NULL)
    csound->AuxAlloc(csound,(N+2)*sizeof(float),&p->fout->frame);
    /* initialise the PVSDAT structure */
    p->fout->N = N;
    p->fout->overlap = p->fin->overlap;
    p->fout->winsize = p->fin->winsize;
    p->fout->wintype = p->fin->wintype;
    p->fout->format = p->fin->format;
    p->fout->framecount = 1;
    p->lastframe = 0;
    /*
    if (!(p->fout->format==PVS_AMP_FREQ) ||
        (p->fout->format==PVS_AMP_PHASE))
        return csound->InitError(csound,"padsynth: signal format must be amp-phase or amp-freq.\n");
        */
    p->fout->format = PVS_AMP_PHASE
    return OK;
}

int padsynth_process(CSOUND *csound, padsynth *p)
{
    long i,j,N = p->fout->N, bins = N/2 + 1;
    float g = (float) *p->gain;
    MYFLT kdepth = (MYFLT) *(p->kdepth), cf = (MYFLT) *(p->cf);
    float *fin = (float *) p->fin->frame.auxp;
    float *fout = (float *) p->fout->frame.auxp;
    if(fout==NULL)
        return csound->PerfError(csound, p->h.insdshead,
        "padsynth: not initialised\n");
    /* if a new frame is ready for processing */
    if(p->lastframe < p->fin->framecount) {
        /* limit cf and kdepth to 0 – 1 range */
        /* scale cf to the number of spectral bins */
        /* cf = cf >= 0 ? (cf < 1 ? cf*bins : bins-1) : 0; */
        /* kdepth = kdepth >= 0 ? (kdepth <= 1 ? kdepth : */
        /* (MYFLT)1.0): (MYFLT)0.0; */
        /* j counts bins, whereas i counts frame positions */
        /* for(i=j=0;i < N+2;i+=2, j++) { */
            /* if the bin is to be highlighted */
            /* if(j == (int) cf) fout[i] = fin[i]*g; */
            /* else attenuate it */
            /* else fout[i] = (float)(fin[i]*(1-kdepth)); */
            /* pass the frequencies unchanged */
            /* fout[i+1] = fin[i+1]; */
        /* } */
        for(i=0;i<N+2;i+=2) {
          fout[i+1] = fin[i+1]
        }
        /* update the internal frame count */
        p->fout->framecount = p->lastframe = p->fin->framecount;
    }
    return OK;
}

static OENTRY localops[] = {
    {"padsynth", sizeof(padsynth), 0, 3, "f", "fkkk", (SUBR)padsynth_init,
    (SUBR)padsynth_process}
};
LINKAGE
