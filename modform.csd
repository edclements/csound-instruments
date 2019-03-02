<CsoundSynthesizer>
;<CsOptions>
;</CsOptions>
<CsInstruments>

nchnls = 2
0dbfs = 1

#include "/home/ed/csound/opcodes.txt"

instr 1
  midinoteonpch p4, p5
  kFreq = cpspch(p4)
  kFormant = kFreq*2
  kAmp = (p5/128)*(0dbfs/2)
  ;kBand = kFreq
  kBand = 400
  aSig ModForm kAmp, kFreq, kFormant, kBand, 1, 1
  aEnv madsr 0.01, 0.4, 0.8, 3
  aSig = aSig*aEnv
  outs aSig, aSig
endin

</CsInstruments>
<CsScore>

f 1 0 32768 10 1
;i 1 0 3600
i 1 0 1 8.06 80
i 1 1 1 8.01 80
i 1 2 1 8.00 80

</CsScore>
</CsoundSynthesizer>

