<CsoundSynthesizer>

<CsOptions>
; amend device number accordingly
-Q999
</CsOptions>

<CsInstruments>
;Example by Iain McCurdy

ksmps = 32 ;no audio so sr and nchnls omitted

seed 0; random number generators seeded by system clock

  instr 1
; read value in from p-field
kchn    =         p4
knum    random    48,72.99; note numbers will be chosen randomly across a 2 octave range
kvel    random    40, 115; velocities are chosen randomly
kdur    random    0.2, 1; note durations will chosen randomly from between the given limits
kpause  random    0, 0.4; pauses between notes will be chosen randomly from between the given limits
        moscil    kchn, knum, kvel, kdur, kpause; send a stream of midi notes
  endin

</CsInstruments>

<CsScore>
;p1 p2 p3 p4
i 1 0  20 1
f 0 21; extending performance time prevents the final note-off from being lost
</CsScore>

</CsoundSynthesizer>


