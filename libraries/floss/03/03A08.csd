<CsoundSynthesizer>
<CsOptions>
</CsOptions>
<CsInstruments>
;example by joachim heintz
sr = 44100
ksmps = 4410; try 44100 or 2205 instead

instr 1; prints the time once in each control cycle
kTimek   timek
kTimes   times
         printks    "Number of control cycles = %d%n", 0, kTimek
         printks    "Time = %f%n%n", 0, kTimes
endin
</CsInstruments>
<CsScore>
i 1 0 10
</CsScore>
</CsoundSynthesizer>

