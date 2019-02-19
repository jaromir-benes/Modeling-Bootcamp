%% BCRG - OGR: Mission d’assistance technique en analyse 
%% et prévision macroéconomiques 
% a2_read_model: Lire le modele

%% Ménage
clear all
close all
clc

% Créer une dossier pour les résultats
resDir = 'results\a2_read_model';
[~,~,~] = mkdir(resDir);

% Ajouter la dossier des données au Chemin de Recherche
addpath('donnees');


%% Lire le modele
% Le command 'model' lit le fichier texte 'model.mod' (qui contient les équations du mod?le), 
% attribue les param?tres et valeurs de tendance prédéfinis  
% et transforme le mod?le pour l'alg?bre matricielle. Le mod?le transformé est écrit dans l'objet 'm'.
m = model('gn.mod','linear',true);

% Le command 'solve' prend le mod?le sauvegardé dans l'objet 'm' et résout le mod?le
% pour sa forme réduite (en utilisant l'algorithme Blanchard-Kahn). La forme réduite est
% écrit dans l'objet 'm'
m = solve(m);

% Command 'sstate' prend le mod?le résolu dans l'objet 'm', calcule l'état
% d'équilibre du mod?le et écrit tout dans l'objet 'm'. 
% Tapez 'mss' dans la fen?tre de commande du Matlab pour afficher les valeurs de l'état stationnaire.
m = sstate(m);
mss = get(m,'sstate');

% Vérifier l'état d'équilibre du mod?le
[flag resids listeq] = chksstate(m);
if flag == 0
    err = sprintf('Le mod?le n''a pas un état stable approprié pour les équations suivantes.:\n %s\n',listeq{:});
    error(err);
end

fprintf('Parfait, votre modele fonctionne! \n')

% Enregistrer le modele
save([resDir filesep 'model.mat'],'m');

