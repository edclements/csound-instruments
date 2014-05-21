<CsoundSynthesizer>

<CsOptions>
-odac
</CsOptions>

<CsInstruments>
;example written by Iain McCurdy

sr 	= 	44100
ksmps 	= 	32
nchnls 	= 	1	
0dbfs   =       1

; STORE AUDIO IN RAM USING GEN01 FUNCTION TABLE
giSoundFile   ftgen   0, 0, 1048576, 1, "loop.wav", 0, 0, 0

  instr	1; play audio from function table using flooper2 opcode
kAmp         init      1; amplitude parameter
kPitch       init      1; pitch/speed parameter
kLoopStart   init      0; point where looping begins (in seconds) - in this case the very beginning of the file
kLoopEnd     =         nsamp(giSoundFile)/sr; point where looping ends (in seconds) - in this case the end of the file
kCrossFade   =         0; cross-fade time
; READ AUDIO FROM FUNCTION TABLE USING flooper2 OPCODE
aSig         flooper2  kAmp, kPitch, kLoopStart, kLoopEnd, kCrossFade, giSoundFile
             out       aSig; send audio to output
  endin

</CsInstruments>

<CsScore>
i 1 0 6
</CsScore>

</CsoundSynthesizer>


