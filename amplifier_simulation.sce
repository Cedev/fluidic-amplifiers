function C=COMPAR(X1, X2)
    C=1*(X2>=X1)
endfunction

if ~(TIME > 0) then
    // R0 is undefined
    R0 = D
    // Undefined variable: R
    R = R0

    UPLUS=44.72*sqrt(P0/RHO)
    CONV=B0*UPLUS
    RE=CONV/NU
    TAUTR=B0/UPLUS
    PB2=1-QS^2*(1-1/(2*R0))
    PAV=1-QS^2*(1+1/(2*R0))
    PSY=0.5*(PAV+PB2)
    B02=B0*B0
    BC2=BC*BC
    SA=sin(ALPH)
    CA=cos(ALPH)
    CA2=CA*CA
    TA=tan(ALPH)
    A1=3/SIGMA
    A2=(D+0.5)*CA
    A3=(D+0.5)*SA
    A4=(D+0.5)*TA
    C3=C1/C2
    C4=(C2/(2*C1))^3
    C7=0.5*C2/(2*C1)^2
    LC=2*LGTHC/AREAC
    LS=2*LGTHS/AREAS
    KC=D+BC*TA
    RCMAX=1/(.1414*BC)^2
    AREAR=A2+SPL*SA
    LO=2*LGTHR/AREAR
    LV2=2*LGTHV/AREAV
    RO1=1/AREAR^2
    RO2=1/AREAR^2
    RV2=1/AREAV^2
    RV11=1/AREAV^2
    if ~(L > 0) then
        UEM=sqrt(1/3)
        SEM=2/A1
    end
    
    // PROGRAM INITIAL CONDITIONS
    
    T1=10.0E5
    T2=10.0E5
    TTT=0
    TTTT=0
    TINCON=0
    CLOSE1=PRE1
    CLOSE2=PRE2
    WL=0
    XI2=0
    RT=0
    PLEVEL=PLEVEL0
    IT=0
end

// START CALC OF DISCHARGE COEFF AND MIN RESISTANCES

REC1=abs(QC1*RE)
REC2=abs(QC2*RE)

if REC1 < 2500 then
    D1=CDMAX
else
    D1=-(CDMAX-CDMIN)*REC1/1E4+1.25*CDMAX-0.25*CDMIN
end

if REC2 < 2500 then
    // Undefined variable: D2
    // if REC2 > 1000 then
        D2=CDMAX
    // end
else
    D2=-(CDMAX-CDMIN)*REC2/1E4+1.25*CDMAX-0.25*CDMIN
end

D12=D1*D1
D22=D2*D2
RCMIN1=1/(BC2*D12)
RCMIN2=1/(BC2*D22)

//THE FOLLOWING GENERATES THE INITIAL CONDITION PRINTOUT AND STARTS
//  THE TIME DEPENDENT PROBLEM

if ~(TIME < FINTIM/2) then
    if ~(TTT > 0) then
        TTT=1
        T1=TIME
        T2=TIME
        TINCON=TIME
        CLOSE1=POST1
        CLOSE2=POST2
        disp("FINTIM/2", V,THETA,R,QC1,QC2,QV1,QS,PDOUT1,PDOUT2)
    end
end

// START CALC OF PRESSURE LEVEL

if ~(TIME <= IT) then
    QO1AVL=QS+QC1+QC2+QV1+QV2+QO2 // +QV1A which doesn't exist
    PLUS=sign(QO1AVL-QO1)
    DP=RO1*PLUS*(QO1-QO1AVL)^2
    PLEVEL=PLEVEL+DP
    IT=TIME
end

//  END CALC OF PRESSURE LEVEL

TNOND=(TIME-FINTIM/2)/TAUTR
Z2=1*(TIME>=T2) // STEP(T2)

// START CALC FOR JET DEFLECTION

QS2=QS*QS
if QC2 >= 0 then
    FACTOR=1
end
if QC2 < 0 then
    FACTOR=0
end
FC1=(PAV+2*(QC1/BC)^2)*BC
FC2=(PB2+2*(QC2*FACTOR/BC)^2)*BC
FSY=PSY+2*QS2
BETA=atan((FC1-FC2)/FSY)
if isnan(BETA) then
    disp("NaN BETA", TIME, BETA, FC1, FC2, FSY)
    RT = 1
