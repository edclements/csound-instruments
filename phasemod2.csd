<CsoundSynthesizer>
<CsInstruments>
;sr = 48000
;ksmps = 32
nchnls = 2
0dbfs = 1

/*
asig PMOp kamp,kfr,apm,iatt,idec,isus,irel[,ifn]
kamp - amplitude
kfr - frequency
apm - phase modulation input
iatt - attack
idec - decay
isus - sustain
irel - release
ifn - optional function wave table (defaults to sine)
*/
opcode PMOp,a,kkaiiiij
  kamp,kfr,apm,iatt,idec,isus,irel,ifn xin
  aph phasor kfr
  a1 tablei aph+apm/(2*$M_PI),ifn,1,0,1
  a2 madsr iatt,idec,isus,irel
  xout a2*a1*kamp
endop

instr 1  ; simple PM-Synth
  midinoteonpch p4, p5
  kfreq = cpspch(p4)
  kamp = (p5/128)*(0dbfs/2)
  apm = 30
  iatt = 0.5
  idec = 0
  isus = 1
  irel = 0.5
  amod PMOp k(3), kfreq, a(0), iatt, idec, isus, irel
  asig PMOp kamp, kfreq, amod, iatt, 0.5, 1, 2
  outs asig, asig
endin

</CsInstruments>
<CsScore>
;f 1 0 1024 10 1 		;Sine wave for table 1
;f 1 0 32768 10 1
i 1 0 3600
i 1 0 9 8.05 60
</CsScore>
</CsoundSynthesizer>
