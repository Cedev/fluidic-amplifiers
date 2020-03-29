exec("model_defaults.sce", -1)

// CONTRL
FINTIM=4E-2

exec("model2_geometry.sce", -1)
LGTHC=2

// PARAM - supply
P0=7.5
L=0
CS=0.85

// PARAM - control
PRE1=1
PRE2=1
POST1=0
POST2=1
P1=0.3
P2=0
TRISE=1E-3

exec("simulate_model.sce", -1)
