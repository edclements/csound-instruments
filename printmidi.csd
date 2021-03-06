<CsoundSynthesizer>
<CsOptions>
</CsOptions>
<CsInstruments>

ksmps	=	32

instr 1
  knotelength init 0
  knoteontime init 0
  kstatus, kchan, kdata1, kdata2 midiin
  if (kstatus == 128) then
    knoteofftime times
    knotelength = knoteofftime - knoteontime
    printks "kstatus= %d, kchan = %d, \\tnote#  = %d, velocity = %d \\tNote OFF\\t%f %f\\n", 0, kstatus, kchan, kdata1,kdata2, knoteofftime, knotelength
  elseif (kstatus == 144) then
    knoteontime times
    printks "kstatus= %d, kchan = %d, \\tnote#  = %d, velocity = %d \\tNote ON\\t%f\\n", 0, kstatus, kchan, kdata1, kdata2, knoteontime
  elseif (kstatus == 160) then
    printks "kstatus= %d, kchan = %d, \\tkdata1 = %d, kdata2 = %d \\tPolyphonic Aftertouch\\n", 0, kstatus, kchan, kdata1, kdata2
  elseif (kstatus == 176) then
    printks "kstatus= %d, kchan = %d, \\t CC = %d, value = %d \\tControl Change\\n", 0, kstatus, kchan, kdata1, kdata2
  elseif (kstatus == 192) then
    printks "kstatus= %d, kchan = %d, \\tkdata1 = %d, kdata2 = %d \\tProgram Change\\n", 0, kstatus, kchan, kdata1, kdata2
  elseif (kstatus == 208) then
    printks  "kstatus= %d, kchan = %d, \\tkdata1 = %d, kdata2 = %d \\tChannel Aftertouch\\n", 0, kstatus, kchan, kdata1, kdata2
  elseif (kstatus == 224) then
    printks "kstatus= %d, kchan = %d, \\t ( data1 , kdata2 ) = ( %d, %d )\\tPitch Bend\\n", 0, kstatus, kchan, kdata1, kdata2
  endif
endin

</CsInstruments>
<CsScore>

i 1 0 3600

</CsScore>
</CsoundSynthesizer>

