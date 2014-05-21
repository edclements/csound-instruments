<CsoundSynthesizer>
<CsOptions>
; Select audio/midi flags here according to platform
;-odac     ;;;RT audio out
;-iadc    ;;;uncomment -iadc if RT audio input is needed too
; For Non-realtime ouput leave only the line below:
; -o chebyshevpoly.wav -W ;;; for file output any platform
</CsOptions>
<CsInstruments>

;sr = 44100
;ksmps = 32
nchnls = 2

0dbfs = 1

; time-varying mixture of first six harmonics
instr 1
	; According to the GEN13 manual entry,
	; the pattern + - - + + - - for the signs of 
	; the chebyshev coefficients has nice properties.

  midinoteonpch p4, p5
  kpch = p4
  kamp = 0.1*p5/127
  kfreq = cpspch(kpch)
  printk2 kamp
  printk2 kfreq
  p3 = 1.0
	
  itable chnget "table_sine"
  if (itable == 0) then
    ;itable ftgen 0, 0, 32768, 10, 1 ; sine wave
    itable	ftgen 0,0, 65537, 10, 1 ; sine wave
    chnset itable, "table_sine"
  endif

	; these six lines control the relative powers of the harmonics
	k1 line 1.0, p3, 0.0
	k2 line -0.5, p3, 0.0
	k3 line -0.333, p3, -1.0
	k4 line 0.0, p3, 0.5
	k5 line 0.0, p3, 0.7
	k6 line 0.0, p3, -1.0
  k1 jitter k1, kfreq/2, kfreq
  k2 jitter k2, kfreq/3, kfreq/2
  k3 jitter k3, kfreq/4, kfreq/3
  k4 jitter k4, kfreq/6, kfreq/5
  k5 jitter k5, kfreq/7, kfreq/6
  k6 jitter k6, kfreq/8, kfreq/7

	ax oscili 1, kfreq, itable

	ay chebyshevpoly ax, 0, k1, k2, k3, k4, k5, k6
	
  adeclick madsr 0.5, 0.3, 1, 5
	outs ay * adeclick * kamp, ay * adeclick * kamp
endin

</CsInstruments>
<CsScore>
;f1 0 32768 10 1	; a sine wave

f 0 3600

;i1 0 5
e

</CsScore>
</CsoundSynthesizer>
