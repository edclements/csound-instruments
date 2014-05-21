<CsoundSynthesizer>
<CsOptions>
-Ma -odac
</CsOptions>
<CsInstruments>
;Example by Iain McCurdy

sr = 44100
ksmps = 32
nchnls = 1
0dbfs = 1

giSine ftgen 0,0,2^12,10,1
initc7 1,1,1; initialize controller 1 on midi channel 1 to its maximum level

  instr 1
iCps cpsmidi; read in midi pitch in cycles-per-second
iAmp ampmidi 1; read in note velocity - re-range to be from 0 to 1
kVol ctrl7   1,1,0,1; read in controller 1, channel 1. Re-range to be from 0 to 1
aSig poscil  iAmp*kVol, iCps, giSine
     out     aSig
  endin

</CsInstruments>
<CsScore>
f 0 300
e
</CsScore>
<CsoundSynthesizer>


