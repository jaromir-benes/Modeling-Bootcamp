%% Plot Some Data


%% Clear Workspace

close all
clear
clc


%% Load Databanks

load mat/read_data.mat dm dq


%% Compare SU and SA



%% 

dq.l_gdp = 100*log(dq.gdp);

[dq.l_gdp_tnd, dq.l_gdp_gap] = hpf(dq.l_gdp); % Lambda=1600
[dq.l_gdp_tnd1, dq.l_gdp_gap1] = hpf(dq.l_gdp, 'Lambda=', 100);
[dq.l_gdp_tnd2, dq.l_gdp_gap2] = hpf(dq.l_gdp, 'Lambda=', 5000);

range = qq(1970,1):qq(2018,4);
figure
subplot(2, 1, 1);
plot(range, [dq.l_gdp_tnd, dq.l_gdp_tnd1, dq.l_gdp_tnd2, dq.l_gdp]);
subplot(2, 1, 2);
plot(range, [dq.l_gdp_gap, dq.l_gdp_gap1, dq.l_gdp_gap2]);
visual.zeroline( );


