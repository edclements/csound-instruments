; http://www.adp-gmbh.ch/csound/instruments/bass01.html
<CsoundSynthesizer>
<CsOptions>
</CsOptions>
; ==============================================
<CsInstruments>

sr = 48000
ksmps = 32
nchnls = 2
0dbfs  = 1

gilimit = 1

instr 1
  mididefault 1, p3
  midinoteonoct p4, p5
  ilen = p3
  icps = cpsoct(p4)
  ivel = p5/127
  k2 expsegr 3000, 0.08, 9000, ilen, 1, 1, 0.001
  ksweep = k2 - 3000
  a1 oscil ivel*0.20, icps*0.998-.12, 1
  a2 oscil ivel*0.20, icps*1.002-.12, 2
  a3 oscil ivel*0.20, icps*1.002-.12, 1
  a4 oscil ivel*0.40, icps-.24, 2
  aall = a1 + a2 + a3 + a4*0.2
  a6 butterlp aall,ksweep
  a8 butterlp a6, ksweep
  a9 butterhp a8, 65  
  a10 butterhp a9, 65  
  a11 butterlp a10,1000
  asig linen a11, p6, ilen, p7
  outs asig*gilimit, asig*gilimit
endin

</CsInstruments>
; ==============================================
<CsScore>

f 0 3600

f1 0   2048 10 1 1 1 1 .7 .5 .3 .1         ;pulse
f2 0   1024 10  1                    

/* i1      0      .4          5.00    100    .02       .01 */
/* i1      +      .           5.02    .      .         . */  
/* i1      +      .26667      5.04    .      .         . */  
/* i1      +      .26667      5.05    .      .         . */  
/* i1      +      .26667      5.07    .      .         . */  

</CsScore>
</CsoundSynthesizer>

