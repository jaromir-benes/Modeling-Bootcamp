
close all
clear
clc

m = Model( 'ce0.model', ...
           'Linear=', true, ...
           'SaveAs=', 'ce0_preparsed.model' );

m.alpha1 = 0.7;
m.alpha2 = 0.1;
m.beta1 = 0.6;
m.beta2 = 0.1;
m.gamma1 = 0.7;
m.gamma2 = 2.5;
m.ss_dl_cpi = 2;
m.ss_ri = 1;

m = solve(m);
m = sstate(m);

table(m, {'SteadyLevel', 'Description'})

disp(m)


