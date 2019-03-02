<CsoundSynthesizer>
<CsOptions>
; Select audio/midi flags here according to platform
;-odac    -M1  ;;;realtime audio out and midi in 
;-iadc    ;;;uncomment -iadc if realtime audio input is needed too
; For Non-realtime ouput leave only the line below:
; -o midipitchbend.wav -W ;;; for file output any platform
</CsOptions>
<CsInstruments>

sr = 48000
ksmps = 32
nchnls = 2
0dbfs  = 1

instr 1
  kvel = p5/127
  koct = p4
  kcps = cpsoct(koct)
  kenv madsr 3, 0.8, 0.8, 3 
  kdetune1 lfo 1, 0.1
  kdetune2 lfo 2, 0.2
  asig1 buzz kenv*kvel, kcps+kdetune1, 10, 3
  aring1 poscil 0.8, 300, 3
  asig1 = aring1*asig1
  asig2 buzz kenv*kvel, kcps+kdetune2, 10, 3
  aring2 poscil 0.8, 200, 3
  asig2 = aring2*asig2
  asig3 buzz kenv*kvel, 0.5*kcps, 10, 3
  aring3 poscil 0.8, 100, 3
  asig3 = aring3*asig3
  aout sum asig1, asig2, asig3
  aout = 0.5*aout
  outs aout, aout
endin

</CsInstruments>
<CsScore>

f 0 3600
f 2 0 4096 10 1	
f 3 0 16384 10 1

i 1 0 60 7.000 100

;i 1 0 2 8.000 100	; play these notes from score as well
;i 1 + 2 8.917 100
e

</CsScore>
</CsoundSynthesizer>
