

close all
clear
clc

load results/a2_read_model/model.mat m

m.f1 = 1;
m = solve(m);
chksstate(m);

d = sstatedb(m, 1:20);
d.shock_dl_cpi_tar(1) = -1;
s = simulate( m, d, 1:20, ...
              'AppendPresample=', true );


dbplot( s, 0:20, ...
        {'dl_cpi', 'i', 'l_s', 'dl_s', 'l_y_gap', ...
         'cumsum(l_y_gap)/4' }, ...
        'Tight=', true );

