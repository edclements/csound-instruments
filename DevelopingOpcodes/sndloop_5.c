#include "csdl.h"
#include "pstream.h"

typedef struct  _newopc {
	
	OPDS  h;
	MYFLT *out;/* output pointer  */
	MYFLT *in1,*in2,*in3; /* input pointers */
	MYFLT  var1;  /* internal variables */
	MYFLT  var2;  
	
} newopc;

typedef struct _sndloop {
	OPDS h;
	MYFLT *out, *recon;  /* output, record on */
	MYFLT *sig, *pitch, *on, *dur, *cfd;  /* in, pitch, sound on, duration, crossfade  */
	AUXCH buffer; /* loop memory */
	long  wp;     /* writer pointer */
	MYFLT rp;     /* read pointer  */
	long  cfds;   /* crossfade in samples */
	long durs;    /* duration in samples */
	int  rst;     /* reset indicator */
	MYFLT  inc;     /* fade in/out increment/decrement */
	MYFLT  a;       /* fade amp */
} sndloop;


typedef struct _flooper {
	OPDS h;
	MYFLT *out;  /* output, record on */
	MYFLT *amp, *pitch, *start, *dur, *cfd, *ifn; 
	AUXCH buffer; /* loop memory */
	FUNC  *sfunc;  /* function tabble */
	long strts;   /* start in samples */
	long  durs;    /* duration in samples */
	MYFLT  ndx;    /* table lookup ndx */
  int   loop_off; 
} flooper;


typedef struct _pvsarp {
        OPDS h;
        PVSDAT  *fout;
        PVSDAT  *fin;
		MYFLT   *cf;
		MYFLT   *kdepth;
		MYFLT   *gain;
        unsigned long   lastframe;
}
pvsarp;

int newopc_init(newopc *p){
	p->var1 = (MYFLT) 0;
	p->var2 = *p->in3;
        return OK;
}

int newopc_process_control(ENVIRON *csound, newopc *p){
	MYFLT cnt = p->var1 + *(p->in2);
	if(cnt > p->var2) cnt = (MYFLT) 0; /* check bounds */
	*(p->out) = *(p->in1) + cnt; /* generate output */
	p->var1 = cnt; /* keep the value of cnt */
	return OK;
}

int newopc_process_audio(ENVIRON *csound, newopc *p){
	int i, n = csound->ksmps;
	MYFLT *aout = p->out;  /* output signal */
	MYFLT cnt = p->var1 + *(p->in2);
	if(cnt > p->var2) cnt = (MYFLT) 0; /* check bounds */
	
	/* processing loop    */
	for(i=0; i < n; i++) aout[i] = *(p->in1) + cnt;
	
	p->var1 = cnt; /* keep the value of cnt */
	return OK;
}


int sndloop_init(ENVIRON *csound, sndloop *p){
	
	p->durs = (long) (*(p->dur)*csound->esr); /* dur in samps */
	p->cfds = (long) (*(p->cfd)*csound->esr); /* fade in samps */
	p->inc =  (MYFLT)1/p->cfds;          /* inc/dec */ 
	p->a  = (MYFLT) 0;
	p->wp = 0;   /* intialise write pointer */ 
	p->rst = 1;	              /* reset the rec control */
	if(p->buffer.auxp==NULL)   /* allocate memory if necessary */
		csound->AuxAlloc(csound, p->durs*sizeof(float), &p->buffer);
	return OK;
}

