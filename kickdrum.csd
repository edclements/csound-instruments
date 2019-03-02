<CsoundSynthesizer>
<CsOptions>
</CsOptions>
; ==============================================
<CsInstruments>

sr	=	48000
ksmps	=	1
;nchnls	=	2
0dbfs	=	1

instr 1
  iamp      = p4

  k1  expon     120, .2, 50    
  k2  expon     500, .4, 200
  a1  oscil     iamp, k1, 1
  a2  reson     a1, k2, 50
  a3  butterlp  a2+a1,k1,1
  a4  butterlp  a3,   k1,1
  a5  butterlp  a4,2500,1
  a6  butterhp  a5,50
  a7  butterhp  a6,50
  a8  linen     a7,0.01,p3, .2  
  
  out a8
endin

</CsInstruments>
; ==============================================
<CsScore>

f1 0   1024 10  1      

i1    .1     .4      7
i1    .5     .4      7
i1    .9     .4      7
i1   1.3     .4      7
i1   1.7     .4      7

</CsScore>
</CsoundSynthesizer>

