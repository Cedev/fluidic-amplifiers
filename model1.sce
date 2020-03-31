exec("model_defaults.sce", -1)

// PARAM - geometry
D=0.905
B0=2.1E-3
BC=1
ALPH=.20944
XV1=8.640
LGTHC=10
AREAC=2
LGTHS=15
AREAS=3
LGTHV=10
AREAV=1.95
SPL=10
LGTHR=27.75

// PARAM - supply
P0=10
L=0
CS=0.85

// PARAM - control
PRE1=1
PRE2=1
POST1=0
POST2=1
P1=0.1
P2=0
TRISE=1.5E-3

exec("simulate_model.sce", -1)
