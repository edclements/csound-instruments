; Sample score for tube opcode

; reads data from a wav file

; applies the opcode

; and sends it to the output



<CsoundSynthesizer>

<CsOptions>

</CsOptions>

<CsInstruments>

sr = 44100						; sample rate, a-rate

ksmps =  32						; subsampling for k-rate                                                                     

nchnls = 1						; mono

0dbfs = 1							; set 0 dB

instr 1

ain 	soundin "Sinus.wav"; read audio from wav file ;
atube tube ain,	sr, "config.txt"; virtual opcode "tubeamp" with input ain and aoutput aout

out atube				; default write to wav-file

endin

</CsInstruments>

<CsScore>

i 1 0 15						; instrument 1 runs for 10secs 				

e									; end of score			

</CsScore>

</CsoundSynthesizer>


; Marco Fink, Rudolf Rabenstein - LMS, Univ. Erlangen-Nuernberg, 2011