end

// END CALC FOR JET DEFLECTION

GAM=(ALPH+BETA)
SG=sin(GAM)
CG=cos(GAM)
VCL=V+0.5*R*R*(XI2-sin(XI2)) // Eq 35
// B2=A2^2/(2*VCL+A2*A4)

// START IMPLICIT ROUTINE FOR ATTACHMENT ANGLE THETA

/*
function GAD=gad(THETA)
    ST=sin(THETA)
    CT=cos(THETA)
    ROOT1=(B2*(SG+.5*ST)-CG)^2-CG*CG+B2*(GAM+THETA+.5*sin(2*GAM))
    SAD=acos(-B2*(SG+.5*ST)+CG-sqrt(abs(ROOT1)))
    GAD=abs(SAD)
endfunction

epsilon=1.0E-03
[THETA]=fsolve(THETA0,gad,epsilon)
ST=sin(THETA)
CT=cos(THETA)

if (abs(gad(THETA)) > epsilon ) then
    disp("No solution for theta")
    disp("B2", B2, V, VCL, R, XI2, A2, A4)
    disp("Angles", ALPH, BETA, GAM, THETA)
    xs = linspace(-%pi, %pi, 300)
    plot2d(xs, gad(xs))
    RT = 1
end
*/

// Implicit routine for radius of jet curvature

function ba=bubble_area(r)
    // See diagram on page 14
    // x = A2/CG
    // theta = acos((r-x)*CG/r)
    // theta = acos((r-A2/CG)*CG/r)
    wedge_length = A2/CG
    theta = acos(CG-A2*r^-1)
    wedge_area = 0.5*sin(BETA)*(D + 0.5)*wedge_length
    outside_area = 0.5*(r-wedge_length).*r.*sin(GAM+theta)
    ba = 0.5*r^2.*(GAM+theta) + wedge_area - outside_area
endfunction

function ea=extra_area(r)
    ea=bubble_area(r)-VCL
endfunction

epsilon=1.0E-06
[R]=fsolve(R0,extra_area,epsilon)
THETA=acos(CG-A2/R)
ST=sin(THETA)
CT=cos(THETA)

if (abs(extra_area(R)) > epsilon ) then
    disp("No solution for R")
    disp("TIME", TIME)
    disp("R", R, XI2, A2, CG, VCL, bubble_area(R))
    disp("Angles", ALPH, BETA, GAM, THETA)
    //xs = linspace(0, 100, 300)
    //plot2d(xs, bubble_area(xs))
end

// START CALC OF GEOMETRIC VARIABLES

// R=A2/(CG-CT)      // Eq 22
S1=R*(GAM+THETA)  // Eq 23
if (S1 < 0) then
    disp("Negative jet arc length S1", S1, R, GAM, THETA, gad(THETA))
    RT=1
end
SB=R*sin(BETA)
CB=R*cos(BETA)
CB2=CB*CB

if (BETA > 0) then
    BW=CA2*(A4+TA*CB-SB)
    BW2=BW*BW
    CW=A2*A2+2*A2*CA*CB
    // CALC IF JET CL INTERSECTS OPPOSITE WALL
    if ~(BETA < ALPH) then
        ARG5=BW2-CW
        if ~(ARG5 < 0) then
            ROOT5=sqrt(ARG5)
            X1=-BW-ROOT5
            X2=-BW+ROOT5
            if ~(X1 < 0 || X2 < 0)
                XI1=BETA-asin((SB-X1)/R)
                XI2=BETA-XI1+asin((X2-SB)/R)
                SWO=R*XI2
                LEW=2*R*sin(XI2/2)
                WL=LEW/SWO
            end
        end
    end
end

// START CALC FOR MOMENTUM PEELED OFF BY SPLITTER

ZET=atan(CB/(SPL-SB))

