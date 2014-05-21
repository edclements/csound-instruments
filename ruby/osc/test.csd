<CsoundSynthesizer>
<CsOptions>
-odac    ;;;realtime audio out
</CsOptions>
<CsInstruments>
instr 1
  asig oscil .7, p4, 1
  out asig
endin
</CsInstruments>
<CsScore>
f1 0 16384 10 1
i 1 0 5 440
i 1 5 5 220
</CsScore>
</CsoundSynthesizer>
