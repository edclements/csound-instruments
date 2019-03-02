<CsoundSynthesizer>
;<CsOptions>
;-odac -Ma
;-+rtmidi=virtual -M0
;-+rtmidi=alsa -M hw:4
;-M 2
;-M0 -+rtmidi=null --midi-key-pch=4
;-+rtmidi=jack -M system:midi_capture_3 -+rtaudio=jack -odac -b 64 -B 256
;</CsOptions>
<CsInstruments>

;JackoInit "default", "csound"
;JackoMidiInConnect "system:midi_capture_3", "csound_midi"
;JackoOn 1
	
;sr = 48000
;kr = 6000
;ksmps = 32
;nchnls = 2

chn_k "my_channel", 1

instr 1	

  kval chnget "my_channel"
  printk2 kval

  ;kpch init 0
  ;kvelocity init 0

  kvdepth init 0.005
  kvrate init 6

;  kvdepth = p6
;  kvrate = p7

  kc1 = 5
  kc2 = 5
  ;kvdepth = 0.005
  ;kvrate = 6
  ifn1 = 1
  ifn2 = 1
  ifn3 = 1
  ifn4 = 1
  ivfn = 1

  midinoteonpch p4, p5
  kvdepth ctrl7 1, 1, 0.001, 10
  kvrate ctrl7 1, 2, 0, 100
  kpch = p4
  ;kamp = p5
  kamp = ampdbfs(-20)

  kfreq = cpspch(kpch)
  asig fmbell kamp, kfreq, kc1, kc2, kvdepth, kvrate, ifn1, ifn2, ifn3, ifn4, ivfn
  aenv madsr 0.5, 0, 1, 0.5
  out asig*aenv

  ;printk2 kvdepth
  printk2 p4

endin

</CsInstruments>
<CsScore>
f0 3600

f 1 0 32768 10 1

i 1 0 3 9.03 100
i 1 0 3 8.03 100
i 1 0 3 7.00 100
e

</CsScore>
</CsoundSynthesizer>


