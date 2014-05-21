<CsoundSynthesizer>
<CsOptions>
-o "tmp.wav" -W
;-o dac -Ma
;-M0 -+rtmidi=null --midi-key-pch=4
</CsOptions>
<CsInstruments>
	
sr = 44100
ksmps = 32
nchnls = 2
0dbfs = 1

giTable ftgen   0, 0, -2048, 2, 0

instr 1
ifreq = p4
iamp = p5
iharmonics = 15
iN = 2048
ilen = iN/2 - 1
kfreq_amp[] init iN + 2
ibw = 50
kh = 1

prints "freq: %i\n", ifreq

kTrig metro 1
if kTrig == 1 then
prints "==\n"

until kh == 16 do
;  prints "ih: %i\n", ih
  kbw_Hz = (2^(ibw/1200)-1.0)*ifreq*kh
  kbwi = kbw_Hz/(2.0/sr)
  kfi = ifreq*kh/sr
  kpos = 1
  until 2*kpos == iN + 2 do
    kx = ((kpos/iN) - kfi)/kbwi
    khprofile = exp(-kx*kx)/kbwi
    kfreq_amp[kpos*2] = kfreq_amp[kpos*2] + khprofile
    kfreq_amp[kpos*2-1] = (kpos*2-1)*sr/(iN + 2)
;    prints "ipos: %i\n", ipos*2
;    prints "freq: %f\n", ifreq_amp[ipos*2-1]
;    prints "amp: %f\n", ifreq_amp[ipos*2]
    kpos += 1
  od
  kh += 1
od

kq = 1
until kq == lenarray(kfreq_amp) do
  prints "kq: %i\n", kq
;  prints "x: %f\n", kfreq_amp[kq]
  kq += 1
od

;printf_i "array length: %i\n", 1, lenarray(ifreq_amp)
;kfreq_amp[] init lenarray(ifreq_amp)
;iindex = 0
;until iindex == lenarray(ifreq_amp) do
;  kfreq_amp[iindex] = ifreq_amp[iindex]
;  iindex += 1
;od
;prints "array length k: %i\n", lenarray(kfreq_amp)
;copya2ftab kfreq_amp, giTable
;ftsave "table", 1, giTable
fsig pvsfromarray kfreq_amp
endif
aout pvsynth fsig
;aenv transeg 0, .01, 0, iamp, p3-.01, -3, 0
;aout = aout*aenv
outs aout, aout
endin

</CsInstruments>
<CsScore>

f 0 3600

i 1 0 3 440 1

</CsScore>
</CsoundSynthesizer>