int sndloop_process(ENVIRON *csound, sndloop *p){
	
    int i, on = (int) *(p->on), recon, n = csound->ksmps;
    long durs = p->durs, cfds = p->cfds, wp = p->wp;
    MYFLT rp = p->rp, a = p->a, inc = p->inc;
	MYFLT *out = p->out, *sig = p->sig, *buffer = p->buffer.auxp;
	MYFLT pitch = *(p->pitch);
	
	if(on) recon = p->rst; /* restart recording if switched on again */
	else recon = 0;        /* else do not record */
	
    for(i=0; i < n; i++){		
		if(recon){ /* if the recording is ON */
			/* fade in portion */
			if(wp < cfds){
				buffer[wp] = sig[i]*a;
				a += inc;
			}
			else { 
				if(wp >= durs){ /* fade out portion */ 
					buffer[wp-durs] += sig[i]*a;
					a -= inc;
				}
				else buffer[wp] = sig[i];  /* middle of loop */
			}
			/* while recording connect input to output directly */
			out[i] = sig[i];
			wp++; /* increment writer pointer */
			if(wp == durs+cfds){  /* end of recording */ 
				recon = 0;  /* OFF */
				p->rst = 0; /* reset to 0 */
				p->rp = (MYFLT) wp; /* rp pointer to start from here */
			}
		}
		else {  
			if(on){ /* if opcode is ON */ 
				out[i] = buffer[(int)rp]; /* output the looped sound */
				rp += pitch;              /* read pointer increment */
				while(rp >= durs) rp -= durs; /* wrap-around */
				while(rp < 0) rp += durs;
			}
			else {   /* if opocde is OFF */
				out[i] = sig[i]; /* copy input to the output */
				p->rst = 1;   /* reset: ready for new recording */
				wp = 0; /* zero write pointer */
			}
		} 
	}
    p->rp = rp; /* keep the values */
	p->wp = wp;
	p->a = a;
    *(p->recon) = (MYFLT) recon; /* output 'rec on light' */
    
    return OK;	
}


int flooper_init(ENVIRON *csound, flooper *p){
	
	MYFLT *tab, *buffer, a = (MYFLT) 0, inc;
	long cfds = (long) (*(p->cfd)*csound->esr);     /* fade in samps  */
	long starts = (long) (*(p->start)*csound->esr); /* start in samps */
	long durs = (long)  (*(p->dur)*csound->esr);    /* dur in samps   */
	long len, i;               
	
	if(cfds > durs){
		csound->InitError(csound, "crossfade longer than loop duration\n");
		return;
	}
	
	inc =  (MYFLT)1/cfds;          /* inc/dec */ 
	p->sfunc = csound->FTnp2Find(csound, p->ifn);  /* function table */
        if(p->sfunc==NULL){
		csound->InitError(csound,"function table not found\n");
		return;
    } 
	tab = p->sfunc->ftable,        /* func table pointer */
        len = p->sfunc->flen;          /* function table length */
    if(starts > len){
	        csound->InitError(csound,"start time beyond end of table\n");
		return;
	}
	
	if(starts+durs+cfds > len){
		csound->InitError(csound,"table not long enough for loop\n");
		return;
	}

	if(p->buffer.auxp==NULL)   /* allocate memory if necessary */
		csound->AuxAlloc(csound,(durs+1)*sizeof(float), &p->buffer);
	
	inc = (MYFLT)1/cfds;       /* fade envelope incr/decr */
	buffer = p->buffer.auxp;   /* loop memory */

	/* we now write the loop into memory */
	for(i=0; i < durs; i++){
		if(i < cfds){
			buffer[i] = a*tab[i+starts];
			a += inc;
		}
		else buffer[i] = tab[i+starts];;
	   }
	/*  crossfade section */
	for(i=0; i  < cfds; i++){
		buffer[i] += a*tab[i+starts+durs];
		a -= inc;
	}

	buffer[durs] = buffer[0]; /* for wrap-around interpolation */
	p->strts = starts;
	p->durs = durs;
	p->ndx = (MYFLT) 0;	 /* lookup index */
        p->loop_off  = 0;
        return OK;
}

