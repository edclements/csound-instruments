<CsoundSynthesizer>
<CsOptions>
</CsOptions>
<CsInstruments>

nchnls	=	2
0dbfs	=	1

instr 1	
  midinoteonoct p4, p5
  kpb init 0
  midipitchbend kpb
  koct = p4+kpb
  kcps = cpsoct(koct)
  kamp = p5/127
  ; osc1 pulse
  kenv1 mxadsr 3, 1, 1, 8
  krand1 rspline -0.001, 0.001, 1, 4
  aosc1 vco2 kamp*kenv1, kcps + krand1*kcps, 2, 0.6
  krand2 rspline -30, 30, 0.1, 0.5
  aosc1 lowpass2 aosc1, kcps*2.5 + krand2, 60
  ; osc2 saw
  kenv2 mxadsr 2, 1, 0.3, 3
  krand3 rspline -0.005, 0.005, 1, 4
  aosc2 vco2 kamp*kenv2, kcps - krand3*kcps, 0
  krand4 rspline -60, 60, 0.1, 0.8
  aosc2 lowpass2 aosc2, kcps*3 + krand4, 20
  ; osc3 saw
  kenv3 mxadsr 3, 1, 0.8, 2
  aosc3 vco2 kamp*kenv3, kcps/2, 0
  aosc3 lowpass2 aosc3, kcps*2.5, 20
  ; mix
  asig sum aosc1, aosc2, aosc3
  asig = 0.1*asig
  outs asig, asig
  chnmix 0.1*asig, "ReverbSend"
endin

instr 2
  asig chnget "ReverbSend"
  aout nreverb asig, 5, 0.5
  outs aout, aout
  chnclear "ReverbSend"
endin

</CsInstruments>
<CsScore>

i 2 0 22
i 1 0 10 8.00 60
i 1 2 10 8.75 60
i 1 10 8 7.00 60
i 1 12 8 7.25 60

</CsScore>
</CsoundSynthesizer>

