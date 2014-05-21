<CsoundSynthesizer>
<CsOptions>
-Ma
</CsOptions>
<CsInstruments>
;Example by Iain McCurdy

;this example does not use audio so 'sr' and 'nchnls' have been omitted
ksmps = 32

  instr 1
kCtrl    ctrl7    1,1,0,127; read in midi controller #1 on channel 1
kTrigger changed  kCtrl; if 'kCtrl' changes generate a trigger ('bang')
 if kTrigger=1 then
printks "Controller Value: %d%n", 0, kCtrl; print kCtrl to console only when its value changes
 endif
  endin

</CsInstruments>
<CsScore>
i 1 0 300
e
</CsScore>
<CsoundSynthesizer>


