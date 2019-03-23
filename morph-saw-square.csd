<CsoundSynthesizer>
<CsOptions>
</CsOptions>
<CsInstruments>

nchnls	=	2
0dbfs	=	1

/* giSquare ftgen 0, 0, 8193, 7, 1, 4096, 1, 0, -1, 4096, -1 */
/* giSaw ftgen 0, 0, 8193, 7, 1, 8192, -1 */
/* giSine   ftgen  0, 0, 8193, 10, 1           ; sine wave */
/* giSquare ftgen  0, 0, 8193, 7, 1, 4096, 1, 0, -1, 4096, -1      ; square wave */ 
/* giTri  ftgen  0, 0, 8193, 7, 0, 2048, 1, 4096, -1, 2048, 0      ; triangle wave */ 
/* giSaw  ftgen  0, 0, 8193, 7, 1, 8192, -1          ; sawtooth wave, downward slope */ 

instr 1
  isquare ftgenonce 0, 0, 8193, 7, 1, 4096, 1, 0, -1, 4096, -1      ; square wave 
  isaw ftgenonce 0, 0, 8193, 7, 1, 8192, -1          ; sawtooth wave, downward slope 
  icps = p4
  iamp = p5/127
  aindex phasor icps
  kweightpoint linseg 0.99, p3, 0, -1
  /* kweightpoint = p6 */
  asig tabmorphak aindex, kweightpoint, 0, 1, isquare, isaw
  /* asig poscil 1, icps, 2 */
  asig = asig*iamp
  outs asig, asig
endin

</CsInstruments>
<CsScore>
/* f 1 0 8192 7 1 4096 1 0 -1 4096 -1 ;square */
/* f 2 0 8192 7 1 8192 -1 ;saw down */

i 1 0 5 220 100
/* i 1 0 1 220 100 0 */
/* i 1 + 1 220 100 0.2 */
/* i 1 + 1 220 100 0.6 */
/* i 1 + 1 220 100 0.9 */

</CsScore>
</CsoundSynthesizer>

