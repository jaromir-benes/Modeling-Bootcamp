%% BCRG - OGR: Mission d’assistance technique en analyse 
%% et prévision macroéconomiques 
% a1_model_data: Procédér la base de données
%% Ménage
clear all
close all
clc

% Créer une dossier pour les résultats
resDir  = 'results\a1_model_data';
[~,~,~] = mkdir(resDir);

% Ajouter la dossier des données au Search PAth
addpath('donnees');

%% Charger les données
disp('*** Chargez les données...')
dm = dbload('db_monthly.csv','delimiter',';');
dy = dbload('db_yearly.csv','delimiter',';');
dx = dbload('db_external.csv','delimiter',';');

% Base de données pour le modele
dobs.obs_l_y        = 100*log(convert(dy.pib_reel,'q'));
dobs.obs_l_ym       = 100*log(convert(dy.GDP_sec,'q'));
dobs.obs_l_yxm      = 100*log(convert(sum([dy.GDP_prim,dy.GDP_tert,dy.GDP_DTI],2),'q'));
dobs.obs_dl_cpi     = diff(100*log(convert(x12(dm.cpi),'q')),-1)*4;
dobs.obs_l_s        = 0.5*100*log(convert(dm.usd_gnf_p,'q')) + 0.5*100*log(convert(dm.usd_gnf,'q'));
dobs.obs_l_cpif     = 100*log(dx.cpi_us);
dobs.obs_i_f        = 100*log(1+dx.i_fed_us/100);
dobs.obs_l_y_gap_f  = dx.l_y_us_gap;
dobs.obs_rf_tnd     = dx.r_fed_us_tnd;

%% Définir les intervalles de la tracage (? utiliser dans tous les codes suivants)
firstHist = qq(2009,1);
lastHist  = qqtoday()-1;
firstFore = lastHist+1;
lastFore  = firstFore+5*4;

% Définissez l'interval de filtrage. Nous spécifions l'interval que nous voulons exécuter le filtre de Kalman, 
rngFilt     = firstHist:lastHist;
rngFcast    = firstFore:lastFore;
plot_hlight = firstFore:lastFore;

% Enregistrer les résultats
save([resDir filesep 'observed_db.mat'],'dobs','firstHist','lastHist',...
                                                                'firstFore','lastFore',...
                                                           'rngFilt','rngFcast');
disp('*** Fait!')