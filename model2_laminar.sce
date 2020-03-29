exec("model_defaults.sce", -1)

// CONTRL
FINTIM=4E-1

exec("model2_geometry.sce", -1)

// PARAM - supply
P0=3.3333E-2
L=1
CS=0.8

// PARAM - control
PRE1=1
PRE2=1
POST1=0
POST2=1
P1=0.05
P2=0
TRISE=30E-3

exec("simulate_model.sce", -1)
