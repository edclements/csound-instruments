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

gilimit = 0.2

instr 1
  mididefault 1, p3
  midinoteonoct p4, p5
  ilen = p3
  icps = cpsoct(p4)
  ivel = p5/127
  kenv expsegr 0.0001, 0.01, 1, 0.1, 1, 0.01, 0.0001
  asaw vco2 ivel, icps, 0
  asig butterlp  asaw, 1000
  asig balance asig, asaw
  asig = asig*kenv
  out asig*gilimit
endin

</CsInstruments>
; ==============================================
<CsScore>

f 0 3600

f1 0   2048 10 1 1 1 1 .7 .5 .3 .1         ;pulse
f2 0   1024 10  1                    

i 1 0 1 5.00 100

/* i1      0      .4      100    5.00        .02       .01 */
/* i1      +      .       .      5.02        .         . */  
/* i1      +      .26667  .      5.04        .         . */  
/* i1      +      .26667  .      5.05        .         . */  
/* i1      +      .26667  .      5.07        .         . */  

</CsScore>
</CsoundSynthesizer>

