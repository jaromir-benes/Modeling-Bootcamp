%% BCRG - OGR: Mission d’assistance technique en analyse 
%% et prevision macroeconomiques 
% b1_analyze_model: Fonctions de réponse impulsionnelle et décompositions de variance

%% Housekeeping
clear all
close all
clc

% Creating folder for results
resDir = 'results/b1_analyze_model';
[~,~,~] = mkdir(resDir);

addpath('utils');

% Read and solve model
m = model('gn.mod','linear',true);
m = solve(m);
m = sstate(m);

%% Model File Report
disp(' ');
disp('*** Creation du rapport du modele ...');

x = report.new();

x.modelfile('Model FPAS de la Republique de Guinee','gn.mod',m); % |m| - model solved for sstates
x.pagebreak();

x.publish([resDir filesep 'model_report.pdf'],'maketitle',false,'papersize','a4paper','display',false);

%% Impulse response functions
disp(' ');
disp('*** Creation d''un rapport FRI...');
% Produce reports
x = report.new('Rapport FRI','visible',false);

%shocklist = {'shock_l_y_gap','shock_dl_cpi','shock_r_gap','shock_r_tnd'};
shocklist = get(m,'enames');

for i = 1:length(shocklist)
    
% Create a 'blank' database
% 1. Steady-state database
d1 = sstatedb(m,0);
d1.(shocklist{i})(1) = 1;
s1 = simulate(m,d1,0:20);                           % Simulation with anticipated shock
s2 = simulate(m,d1,0:20, 'anticipate', false);      % Simulation with surprise shock

leg = {'Anticipé','Surpris'};

x.figure(get(d1.(shocklist{i}),'comment'),'subplot',[2,2],'range',0:20,'LineWidth',3,'legend',true);
    x.graph('Ecart de production','grid',true);
        x.series(leg, [s1.l_y_gap s2.l_y_gap]);
    x.graph('IHPC Inflation (%, croissance annuel)','grid',true,'legend',false);
        x.series('', [s1.dl_cpi-s1.dl_cpi_tar s2.dl_cpi-s2.dl_cpi_tar]);        
    x.graph('Ecart de TIR Gap','grid',true,'legend',false);
        x.series('', [s1.r_gap s2.r_gap]);
    x.graph('Depreciation du TCN (%, taux annuel)','grid',true,'legend',false);
        x.series('', [s1.dl_s s2.dl_s]);        

end

x.publish([resDir filesep 'report_irf.pdf']);

%% Variance Decomposition
disp(' ');
disp('*** Creation d''un rapport de la decomposition de la variance...');

% Define style of figures
stybar = struct();
stybar.legend.location = 'SouthOutside';
stybar.legend.orientation = 'horizontal';
stybar.legend.box = 'off';
stybar.legend.fontsize = 9;
stybar.axes.box = 'off';

nper = 20; % number of periods
nc = 7; % number of contribution bars
desc = get(m,'descript');
names = get(m,'names');
for iN = 1:numel(names)
    name = names{iN};
    if isempty(desc.(name))
        desc.(name) = name;
    end
end

[X,Y,List,dbabs,dbrel] = fevd(m,qq(2016,01):qq(2021,01));

%% FEVD report
xx = report.new;
vList = {'i','l_s','dl_s','dl_cpi','l_y_gap'};

% FEVD report
xx = report.new;

for i = 1:length(vList)
    var = vList{i};
    if isfield(desc,var)
        dsc = [desc.(var) ' [' var ']'];
    else
        dsc = ['[' var ']'];
    end
    fh = vardecomp_process_one_variable(X, var, nc);
    %- add to the report
%     xx.userfigure({dsc, ['--- HIST STD = ' num2str(std(dbf.(var){hrng})) ' ---']}, fh);
    xx.userfigure(dsc, fh);
end

xx.publish([resDir filesep 'report_fevd.pdf'],'maketitle',false,'papersize','a4paper','display',false);

disp(' ');
disp('*** Done!');

