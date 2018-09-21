%% Read Different Versions of Phillips Curve Equations


%% Clear Workspace

close all
clear
clc


%% Read Backward-Looking Phillips Curve

mb = model('bwl_phillips.model', 'linear=', true);

mb.beta1 = 0.8; % Can we set beta1=1 or >1?
mb.beta3 = 0.1;

mb = solve(mb); % Find first-order solution matrices
mb = sstate(mb); % 

%% Forward-Looking

mf = model('fwl_phillips.model', 'linear=', true);

mf.beta2 = 0.8; % Can we set beta2=1 or >1?
mf.beta3 = 0.1;

mf = solve(mf); % Find first-order solution matrices
mf = sstate(mf);

%% Backward-Forward

m = model('bwl_fwl_phillips.model', 'linear=', true);

m.beta1 = 0.6; % Can we set beta1=beta2=0.5? beta1+beta2>1?
m.beta2 = 0.4;
m.beta3 = 0.1;

m.alpha1 = 0.5;
m.tar = 0;

m = solve(m);
m = sstate(m);

%% Save Model Objects to MAT File

save mat/read_models.mat mb mf m


%% SHow All Variables and Objects in Workspace

whos

