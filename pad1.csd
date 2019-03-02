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
  midinoteonoct p4, p5
  kvel = p5/127
  kpb init 0
  kyaxis init 0
  midipitchbend kpb
  midicontrolchange 74, kyaxis, 0, 1
  kfader1 ctrl7 1, 1, 0, 1
  kfader2 ctrl7 1, 2, 0, 1
  kfader3 ctrl7 1, 3, 0, 1
  kfader4 ctrl7 1, 4, 0, 1
  kafter aftouch 0.4, 1
  koct = p4+kpb*2
  kcps = cpsoct(koct)
  kenv madsr 3, 0.8, 0.8, 3 
  asquare vco2 kenv*kvel, kcps*1.02, 2, 0.8
  asaw vco2 kenv*kvel, kcps*1.01, 0
  asig sum asquare*kfader1, asaw*(1 - kfader1)
  asig = 0.4*asig*kafter
  aout rezzy asig, (1 + kfader3*3)*1000, kfader2*90
  aout balance aout, asig
  aout lowpass2 aout, 2000, 10
  outs aout, aout
  chnmix aout, "DelaySend"
endin

instr 2
  asig chnget "DelaySend"
  aout multitap asig, 0.4, .8, 0.8, .7, 1.2, .6
  chnmix aout*0.4, "ReverbSend"
  outs aout, aout
  chnclear "DelaySend"
endin

instr 3
  asig chnget "ReverbSend"
  aout nreverb asig, 5, 0.5
  outs aout, aout
  chnclear "ReverbSend"
endin

instr 4
  asigl, asigr monitor
  fout "record.wav", 4, asigl, asigr
endin

</CsInstruments>
<CsScore>

f 0 3600
f 2 0 4096 10 1	
f 3 0 16384 10 1

i 2 0 -1
i 3 0 -1
i 4 0 -1

;i 1 0 2 8.000 100	; play these notes from score as well
;i 1 + 2 8.917 100
e

</CsScore>
</CsoundSynthesizer>