int flooper_process(ENVIRON *csound, flooper *p){
	
    int i, n = csound->ksmps;
    long end = p->strts+p->durs, durs = p->durs; 
	MYFLT *out = p->out, *buffer = p->buffer.auxp;
	MYFLT amp = *(p->amp), pitch = *(p->pitch);
	MYFLT *tab = p->sfunc->ftable, ndx = p->ndx, frac;
    int tndx, loop_off = p->loop_off;
	
    for(i=0; i < n; i++){
		    tndx = (int) ndx;
		    frac = ndx - tndx;
		/* this is the start portion of the sound */
		if(ndx >= 0  && ndx < end && loop_off) { 
			out[i] = amp*(tab[tndx] + frac*(tab[tndx+1] - tab[tndx]));  
			ndx += pitch;
		} 
		/* this is the loop section */
		else {
			if(loop_off) { 
			ndx -= end; 
			tndx -= end;
        /* wrap-around, if reading backwards */
            while (tndx < 0) tndx += durs;
			}
			loop_off = 0;
			out[i] = amp*(buffer[tndx] + frac*(buffer[tndx+1] - buffer[tndx]));
			ndx += pitch; 
			while (ndx < 0) ndx += durs;
			while (ndx >= durs) ndx -= durs;
			 
		}
		
	}
        p->ndx = ndx;
	p->loop_off = loop_off;
        return OK;
}

int pvsarp_init(ENVIRON *csound, pvsarp *p){
    long N = p->fin->N;

    if (p->fout->frame.auxp==NULL)
		csound->AuxAlloc(csound,(N+2)*sizeof(float),&p->fout->frame);     
    p->fout->N =  N;
    p->fout->overlap = p->fin->overlap;
    p->fout->winsize = p->fin->winsize;
    p->fout->wintype = p->fin->wintype;
    p->fout->format = p->fin->format;
    p->fout->framecount = 1;
    p->lastframe = 0;
	
    if (!(p->fout->format==PVS_AMP_FREQ) || (p->fout->format==PVS_AMP_PHASE)){
     return csound->InitError(csound, "pvsarp: signal format must be amp-phase or amp-freq.\n");
    }

    return OK;
}

int pvsarp_process(ENVIRON *csound, pvsarp *p)
{
    long i,j,N = p->fout->N, bins = N/2 + 1;
    float g = (float) *p->gain;
    MYFLT kdepth = (MYFLT) *(p->kdepth), cf = (MYFLT) *(p->cf);		                 
    float *fin = (float *) p->fin->frame.auxp;          
    float *fout = (float *) p->fout->frame.auxp;

    if(fout==NULL)
	   return csound->PerfError(csound,"pvsarp: not initialised\n");

    if(p->lastframe < p->fin->framecount) {
        cf = cf >= 0 ? (cf < bins ? cf*bins : bins-1) : 0;
		kdepth = kdepth >= 0 ? (kdepth <= 1 ? kdepth : (MYFLT)1.0): (MYFLT)0.0;
		for(i=j=0;i < N+2;i+=2, j++) { 
		  if(j == (int) cf) fout[i] = fin[i]*g;
		  else fout[i] = (float)(fin[i]*(1-kdepth));
		  fout[i+1] = fin[i+1];
		}
		p->fout->framecount = p->lastframe = p->fin->framecount;
    }

    return OK;
}


static OENTRY localops[] = {
	{ "newopc", sizeof(newopc),  7,  "s",    "kki",  
		(SUBR) newopc_init,  (SUBR) newopc_process_control, 
		(SUBR) newopc_process_audio },
	{"sndloop", sizeof(sndloop), 5, 
	"ak", "akkii", (SUBR)sndloop_init, 0 ,   
	(SUBR)sndloop_process},
	{"flooper", sizeof(flooper), 5, 
	"a", "kkiiii", (SUBR)flooper_init, 0 ,   
	(SUBR)flooper_process},
	 {"pvsarp", sizeof(pvsarp), 3, "f", "fkkk", (SUBR)pvsarp_init, 
	 (SUBR)pvsarp_process}

};

LINKAGE


