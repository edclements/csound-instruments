<CsoundSynthesizer>
<CsOptions>
-odac
</CsOptions>
<CsInstruments>
;example by joachim heintz
sr = 44100
ksmps = 32
nchnls = 2
0dbfs = 1

  opcode FiltFb, aa, akkkia
;;DELAY AND FEEDBACK OF A BAND FILTERED INPUT SIGNAL
;input: aSnd = input sound; kFb = feedback multiplier (0-1); kFiltFq: center frequency for the reson band filter (Hz); kQ = band width of reson filter as kFiltFq/kQ; iMaxDel = maximum delay time in seconds; aDelTm = delay time
;output: aFilt = filtered and balanced aSnd; aDel = delay and feedback of aFilt
aSnd, kFb, kFiltFq, kQ, iMaxDel, aDelTm xin
aDel      init      0
aFilt     reson     aSnd, kFiltFq, kFiltFq/kQ
aFilt     balance   aFilt, aSnd
aDel      vdelayx   aFilt + kFb*aDel, aDelTm, iMaxDel, 128; variable delay
          xout      aFilt, aDel
  endop

giSine    ftgen     0, 0, 2^10, 10, 1
          seed      0

instr 1
endin
</CsInstruments>
</CsoundSynthesizer>

