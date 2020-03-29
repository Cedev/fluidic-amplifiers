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
internal_pressures=[]
lengths=[]
while TIME<FINTIM && RT==0 do
    /*
    if TIME > (0.0207600 - DELT*3.5) && TIME <= 0.0207600 then
        disp("Checking for NaN at time", TIME)
        check_nan()
    end
    */
    exec("amplifier_simulation.sce", -1)
    times=cat(1,times,[TIME])
    pressures=cat(1,pressures,[PC1,PC2,POUT1,POUT2,BETA,PDOUT1,PDOUT2])
    flows=cat(1,flows,[QS, QC1, QC2, QO1, QO2, QV1, QV2])
    internal_pressures=cat(1,internal_pressures,[PSY,P1B,P2B,PAV,PLEVEL,PD1,PD2])
    lengths=cat(1,lengths,[BETA,XAP,LSP])
    TIME=TIME+DELT
end
scf(0)
clf()
plot2d(times, pressures)
legend("PC1", "PC2", "POUT1", "POUT2", "BETA", "PDOUT1", "PDOUT2", -1)
scf(1)
clf()
plot2d(times, flows)
legend("QS", "QC1", "QC2", "QO1", "QO2", "QV1", "QV2", -1)
scf(2)
clf()
plot2d(times, internal_pressures)
legend("PSY", "P1B", "P2B", "PAV", "PLEVEL", "PD1", "PD2", -1)
scf(3)
clf()
plot2d(times, lengths)
legend("BETA", "XAP", "LSP")
