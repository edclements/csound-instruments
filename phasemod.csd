<CsoundSynthesizer>
<CsInstruments>
;sr = 48000
;ksmps = 32
nchnls = 2
0dbfs = 1

instr 1  ; simple PM-Synth
  midinoteonpch p4, p5
  kfreq = cpspch(p4)
  kamp = (p5/128)*(0dbfs/2)
  kCarFreq = kfreq
  kModFreq = kfreq + kfreq/12
  ;kCarFreq = 200
  ;kModFreq = 280
  ;kModFactor = kCarFreq/kModFreq
  kIndex = 12/6.28   ;  12/2pi to convert from radians to norm. table index
  aEnv expseg .001, 0.001, 0.8, 0.3, 0.5, 8.5, .001
  aModulator poscil kIndex*aEnv, kModFreq, 1
  aPhase phasor kCarFreq
  aCarrier tablei aPhase+aModulator, 1, 1, 0, 1
  outs (aCarrier*aEnv*kamp), (aCarrier*aEnv*kamp)
endin

</CsInstruments>
<CsScore>
;f 1 0 1024 10 1 		;Sine wave for table 1
f 1 0 32768 10 1
i 1 0 3600
i 1 0 9 8.05 60
</CsScore>
</CsoundSynthesizer>
