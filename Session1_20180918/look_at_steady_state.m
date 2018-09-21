%% Examine Steady State of Model Variables

close all
clear
clc

load mat/read_models.mat mb mf m

% Get steady-state Values for all variables
get(m, 'Steady')

% Query stationarity of all variables
get(m, 'IsStationary')

