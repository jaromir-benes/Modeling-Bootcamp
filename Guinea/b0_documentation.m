%% BCRG - OGR: Mission d’assistance technique en analyse 
%% et prevision macroeconomiques
%% 2018 Aout-Septembre
% gn_init_infrastructure: expliquer la structure du dossier FPAS

clc; clearvars; close all;
disp('');
disp('Informations succinctes sur le modele GN FPAS MPT');

disp(' ');  
disp('Veuillez patienter, le Guide FPAS est en cours de publication ...');
x = report.new('Guide d''utilisation des modeles FPAS au Guinee', 'orientation=', 'portrait');
packages = {'fancyhdr', 'amsmath', 'textcomp','ragged2e','setspace','inputenc'};
auth = '\bf Georges Moln\''{a}r, Barna Szab\''{o} \\ \\ Projet de FPAS pour la Banque Central de la R\''{e}publique de Guin\''{e}e';
x.pagebreak();
for n = 1:7
    x.tex('', fileread(['utils/documentation/chapter' num2str(n) '.tex']));
    x.pagebreak();
end
x.publish('FPAS_GN_guide.pdf','display',false,'maketitle',true, ...
    'package=',packages,'paperSize=','a4paper','author=',auth, ...
    'timeStamp=','2018');
   