exec("model_defaults.sce", -1)

// CONTRL
FINTIM=4E-2

// PARAM - geometry
D=0.5
B0=2E-3
BC=1
ALPH=.197
XV1=9
LGTHC=10
AREAC=2
LGTHS=5
AREAS=5
LGTHV=9
AREAV=2
SPL=10
LGTHR=15

// PARAM - supply
// P0=82
P0=20
L=0
CS=0.8

// PARAM - control
PRE1=1
PRE2=1
POST1=0
POST2=0
P1=0.5
P2=0
TRISE=1.5E-2

exec("simulate_model.sce", -1)
