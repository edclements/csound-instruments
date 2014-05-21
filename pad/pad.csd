<CsoundSynthesizer>
<CsOptions>
-o "tmp.wav" -W
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

giTable ftgen   0, 0, -2048, 2, 0

giSine    ftgen     0, 0, 2^10, 10, 1
          massign   0, 1 ;all midi channels to instr 1

instr 1
ifreq = cpspch(p4)
iamp = p5
iharmonics = 15
;ifreq = 440
;iN = 262144
;iN = 2^6
;iN = 2^18
iN = 2048
ilen = iN/2 - 1
ifreq_amp[] init iN + 2
ibw = 50

printf_i "freq: %i\n", 1, ifreq

;harmonics_loop:
;  ia pow 2, ibw/1200
;  ibw_Hz = (ia - 1.0)*ifreq*ih
;  ibwi = ibw_Hz/(2.0*sr)
;  ifi = ifreq*ih/sr

;  ipos = 0
;  iend = iN/2 - 1
;  harmonic_loop:
;    ix = ((ipos/iN) - ifi)/ibwi
;    ihprofile = exp(-ix*ix)/ibwi
;    ifreq_amp[ipos] = ihprofile + ifreq_amp[ipos]
;    loop_lt ipos, 1, iend, harmonic_loop
;  loop_le ih, 1, iharmonics, harmonics_loop

ih = 1
until ih == 16 do
;  prints "ih: %i\n", ih
  ibw_Hz = (2^(ibw/1200)-1.0)*ifreq*ih
  ibwi = ibw_Hz/(2.0/sr)
  ifi = ifreq*ih/sr
  ipos = 1
  until 2*ipos == iN + 2 do
    ix = ((ipos/iN) - ifi)/ibwi
    ihprofile = exp(-ix*ix)/ibwi
    ifreq_amp[ipos*2] = ifreq_amp[ipos*2] + ihprofile
    ifreq_amp[ipos*2-1] = (ipos*2-1)*sr/(iN + 2)
;    prints "ipos: %i\n", ipos*2
;    prints "freq: %f\n", ifreq_amp[ipos*2-1]
;    prints "amp: %f\n", ifreq_amp[ipos*2]
    ipos += 1
  od
  ih += 1
od

;iq = 1
;until iq == lenarray(ifreq_amp) do
;  prints "x: %f", ifreq_amp[iq]
;  iq += 1
;od

printf_i "array length: %i\n", 1, lenarray(ifreq_amp)
kfreq_amp[] init lenarray(ifreq_amp)
iindex = 0
until iindex == lenarray(ifreq_amp) do
  kfreq_amp[iindex] = ifreq_amp[iindex]
  iindex += 1
od
prints "array length k: %i\n", lenarray(kfreq_amp)
;copya2ftab kfreq_amp, giTable
;ftsave "table", 1, giTable
fsig pvsfromarray kfreq_amp
aout pvsynth fsig
;aenv transeg 0, .01, 0, iamp, p3-.01, -3, 0
;aout = aout*aenv

;prints "====\n"
;prints "----\n"
;aout = 10000000*aout
;display aout, 3
;prints "++++\n"
;dispfft	aout, .1, 2048, 0, 1
;dispfft aout, 0.1, iN
;gi_padsynth_1 ftgen 0, 0, iN, 33, ifreq_amp, iN, 1
;asig oscili iamp, ifreq*(sr/iN/440), gi_padsynth_1, 0

outs aout, aout
endin

</CsInstruments>
<CsScore>
f 0 3600
</CsScore>
</CsoundSynthesizer>
