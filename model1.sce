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
QO2=-.5
PLEVEL0=0.2
// PARAM
L=0
SIGMA=10
RHO=1.2059
NU=1.4864E-5
PRE1=1
PRE2=1
POST1=0
POST2=1
D=0.905
P0=10
CS=0.85
P1=0
P2=0.5
B0=2.1E-3
BC=1
ALPH=.20944
XV1=8.640
P1BIAS=0
P2BIAS=0
PV1=0
PV2=0
PO1=0
PO2=0
LGTHC=10
AREAC=2
LGTHS=15
AREAS=3
LGTHV=10
AREAV=1.95
SPL=10
LGTHR=27.75
TRISE=1.5E-3
CDMAX=.9
CDMIN=.6



// LOOP
DELT=FINTIM/3000
TIME=0
RT=0
x=[]
y=[]
while TIME<FINTIM && RT==0 do
    exec("dsl90.sce", -1)
    x=cat(1,x,[TIME])
    y=cat(1,y,[Z2,POUT1,POUT2])
    TIME=TIME+DELT
end
plot2d(x, y)
