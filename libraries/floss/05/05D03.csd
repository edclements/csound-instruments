<CsoundSynthesizer>

<CsOptions>
-odac ;activates real time sound output
</CsOptions>

<CsInstruments>
;Example by Iain McCurdy

sr = 44100
ksmps = 32
nchnls = 1
0dbfs = 1

giSine   ftgen   0, 0, 2^12, 10, 1; a sine wave

  instr 1
; create an input signal
kEnv          loopseg  0.5, 0, 0, 0,0.0005, 1 , 0.1, 0, 1.9, 0
aEnv          interp   kEnv
aSig          poscil   aEnv, 500, giSine

aDelayTime    randomi  0.05, 0.2, 1; modulating delay time
; create a delay buffer
aBufOut       delayr   0.2; read audio from end of 0.3s buffer
aTap          deltapi  aDelayTime; 'tap' the delay buffer somewhere along its length
              delayw   aSig + (aTap*0.9); write audio into buffer (mix in feedback signal)

; send audio to ther output (mix the input signal with the delayed signal)
              out      aSig + ((aTap)*0.4)
  endin


</CsInstruments>

<CsScore>
i 1 0 30
e
</CsScore>

</CsoundSynthesizer


