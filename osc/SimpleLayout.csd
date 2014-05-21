<CsoundSynthesizer>
<CsOptions>
</CsOptions>
<CsInstruments>

0dbfs = 1

connect "fader1", "out", "Bell", "in1"
connect "fader2", "out", "Bell", "in2"

#include "SimpleLayout.ins"

instr 1, Bell	
  kc1 init 100
  kc2 init 5
  kin1 inletk "in1"
  kin2 inletk "in2"
  kc1 = kin1*1000
  kc2 = kin2*10
  kvdepth = 0.005
  kvrate = 6
  ifn1 = 1
  ifn2 = 1
  ifn3 = 1
  ifn4 = 1
  ivfn = 1
  midinoteonpch p4, p5
  kpch = p4
  kamp = 0.8*p5/127
  kfreq = cpspch(kpch)
  asig fmbell kamp, kfreq, kc1, kc2, kvdepth, kvrate, ifn1, ifn2, ifn3, ifn4, ivfn
  aenv madsr 0.5, 0, 1, 0.5
  out asig*aenv
endin

</CsInstruments>
<CsScore>
f 1 0 32768 10 1
f 0 36000
</CsScore>
</CsoundSynthesizer>