if ZET > (%pi/2-THETA-ALPH) then
    SS=R*(BETA-ZET+%pi/2)
    XSI=sqrt(CB^2+(SPL-SB)^2)
    YS=XSI-R
    
    // START CALC FOR MOMENTUM AT ATTACHMENT POINT
    
    if L>0 then
        S0=C4*RE*QS
        TS=tanh(YS*C2*(QS*RE/(SS+S0))^(2/3))
    else
        S0=SIGMA/3
        TS=tanh((YS*SIGMA)/(SS+S0))
    end
else
    TS=1
end
B = 1.5*(-TS+(TS^3/3)+2/3+(2/3+TS-(TS^3/3))*cos(THETA))
T=2*cos((2*%pi-acos(-B/2))/3)

// START ENTRAINED FLOW AND RETURNED FLOW CALCS

if L>0 then
    SUM1=S1+S0
    SUM1=S1+S0 // [sic]?
    CBR=(QS2/RE)^(1/3)
    QR1=C3*CBR*SUM1^(1/3)*(1-T)
    QE1=C3*CBR*SUM1^(1/3)-0.5*QS
    SEM=S0*(sqrt(27)-1)
    UEM=C1*(2*C3-1/3)/sqrt(3)*QS
else
    ARG6=A1*S1+1
    ROOT6=sqrt(ARG6)
    QR1=.5*QS*ROOT6*(1-T)
    QE1=.5*QS*(ROOT6-1)
end
if ~isreal(QE1) || ~isreal(QR1) then
    disp("Unreal flow", QE1, QR1, A1, S1)
end

// END ENTRAINED FLOW AND RETURNED FLOW CALCS

ARG8=CB2-BC2+2*BC*SB  // Eq 47
if ARG8 < 0 then
    disp("Negative ARG8", TIME, CB2, BC2, BC, SB)
    ARG8 = 0
end
ROOT8=sqrt(ARG8) // Eq 47
DYC=-CB+ROOT8 // Eq 47

// BEGIN CALC FOR CONTROL RESISTANCE

RC1D=1/((KC+DYC)^2+1.0E-5)
RC2D=1/((KC-DYC)^2+1.0E-5)

if RC1D >= RCMIN1 && RC1D <= RCMAX then // sic/RCMIN/RCMIN1
    RC1=RC1D
end
if RC1D > RCMAX then
    RC1=RCMAX
end
if RC1D < RCMIN1 then
    RC1 = RCMIN1
end
if RC2D >= RCMIN2 && RC2D <= RCMAX then // sic/RCMIN/RCMIN2
    RC2=RC2D
end
if RC2D > RCMAX then
    RC2=RCMAX
end
if RC2D < RCMIN2 then
    RC2 = RCMIN2
end
if RC1 == RC1D then
    D1=1
end
if RC2 == RC2D then
    D2=1
end

// BEGIN CALC FOR VENT RESISTANCE

ZETA=atan((XV1*CA-SB)/(CB-D-0.5-XV1*SA))
SV=R*(BETA+ZETA)
if L > 0 then
    Y1=C7*(1*(S1/S0+1))^(2/3)*log((1+T)/(1-T)) // ALOG
    YV=Y1*((SV+S0)/(S1+S0))^(2/3)
else
    Y1=(A1*S1+1)/6*log((1+T)/(1-T))
    YV=Y1*(A1*SV+1)/(A1*S1+1)
end
XCL=R*(SG+ST)-A3
XAP=XCL-Y1/sin(THETA)
CO1=XAP-XV1
E=COMPAR(XAP,XV1)
if E > 0 then
    DV=R-YV-((XV1*CA-SB)/sin(ZETA))
else
    DV=0
end
if E > 0 then
    if CO1 < AREAV then
        RV1=1/(DV^2+1.0E-5)
    else
        RV1=1/AREAV^2
    end
else
    RV1=0
end

// BEGIN CALC FOR BUBBLE VORTEX VELOCITY

SE=0.5*S1
if SE <= SEM then
    // VORTEX DRIVING VEL BASED ON CUBIC EQ LAMINAR AND TURBULENT
    M1=2*(QS-UEM)/(SEM^3) // OEM?
    M2=-1.5*M1*SEM
    UE=M1*SE^3+M2*SE^2+QS
    UE2=UE*UE
