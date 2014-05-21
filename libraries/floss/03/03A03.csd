<CsoundSynthesizer>
<CsInstruments>
;example by joachim heintz
sr = 44100
ksmps = 4410

instr 1
icount    init      0; set icount to 0 first
icount    =         icount + 1; increase
          print     icount; print the value
endin

</CsInstruments>
<CsScore>
i 1 0 1
</CsScore>
</CsoundSynthesizer>

