<CsoundSynthesizer>
<CsOptions>
; Select audio/midi flags here according to platform
;-odac      ;;;realtime audio out
--sample-rate=44100
--control-rate=1378.125
-+rtaudio=jack
-o dac:system:playback_

;-iadc    ;;;uncomment -iadc if realtime audio input is needed too
; For Non-realtime ouput leave only the line below:
; -o pvsanal.wav -W ;;; for file output any platform
</CsOptions>
<CsInstruments>

sr = 44100
ksmps = 32
nchnls = 2
0dbfs = 1

instr 1	;pvsanal has no influence when there is no transformation of original sound

ifftsize  = p4
ifn	ftgen	0, 0, ifftsize, 10, 1
ioverlap  = ifftsize / 4
iwinsize  = ifftsize
iwinshape = 1							;von-Hann window
Sfile     = "Ensoniq-SD-1-Electric-Piano-C6.wav"
ain, ainR soundin Sfile
fftin     pvsanal ain, ifftsize, ioverlap, iwinsize, iwinshape	;fft-analysis of the audio-signal
fftblur   pvscale fftin, p5					;scale
aout      pvsynth fftblur					;resynthesis

;t1 init ifftsize + 2
;kflag pvs2tab t1, fftin

kflag	pvsftw fftin, ifn

;pvsfwrite fftin, "log"
;kArr[]   init      ifftsize+2
;kflag pvs2array kArr, fftin

;copya2ftab kArr, itab

knewflag changed kflag
if knewflag == 1 then
ftsavek "table", 1, ifn
;ki = 0
;until ki > lenarray(kArr) do
;  printks "%i: %f ### %f\n", 1, ki, kArr[ki], kArr[ki+1]
;  ki += 2
;od
endif

aout = 0.8*aout
outs aout, aout
endin

</CsInstruments>
<CsScore>
s
i 1 0 1 512 1		;original sound - ifftsize of pvsanal does not have any influence
;i 1 3 3 1024 1		;even with different
;i 1 6 3 2048 1		;settings

s
;i 1 0 3 512 1.5		;but transformation - here a fifth higher
;i 1 3 3 1024 1.5	;but with different settings
;i 1 6 3 2048 1.5	;for ifftsize of pvsanal

e
</CsScore>
</CsoundSynthesizer>