else
    if L > 0 then
        // VORTEX DRIVING VEL BASED ON ENTRAINMENT LAMINAR
        CBL=(RE*QS/(SE+SO))^(1/3)
        UE=C1*QS*CBL*(1-(C2/(2*C1))^2*CBL^2)
        UE2=UE*UE
    else
        // VORTEX DRIVING VEL BASED ON ENTRAINMENT TURBULENT
        SE1=1/(A1*SE+1)
        UE2=2.25*SE1*(1-SE1)*(1-SE1)*QS2

        if isnan(SE1) then
            disp("NaN SE1", TIME, SE1,A1,SE,UE2)
            RT = 1
        end
    end
end

// END CALC FOR BUBBLE VOTEX VELOCITY

PB1=-0.5*UE2+PLEVEL
DELPB=2*QS2/R
PB2=PB1+DELPB
PAV=0.5*(PB1+PB2)
PSY=0.5*(PAV+PB2)

// START CALC OF INPUT RAMP GRADIENT

if ~(TIME < FINTIM/2) then
    if ~(TTTT > 0) then
        DPDT=(P1-PAV)/(TRISE/TAUTR)
        PB10=PAV
        TTTT=1
    end
end

// CONTROL RAMP

if (TIME <= FINTIM/2) then
    PRISE=0
else
    if (TIME > TRISE + FINTIM/2) then
        PRISE=P1
    else
        PRISE=(P1-PB10)*(TIME-FINTIM/2)/TRISE+PB10
    end
end
P1B=PAV
P2B=PB2

// START CALC OF INPUT AND OUTPUT PRESSURES

PC1=(1-CLOSE1)*(PRISE+P1BIAS)+CLOSE1*P1B
PC2=(1-CLOSE2)*(P2*Z2+P2BIAS)+CLOSE2*P2B
PD1=0.75*QS2*(TS+T-(TS^3+T^3)/3)/AREAR // Eq 61a
PD2=0.75*QS2*(2/3-TS+TS^3/3)/AREAR     // Eq 61b
POUT1=PD1+PB2
POUT2=PD2+PB2
PDOUT1=(QO1/AREAR)^2
PDOUT2=(QO2/AREAR)^2

// START CALC OF INTEGRALS FOR VOLUME AND ALL FLOWS

QSprime=CONV*(1-PSY-QS*abs(QS)/CS^2)/(LS*B02)*CS
QC1prime=CONV*(PC1-P1B-RC1*QC1*abs(QC1))/(LC*B02)*D1
QC2prime=CONV*(PC2-P2B-RC2*QC2*abs(QC2))/(LC*B02)*D2
QV1=(E>0)*QV1I
if E > 0 then
    LV=2*LGTHV*sqrt(RV1)
    QV1DOT=CONV*(PV1-PB1-RV1*QV1*abs(QV1))/(LV*B02)
else
    QV1DOT = 0
end
if isnan(QV1DOT) then
    disp("NaN QV1DOT", TIME, QV1DOT, ARGQV1, PV1, PB1, QV1, LV, RV1)
    RT=1
end
Vprime=CONV*(QC1-QE1+QR1+QV1)/B02
if ~isreal(Vprime) then
    disp("Unreal bubble volume change", Vprime,QC1,QE1,QR1,QV1,B02)
    RT=1
end
QV2prime=CONV*(PV2-PB2-RV2*QV2*abs(QV2))/(LV*B02)
QO1prime=CONV*(PD1+PB2-PO1-RO1*QO1*abs(QO1))/(LO*B02)
QO2prime=CONV*(PO2-PD2-PB2-RO2*QO2*abs(QO2))/(LO*B02)

// Not Milne integration :(
QS=QS+DELT*QSprime
QC1=QC1+DELT*QC1prime
QC2=QC2+DELT*QC2prime
QV1I=QV1I+DELT*QV1DOT
V=V+DELT*Vprime
QV2=QV2+DELT*QV2prime
QO1=QO1+DELT*QO1prime
QO2=QO2+DELT*QO2prime

// SWITCH CRITERION

LSP=2*SB
if ~(LSP < SPL) then
    RT=1
    disp("LSP >= SPL",TIME,V,THETA,R,QC1,QC2,QV1,QS)
end

if (LSP < -SPL) then
    LSP = -SPL
end
