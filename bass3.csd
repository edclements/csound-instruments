<CsoundSynthesizer>
<CsOptions>
</CsOptions>
<CsInstruments>

sr = 48000
ksmps = 32
nchnls = 2
0dbfs  = 1

instr 1
  mididefault 1, p3
  midinoteonoct p4, p5
  kctrl1 init 0.5
  kctrl1 ctrl7 1, 80, 0, 1
  ilen = p3
  icps = cpsoct(p4)
  ivel = p5/127
  kCarFreq = icps
  kModFreq = icps*0.5
  kModFactor = kCarFreq/kModFreq
  kIndex = 12/6.28   ;  12/2pi to convert from radians to norm. table index
  aEnv expseg .001, 0.001, 1, 0.3, 0.5, 8.5, .001
  aModulator poscil kIndex*aEnv*kctrl1, kModFreq, 1
  aPhase phasor kCarFreq
  aCarrier tablei aPhase+aModulator, 1, 1, 0, 1
  outs (aCarrier*aEnv*ivel), (aCarrier*aEnv*ivel)
endin

</CsInstruments>
<CsScore>

f 0 3600

f 1 0 1024 10 1                    

/* i1      0      .4          5.00    100    .02       .01 */
/* i1      +      .           5.02    .      .         . */  
/* i1      +      .26667      5.04    .      .         . */  
/* i1      +      .26667      5.05    .      .         . */  
/* i1      +      .26667      5.07    .      .         . */  

</CsScore>
</CsoundSynthesizer>

