exec("model_defaults.sce", -1)

// CONTRL
FINTIM=0.75E-2

// PARAM - geometry
D=0.905
B0=0.5E-3
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
P0=3.5/.174 // An output pressure of 3.5 kPa with only .174 times the input reaching the output
L=0
CS=0.80 // Based on Figure 14 for high Reynold's number

// PARAM - control
PRE1=1
PRE2=1
POST1=0
POST2=0
P1=0.185
P2=0
TRISE=1.5E-3

exec("simulate_model.sce", -1)
