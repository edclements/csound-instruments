<CsoundSynthesizer>
<CsOptions>
</CsOptions>
; ==============================================
<CsInstruments>

sr	=	48000
ksmps	=	1
nchnls	=	2
0dbfs	=	1

massign 0, 2

instr 1	
  /* midinoteonoct p4, p5 */
  /* kvel = p5/127 */
  kenv madsr 3, 0.8, 0.8, 3 
  asig buzz p5*kenv, p4, 10, 1
  /* kq = 500 */
  /* asig mode asig, kcps, kq */
  /* kreverbtime = 3 */
  /* kvarlooptime = 4 */
  /* imaxlooptime = 5 */
  /* asig vcomb asig, kreverbtime, kvarlooptime, imaxlooptime */
  /* outs asig, asig */
  chnmix asig, "ModeSend"
endin

instr 2
  prints "instr 2"
  /* asig chnget "ModeSend" */
  /* ivel ampmidi 1 */
  kyaxis init 0
  midicontrolchange 74, kyaxis, 0, 1
  kfader1 ctrl7 1, 1, 0, 1
  kfader2 ctrl7 1, 2, 0, 1
  kfader3 ctrl7 1, 3, 0, 1
  kfader4 ctrl7 1, 4, 0, 1
  kafter aftouch 0.4, 1
  icps1 cpsmidi
  kcps2 cpsmidib
  kenv madsr 3, 0.8, 0.8, 4
  asig buzz 0.6*kenv, kcps2, 10, 1
  /* ares reson asig*kenv, kcps, 50 */
  /* ares wguide1 asig*kenv, kcps, 500, 0.3 */
  kq = 1000*(1 + kfader1)
  printk2 kq
  ares mode asig, kcps2, kq
  aout balance ares, asig
  /* kreverbtime = 3 */
  /* kvarlooptime = 4 */
  /* imaxlooptime = 5 */
  /* asig vcomb asig, kreverbtime, kvarlooptime, imaxlooptime */
  outs aout, aout
  /* chnclear "ModeSend" */
endin

</CsInstruments>
; ==============================================
<CsScore>

f 0 3600
f 1 0 16384 10 1

/* i 1 0 3600 220 0.6 */

</CsScore>
</CsoundSynthesizer>

