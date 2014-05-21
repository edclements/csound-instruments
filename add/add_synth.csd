<CsoundSynthesizer>
<CsOptions>
;-o dac -Ma
-M0 -+rtmidi=null --midi-key-pch=4
</CsOptions>
<CsInstruments>

JackoInit "default", "csound"
JackoMidiInConnect "system:midi_capture_3", "csound_midi"
JackoOn 1
	
sr = 44100
ksmps = 32
nchnls = 2
0dbfs = 1

giSine    ftgen     0, 0, 2^10, 10, 1
          massign   0, 1 ;all midi channels to instr 1

instr 1
  ipch pchmidi
  iamp ampmidi 0.5
  event_i "i", 2, 0, 1, ipch, iamp/1
  event_i "i", 2, 0, 1, ipch + 1, iamp/2
  event_i "i", 2, 0, 1, ipch + 2, iamp/3
  event_i "i", 4, 0, 1, ipch, iamp
endin

instr 2
  ifreq = cpspch(p4)
  iamp = p5
  aenv transeg 0, .01, 0, iamp, p3-.01, -3, 0
  asig poscil aenv, ifreq, giSine
  outs asig, asig
endin

instr 3
  ifreq = cpspch(p4)
  iamp = p5
  aenv transeg 0, .01, 0, iamp, p3-.01, -3, 0
  asig poscil aenv, ifreq, giSine
  outs asig, asig
endin

instr 4
  ipch = p4
  iamp = p5
  event_i "i", 2, 0, 1, ipch + 0.01, iamp/1
  event_i "i", 2, 0.1, 1, ipch + 0.03, iamp/2
  event_i "i", 2, 0.2, 1, ipch + 0.05, iamp/3
  event_i "i", 2, 0.3, 1, ipch + 0.05, iamp/4
  event_i "i", 2, 0.4, 1, ipch + 0.05, iamp/5
  event_i "i", 2, 0.5, 1, ipch + 0.05, iamp/6
  event_i "i", 2, 0.6, 1, ipch, iamp/7
endin

</CsInstruments>
<CsScore>
f 0 3600
</CsScore>
</CsoundSynthesizer>
