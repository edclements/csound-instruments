<CsoundSynthesizer>
<CsOptions>
-o dac
</CsOptions>
<CsInstruments>
; written by Alex Hofmann (Mar. 2011)
sr = 48000
ksmps = 32
nchnls = 1
0dbfs = 1

instr 1
aRaise expseg 2, 20, 100
aSine1 poscil 0.3, aRaise , 1
aSine2 poscil 0.3, 440, 1
out aSine1*aSine2
endin

</CsInstruments>
<CsScore>
f 1 0 1024 10 1
i 1 0 25
e
</CsScore>
</CsoundSynthesizer>


