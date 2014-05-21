<CsoundSynthesizer>
<CsOptions>
-Ma
</CsOptions>
<CsInstruments>
;Example by Iain McCurdy

;this example does not use audio so 'sr' and 'nchnls' have been omitted
ksmps = 32

  instr 1
kPchBnd pchbend; read in pitch bend information
kTrig1  changed kPchBnd; if 'kPchBnd' changes generate a trigger ('bang')
 if kTrig1=1 then
printks "Pitch Bend Value: %f%n", 0, kPchBnd; print kPchBnd to console only when its value changes
 endif

kAfttch aftouch; read in aftertouch information
kTrig2  changed kAfttch; if 'kAfttch' changes generate a trigger ('bang')
 if kTrig2=1 then
printks "Aftertouch Value: %d%n", 0, kAfttch; print kAfttch to console only when its value changes
 endif
  endin

</CsInstruments>
<CsScore>
f 0 300
e
</CsScore>
<CsoundSynthesizer>


