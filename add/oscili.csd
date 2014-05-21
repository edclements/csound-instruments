<CsoundSynthesizer>
<CsOptions>
</CsOptions>
<CsInstruments>

nchnls = 2
0dbfs  = 1

instr 1
  midinoteonpch p4, p5
  kcps1 = cpspch(p4)
  kcps2 = kcps1/2

  kamp = .2
;  kcps = 440
  ifn  = 4

  asig1 oscili kamp, kcps1, 4
  asig2 oscili kamp, kcps2, 1
  asig = asig1 + asig2
  aenv madsr 0.5, 0, 1, 0.5
  outs asig*aenv,asig*aenv
endin

</CsInstruments>
<CsScore>
f1 0 128 10 1                                          ; Sine with a small amount of data
f2 0 128 10 1 0.5 0.3 0.25 0.2 0.167 0.14 0.125 .111   ; Sawtooth with a small amount of data
f3 0 128 10 1 0   0.3 0    0.2 0     0.14 0     .111   ; Square with a small amount of data
f4 0 128 10 1 1   1   1    0.7 0.5   0.3  0.1          ; Pulse with a small amount of data
f 0 36000

;i 1  0 2 1
;i 2  3 2 1
;i 1  6 2 2
;i 2  9 2 2
;i 1 12 2 3
;i 2 15 2 3
;i 1 18 2 4
;i 2 21 2 4

e
</CsScore>
</CsoundSynthesizer>
