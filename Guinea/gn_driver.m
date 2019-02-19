%% BCRG - OGR: Mission d’assistance technique en analyse 
%% et prévision macroéconomiques 
% gn_driver: driver pour executer tous les codes en une clique

%% Ménage
clear all
close all 
clc

%% Executer les codes pour la prevision
a0_screening_report;    % Préparer un rapport pour les faits stylisé
a1_model_data;          % Lire la base de données, transformes les données brut en variables du modele
a2_read_model;          % Lire et résoudre le modele
a3_run_filter;          % Exécuter le filtre du Kalman
a4_report_filter;       % Prépare un rapport sur les résultats de la filtration

% Codes auxilliaire pour la calibration
b1_analyze_model;       % Préparer des rapports pour analyser le modele: FRI, decomposition de la variance
b2_run_histsim;         % Preparer un rapport pour examiner la performance historique du modele