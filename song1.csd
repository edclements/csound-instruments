<CsoundSynthesizer>
<CsOptions>
</CsOptions>
<CsInstruments>

sr = 48000
ksmps = 32
nchnls = 2
0dbfs  = 1

massign 0,0
massign 1,1
massign 9,2
massign 10,2
massign 11,2
massign 12,2
massign 13,2
massign 15,2
massign 16,2

instr 1
  mididefault 1, p3
  midinoteonoct p4, p5
  ilen = p3
  icps = cpsoct(p4)
  ivel = p5/127
  kenv expsegr 0.0001, 0.01, 1, 0.1, 1, 0.01, 0.0001
  asaw vco2 ivel, icps, 0
  asig butterlp  asaw, 1000
  asig balance asig, asaw
  asig = asig*kenv
  outs asig*0.2, asig*0.2
  chnmix asig*0.05, "ReverbSend"
endin

instr 2
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
  outs aout, aout
  chnmix aout, "DelaySend"
endin

instr 3
  asig chnget "DelaySend"
  aout multitap asig, 0.4, .8, 0.8, .7, 1.2, .6
  chnmix aout*0.4, "ReverbSend"
  outs aout, aout
  chnclear "DelaySend"
endin

instr 4
  asig chnget "ReverbSend"
  aout nreverb asig, 5, 0.5
  outs aout, aout
  chnclear "ReverbSend"
endin

instr 5
  asig chnget "Reverb2Send"
  aout reverb asig, 0.5
  outs aout, aout
  chnclear "Reverb2Send"
endin

</CsInstruments>
<CsScore>

f 0 3600

f1 0   2048 10 1 1 1 1 .7 .5 .3 .1         ;pulse
f2 0   1024 10  1                    

i 2 0 -1
i 3 0 -1
i 4 0 -1
i 5 0 -1

</CsScore>
</CsoundSynthesizer>

