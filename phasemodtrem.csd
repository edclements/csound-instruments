<CsoundSynthesizer>
<CsInstruments>
nchnls = 2
0dbfs = 1

massign 1, 4

instr 1
  midinoteonpch p4, p5
  kfreq cpsmidib
  kamp = (p5/128)*(0dbfs/2)
  apm = 30
  iatt = 0.5
  idec = 0.5
  isus = 1
  irel = 3
  imodatt = 0.5
  imoddec = 0
  imodsus = 1
  imodrel = 2
  itremamp = 0.4
  itremfreq = 2.6
  aph phasor kfreq
  a1 tablei aph,1,1,0,1
  a2 madsr imodatt,imoddec,imodsus,imodrel
  amod = a2*a1*3
  a3 tablei aph+amod/(2*$M_PI),1,1,0,1
  kshapeamt chnget "Fader1"
  a3 powershape a3, kshapeamt
  a4 madsr iatt,0.5,1,4
  ktrem lfo itremamp, itremfreq
  asig = a3*a4*kamp*(1 - ktrem)
  outs asig, asig
  chnmix asig, "DelaySend"
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
  aout nreverb asig*0.2, 10, 0.5
  outs aout, aout
  chnclear "ReverbSend"
endin

instr 4
  ifader1min init 1
  ifader1max init 50
  ifader1 init 1
  kskip init 0
  if kskip=0 then
    midiout 176, 1, 1, 127*ifader1*ifader1min/ifader1max
    kskip = 1
  endif
  initc7 1, 1, (ifader1 - ifader1min)/(ifader1max - ifader1min)
  kfader1 ctrl7 1, 1, ifader1min, ifader1max
  chnset kfader1, "Fader1"
endin

</CsInstruments>
<CsScore>
f 1 0 32768 10 1
i 1 0 3600
i 2 0 -1
i 3 0 -1
i 4 0 3600
;i 1 0 9 8.05 60
</CsScore>
</CsoundSynthesizer>
