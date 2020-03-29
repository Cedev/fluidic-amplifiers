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
P1=0.5
P2=0
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


function check_nan_variable(name)
    [obj, ierr] = evstr(name)
    if ierr == 0 then
        if isnan(obj) then
            disp("NaN variable", name, obj)
        end
    end
endfunction

function check_nan()
    names = who_user(%f)
    for name=names.'
        check_nan_variable(name)
    end
endfunction


// LOOP
DELT=FINTIM/3000
TIME=0
RT=0
times=[]
pressures=[]
flows=[]
while TIME<FINTIM && RT==0 do
    /*
    if TIME > (0.0207600 - DELT*3.5) && TIME <= 0.0207600 then
        disp("Checking for NaN at time", TIME)
        check_nan()
    end
    */
    exec("amplifier_simulation.sce", -1)
    times=cat(1,times,[TIME])
    pressures=cat(1,pressures,[PC1,PC2,POUT1,POUT2, BETA])
    flows=cat(1,flows,[QS, QC1, QC2, QO1, QO2, QV1, QV2])
    TIME=TIME+DELT
end
scf(0)
clf()
plot2d(times, pressures)
legend("PC1", "PC2", "POUT1", "POUT2", "BETA", -1)
scf(1)
clf()
plot2d(times, flows)
legend("QS", "QC1", "QC2", "QO1", "QO2", "QV1", "QV2", -1)
