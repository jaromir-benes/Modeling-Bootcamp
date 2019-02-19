%% BCRG - OGR: Mission d’assistance technique en analyse 
%% et prévision macroéconomiques 
% a3_run_filter: Filtration

%% Ménage
clear all
close all 
clc

% Créer une dossier pour les résultats
resDir = 'results/a3_run_filter';
[a,b,c] = mkdir(resDir);

% Ajouter la dossier fonctions auxilier au Chemin de Recherche
addpath('utils');

%% Charger les entrées
% Charger le modele
tmp = load('results/a2_read_model/model.mat');
m = tmp.m;

% Charger les données observés
tmp = load('results/a1_model_data/observed_db.mat');
dobs = tmp.dobs;

% Charger les plages
tmp = load('results/a1_model_data/observed_db.mat');
firstHist   = tmp.firstHist;
lastHist    = tmp.lastHist;
firstFore   = tmp.firstFore;
lastFore    = tmp.lastFore;
rngFilt     = tmp.rngFilt;
rngFcast    = tmp.rngFcast;
plot_hlight = rngFcast;

% %% 'Tunes' historique
% disp('*** Fixer les ''tunes''... ')
% 
% dobs.obs_dl_y_tnd = tseries();
% dobs.obs_dl_y_tnd(qq(2010,1)) = 2.5;
% dobs.obs_dl_y_tnd(qq(2015,4)) = 3.5;

%% Filtration
fprintf('\n *** Exécution de Kalman-filtre ... \n\n');

% Commencer le filtrage
% Nous stockons les résultats du filtrage dans une nouvelle base de données nommée 'dsm'.
% Remarque que la base de données est la deuxi?me sortie de la fonction 'filter'.
[mfilt,dsm] = filter(m,dobs,rngFilt);

%% Exécuter la décomposition de choc

% Variables ? tracer
decomp.shock_decomp_variables = {'dl_y_tnd','l_y_gap','dl_cpi','i','r_gap'};

% Nom des groupes des chocs                         
decomp.shock_decomp_groups    = {...
  'Demand',...
  'Offre',...
  'Pol.Mon.',...
  'Tendance'};

% Classification des chocs 
decomp.shock_decomp_shocks = {{'shock_l_ym_gap','shock_l_yxm_gap'}, ...
                      {'shock_dl_cpi'}, ...
                      {'shock_dl_s','shock_dl_cpi_tar'}, ...
                      {'shock_dl_z_tnd','shock_dl_ym_tnd','shock_dl_yxm_tnd'}};

decomp.shock_decomp_group_rest = {'Autre'};

% Simuler des contributions
decomp.simulate_db = simulate(m,dsm.mean,rngFilt,'contributions',true,'anticipate',false);

% Créer des groupes pour la décomposition des chocs
g = grouping(m,'Shocks');
for j = 1:length(decomp.shock_decomp_shocks)
  g = addgroup(g, decomp.shock_decomp_groups{j}, decomp.shock_decomp_shocks{j});
end
decomp.shock_contrib_db = eval(g,decomp.simulate_db);

%% Save results
save([resDir filesep 'filter_data.mat'],'-struct','dsm');
save([resDir filesep 'filter_shock_decomp.mat'],'-struct','decomp');
save([resDir filesep 'filter_model.mat'],'mfilt');
save([resDir filesep 'shock_decomp.mat'],'decomp')

%--- enregistrer les moyens de filtration séparément dans un fichier csv
dbsave(dsm.mean,[resDir filesep 'filter_data.csv']);

%% rapporter les contributions de choc ? la probabilité de données
stds = get(m,'std');
dbstd = dbbatch(stds,'$0','tseries(rngFilt,stds.$0)');
report_likelihood_contrib(dsm.mean,dbstd,rngFilt,dbnames(stds));

%% Estimer l'incertitude des chocs
% Assigner l'incertitude estimée de l'échantillon au mod?le et comparer
% d'étalonnage initial des STD, estimation KF des STD et estimation de
% l'échantillon des STD
shcks = get(m,'enames');

% Estimation
se = struct;
for shk = shcks
  se.(['std_',shk{:}]) = std(dsm.mean.(shk{:})(firstHist:lastHist));
end

% Afficher les incertitudes calibrées et estimées (KF & échantillon)
sc = get(m,'std');
sk = get(mfilt,'std');

fprintf('\n\n%26s\t Calibré(sc)\t Filtr. Kalman (sk)\t Estimé(se)\n', 'Nom du choc');
for shk = strcat('std_', shcks)
   fprintf('%26s\t %3.2f\t\t\t %3.2f\t\t\t\t %3.2f\n', shk{:},...
      sc.(shk{:})(:), sk.(shk{:})(:), se.(shk{:})(:));
end

disp(' ');
disp('*** Fait!');
disp(' ');