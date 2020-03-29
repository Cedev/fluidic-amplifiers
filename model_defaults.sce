// CONTRL
FINTIM=.04
// CONST
C1=0.4543
C2=0.2752
// INCON
THETA0=0.6
V=6
QS=1
QC1=0
QC2=0
QV1I=0
QV2=0.2
QO1=2
QO2=.5
PLEVEL0=0.2
// PARAM
SIGMA=10
RHO=1.2059
NU=1.4864E-5

// PARAM - supply
clear('L', 'P0', 'CS')

// PARAM - geometry
clear('D', 'B0', 'BC', 'ALPH', 'XV1', 'LGTHC', 'AREAC', 'LGTHS', 'AREAS', 'LGTHV', 'AREAV', 'SPL', 'LGTHR')

// PARAM - control
clear('pre1','pre2','post1','post2','p1','p2')
TRISE=1E-3
P1BIAS=0
P2BIAS=0
CDMAX=.9
CDMIN=.6

// PARAM - environment
PV1=0
PV2=0
PO1=0
PO2=0
