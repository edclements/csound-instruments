<Cabbage>
form size(400, 220), caption("FM Synth"), pluginID("plu1")
hslider  bounds(0, 110, 380, 50), channel("lfofreq"), range(0, 8000, 4000), textBox(1)
hslider  bounds(0, 170, 380, 50), channel("mod"), range(0, 5, 0.5), textBox(1)
keyboard bounds(0, 0, 380, 100)
</Cabbage>
<CsoundSynthesizer>
<CsOptions>
-n -d -+rtmidi=NULL -M0 --midi-key-cps=4 --midi-velocity-amp=5
</CsOptions>
<CsInstruments>

sr =	44100
ksmps	=	1
nchnls	=	2
0dbfs	=	1

instr 1	

  kcps = p4
  kcar = 1
  kmod chnget "mod"
  ;kmod = 0.5
  ;kndx line 0, p3, 20	;intensivy sidebands
  ;kndx = 10
  ;kndx linsegr 1, .05, 0.5, 1, 0
  kndx madsr 0.2, 0.5, 1, 1
  aenv madsr 0.2, 0.5, 1, 2

  klfofreq chnget "lfofreq"
  apan lfo 0.5, klfofreq, 0
  apan = apan + 0.5

  asig foscili .5, kcps, kcar, kmod, kndx, 1
  asig = aenv*asig
  a1, a2 pan2 asig, apan
  outs a1, a2

endin

</CsInstruments>
<CsScore>

f 1 0 16384 10 1
f0 3600
;i 1 0  9 440 .01	;vibrato
;i 1 10 . 440 1
;i 1 20 . 440 1.414	;gong-ish
;i 1 30 5 440 2.05	;with "beat"
e

</CsScore>
</CsoundSynthesizer>

