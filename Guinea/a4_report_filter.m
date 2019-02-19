%% BCRG - OGR: Mission d’assistance technique en analyse 
%% et prevision macroeconomiques 
% a4_report_filter: Filtration

%% Menage
clear all
close all 
clc

% Creer une dossier pour les resultats
resDir = 'results/a4_report_filter';
[a,b,c] = mkdir(resDir);

%% Charger les donnees
% Charger les donnees filtre
tmp = load('results/a3_run_filter/filter_data.mat');
dsm = tmp;

% Charger le modele
tmp = load('results/a3_run_filter/filter_model.mat');
m = tmp.mfilt;

% Charger le decomposition des chocs
tmp = load('results/a3_run_filter/shock_decomp.mat');
decomp = tmp.decomp;

% Charger les plages
tmp = load('results/a1_model_data/observed_db.mat');
firstHist   = tmp.firstHist;
lastHist    = tmp.lastHist;
firstFore   = tmp.firstFore;
lastFore    = tmp.lastFore;
rngFilt     = tmp.rngFilt;
rngFcast    = tmp.rngFcast;
plot_hlight = rngFcast;

disp(' ');
disp('*** Preparation du rapport de filtrage ...' );
disp(' ');

plot_rng = rngFilt;

%% Define figure style
sty = struct();
sty.line.linewidth      = 2;
sty.line.linestyle      = {'-';'--'};
sty.axes.box            = 'off';
sty.legend.location     ='Southoutside';
sty.legend.orientation  = 'Horizontal';
sty.zeroline = 'true';

%% Define table options
tblRng  = lastHist-8:lastHist;
tblRng_annual = dat2ypf(firstHist):dat2ypf(lastFore);
histRng = firstHist:lastHist;
tblOptions={'range',tblRng,'vlineAfter',histRng(end),'decimal',1,...
            'dateformat','YYFP',...
            'long',true,...
            'footnote','',...
            'longfoot','---continued',...
            'longfootposition','right',...
            'typeface','\color{black}',...
                      'captiontypeface','\LARGE\bfseries\color{red}'};
                  
%% Start reporting
x = report.new('Rapport de filtration');

% Definir des fonctions supplementaires pour gerer les donnees
delog = @(x) 100*(exp(x/100)-1);
delog4 = @(x) 400*(exp(x/400)-1);
dbev = @(str) dbeval(dsm,str);

% Obtenir le nom de tous les observables
obsnms =  get(m,'yList');
% Obtenir le nom de tous les chocs
enms = get(m,'enames');

% Variables observables du graphique
    % Definissent combien de chiffres sur une page
    pgs =ceil(length(obsnms)/4);
    for j = 1:pgs
        x.figure(['Donnees Filtres (page ',num2str(j),' de ',num2str(pgs),')'],'subplot',[2,2],'range',rngFilt,'dateformat','YY:P','style',sty,'figurescale',0.85);
        for ii = 1:min([4,length(obsnms)-(j-1)*4])
            tser = dsm.mean.(obsnms{(j-1)*4+ii});
            rstr = get(tser,'comment');
            x.graph(rstr,'zeroline',true,'style',sty);
%             x.highlight('',plot_hlight,'hPosition','center');
            x.series('',tser);
        end       
    end   

% Rename database for simplifying reporting
db = dsm.mean;

% Vue d'ensemble
x.figure('Vue d''ensemble I.','subplot',[2 2],'range',plot_rng);  
      x.graph('PIB reel (100*log, GNF 20??)','style',sty, 'legend', true); %1st subplot
            x.series('Niveau', db.l_y);
            x.series('Tendance', db.l_y_tnd);
            x.highlight('', plot_hlight);
      x.graph('Nominal Interest Rate (%,p.a.)', 'style', sty, 'legend', true);
            x.series('Niveau', db.i);
            x.series('Tendance', db.i_neutral);
            x.highlight('', plot_hlight);
      x.graph('Inflation Annuel (%)', 'style', sty, 'legend', true);
            x.series('Niveau', db.dl_cpi);
            x.series('Cible', db.dl_cpi_tar);
            x.highlight('', plot_hlight);      
      x.graph('Ecart de production', 'style', sty,'zeroline',true);
            x.series('', db.l_y_gap);
            x.highlight('', plot_hlight);
            
x.figure('Vue d''ensemble II.','subplot',[2 2],'range',plot_rng);  
      x.graph('PIB miniere reel (100*log, GNF 20??)','style',sty, 'legend', true); %1st subplot
            x.series('Niveau', db.l_ym);
            x.series('Tendance', db.l_ym_tnd);
            x.highlight('', plot_hlight);  
      x.graph('Ecart de production miniere', 'style', sty,'zeroline',true);
            x.series('', db.l_ym_gap);
            x.highlight('', plot_hlight);
      x.graph('PIB non-miniere reel (100*log, GNF 20??)','style',sty, 'legend', true); %1st subplot
            x.series('Niveau', db.l_yxm);
            x.series('Tendance', db.l_yxm_tnd);
            x.highlight('', plot_hlight);  
      x.graph('Ecart de production non-miniere', 'style', sty,'zeroline',true);
            x.series('', db.l_yxm_gap);
            x.highlight('', plot_hlight);               
            
x.figure('Vue d''ensemble III.','subplot',[2 2],'range',plot_rng);  
      x.graph('Depreciation du Taux de Change Reel', 'style', sty, 'legend', true);
            x.series('Niveau', db.dl_z);
            x.series('Tendance', db.dl_z_tnd);
            x.highlight('', plot_hlight);
      x.graph('Ecart du TCR', 'style', sty, 'legend', true);
            x.series('Niveau', db.l_z_tnd);
            x.highlight('', plot_hlight);            
    x.graph('Taux d''Interet Reel', 'style', sty, 'legend', true);
            x.series('Niveau', db.r);
            x.series('Tendance', db.r_tnd);
            x.highlight('', plot_hlight);
      x.graph('Ecart de TIR', 'style', sty, 'legend', false);
            x.series('Ecart de TIR', db.r_gap);
            x.highlight('', plot_hlight);

% Tendances á long terme
x.figure('Tendances a long terme I. - PIB','subplot',[2 2],'range',plot_rng);  
      x.graph('PIB potentiel (100*log)','style',sty, 'legend', true); %1st subplot
            x.series('Niveau', db.l_y);
            x.series('Tendance', db.l_y_tnd);
            x.highlight('', plot_hlight);
      x.graph('Croissance du PIB réel (%, trimestriel)', 'style', sty, 'legend', true);
             x.series('Niveau',db.dl_y);
             x.series('Tendance',db.dl_y_tnd);
            x.highlight('', plot_hlight);
      x.graph('Ecart de PIB (%)', 'style', sty, 'legend', true);
            x.series('',[db.s1*db.l_ym_gap, (1-db.s1)*db.l_yxm_gap],...
            'legend',{'Miniere','Non-miniere'},'plotfunc',@conbar);
            x.series('', db.l_y_gap);
            x.highlight('', plot_hlight);      
%       x.graph('Croissance du PIB Potentiel (%, glissement annuel)', 'style', sty,'legend',true);
%             x.series('',[db.e1*db.dl_y_tnd{-1}, (1-db.e1)*db.ss_dl_y_tnd, db.shock_dl_y_tnd],...
%                 'legend',{'Persistance','Etat d''equilibre','Choc'},'plotfunc',@conbar);
%             x.series('', db.dl_y_tnd);
%             x.highlight('', plot_hlight);

x.figure('Tendances a long terme II. - PIB non-miniere','subplot',[2 2],'range',plot_rng);  
      x.graph('PIB potentiel non-miniere (100*log)','style',sty, 'legend', true); %1st subplot
            x.series('Niveau', db.l_yxm);
            x.series('Tendance', db.l_yxm_tnd);
            x.highlight('', plot_hlight);
      x.graph('Croissance du PIB non-miniere réel (%, trimestriel)', 'style', sty, 'legend', true);
             x.series('Niveau',db.dl_yxm);
             x.series('Tendance',db.dl_yxm_tnd);
            x.highlight('', plot_hlight);
      x.graph('Ecart de PIB non-miniere (%)', 'style', sty, 'legend', false);
            x.series('Niveau', db.l_yxm_gap);
            x.highlight('', plot_hlight);      
      x.graph('Croissance du PIB non-miniere Potentiel (%, glissement annuel)', 'style', sty,'legend',true);
            x.series('',[db.exm1*db.dl_yxm_tnd{-1}, (1-db.exm1)*db.ss_dl_yxm_tnd, db.shock_dl_yxm_tnd],...
                'legend',{'Persistance','Etat d''equilibre','Choc'},'plotfunc',@conbar);
            x.series('', db.dl_yxm_tnd);
            x.highlight('', plot_hlight); 
            
x.figure('Tendances a long terme III. - PIB miniere','subplot',[2 2],'range',plot_rng);  
      x.graph('PIB potentiel (100*log)','style',sty, 'legend', true); %1st subplot
            x.series('Niveau', db.l_ym);
            x.series('Tendance', db.l_ym_tnd);
            x.highlight('', plot_hlight);
      x.graph('Croissance du PIB miniere réel (%, trimestriel)', 'style', sty, 'legend', true);
             x.series('Niveau',db.dl_ym);
             x.series('Tendance',db.dl_ym_tnd);
            x.highlight('', plot_hlight);
      x.graph('Ecart de PIB miniere (%)', 'style', sty, 'legend', false);
            x.series('Niveau', db.l_ym_gap);
            x.highlight('', plot_hlight);      
      x.graph('Croissance du PIB Miniere Potentiel (%, glissement annuel)', 'style', sty,'legend',true);
            x.series('',[db.em1*db.dl_ym_tnd{-1}, (1-db.em1)*db.ss_dl_ym_tnd, db.shock_dl_ym_tnd],...
                'legend',{'Persistance','Etat d''equilibre','Choc'},'plotfunc',@conbar);
            x.series('', db.dl_ym_tnd);
            x.highlight('', plot_hlight);           

x.figure('Tendances a long terme IV. - taux de change reel','subplot',[2 2],'range',plot_rng);  
      x.graph('Taux d''echange reel (100*log)','style',sty, 'legend', true); %1st subplot
            x.series('Niveau', db.l_z);
            x.series('Tendance', db.l_z_tnd);
            x.highlight('', plot_hlight);
      x.graph('TCER Depreciation (%, en glissement annuel)', 'style', sty, 'legend', true);
             x.series('',[db.dl_s -db.dl_cpi db.dl_cpif],...
            'legend',{'Depréciation nom.','IHPC domestique','IHPC etr.'},'plotfunc',@conbar);
            x.series('Niveau', db.dl_z);
            x.highlight('', plot_hlight);
      x.graph('Ecart de TCER (%)', 'style', sty, 'legend', false);
            x.series('Niveau', db.l_z_gap);
            x.highlight('', plot_hlight);      
      x.graph('Depreciation du tendance du TCER (%, glissement annuel)', 'style', sty,'legend',true);
            x.series('',[db.d1*db.dl_z_tnd{-1}, (1-db.d1)*db.ss_dl_z_tnd, db.shock_dl_z_tnd],...
                'legend',{'Persistance','Etat d''equilibre','Choc'},'plotfunc',@conbar);
            x.series('', db.dl_z_tnd);
            x.highlight('', plot_hlight);
                        
x.figure('Tendances a long terme V. - Taux d''interet reel','subplot',[2 2],'range',plot_rng);  
      x.graph('Taux d''interet reel (100*log)','style',sty, 'legend', true); %1st subplot
            x.series('Niveau', db.r);
            x.series('Tendance', db.r_tnd);
            x.highlight('', plot_hlight);
      x.graph('Prim de risque (%)', 'style', sty, 'legend', true);
            x.series('',[db.p1*db.prem{-1}, (1-db.p1)*db.ss_prem, db.shock_prem],...
                'legend',{'Persistance','Etat d''equilibre','Choc'},'plotfunc',@conbar);
             x.series('',db.prem);
            x.highlight('', plot_hlight);
      x.graph('Ecart du TIR (%)', 'style', sty, 'legend', false);
            x.series('Niveau', db.r_gap);
            x.highlight('', plot_hlight);      
      x.graph('Taux d''interet nominal (%)', 'style', sty,'legend',true);
            x.series('Niveau', db.i);
            x.series('Taux neutre', db.i_neutral);
            x.highlight('', plot_hlight);
            
% Decomposition des equations clés            
x.figure('L''ecart de production non-miniere','subplot',[2 1],'range',plot_rng);  
      x.graph('L''ecart de production (%)','style',sty, 'legend', true); %1st subplot
            x.series('Filtre', db.l_yxm_gap);
            x.series('Sans choc', db.l_yxm_gap - db.shock_l_yxm_gap);
            x.highlight('', plot_hlight);
      x.graph('Decomposition de l''ecart de production non-miniere (pp)', 'style', sty, 'legend', true);
            x.series('',[db.a1*db.l_yxm_gap{-1}, db.a2*db.l_yxm_gap{+1}, -db.a3*db.rmci{-1},...
                db.a4*db.l_y_gap_f,db.a5*db.l_ym_gap, db.shock_l_yxm_gap],...
            'legend',{'Persistance','Anticipation','RMCI','Demand etr.','Ecart miniere','Choc'},'plotfunc',@conbar);
            x.series('Niveau', db.l_yxm_gap);
            x.highlight('', plot_hlight);          

x.figure('L''ecart de production miniere','subplot',[2 1],'range',plot_rng);  
      x.graph('L''ecart de production (%)','style',sty, 'legend', true); %1st subplot
            x.series('Filtre', db.l_ym_gap);
            x.series('Sans choc', db.l_ym_gap - db.shock_l_ym_gap);
            x.highlight('', plot_hlight);
      x.graph('Decomposition de l''ecart de production miniere (pp)', 'style', sty, 'legend', true);
            x.series('',[db.am1*db.l_ym_gap{-1}, db.am2*db.l_y_gap_f db.shock_l_ym_gap],...
            'legend',{'Persistance','Demand etr.','Choc'},'plotfunc',@conbar);
            x.series('Niveau', db.l_ym_gap);
            x.highlight('', plot_hlight);                 
            
x.figure('Inflation','subplot',[2 1],'range',plot_rng);  
      x.graph('Inflation Annuel (%)','style',sty, 'legend', true); %1st subplot
            x.series('Filtre', db.dl_cpi);
            x.series('Sans choc', db.dl_cpi - db.shock_dl_cpi);
            x.highlight('', plot_hlight);
      x.graph('Decomposition de l''Inflation Annuel', 'style', sty, 'legend', true);
            x.series('',[db.b1*db.dl_cpi{-1},(1-db.b1-db.b2)*db.e_dl_cpi,...
            db.b2*(db.dl_cpim - db.dl_z_tnd), db.b3*db.rmc, db.shock_dl_cpi],...
            'legend',{'Persistance','Anticipations','Infl. Importé','RMC','Choc'},'plotfunc',@conbar);
            x.series('Niveau', db.dl_cpi);
            x.highlight('', plot_hlight); 
          
x.figure('Politique Monetaire','subplot',[2 1],'range',plot_rng);  
      x.graph('Taux d''interet nominal (percent)','style',sty, 'legend', true); %1st subplot
            x.series('Filtre', db.i);
            x.highlight('', plot_hlight);
      x.graph('Decomposition du Taux d''interet nominal (pp)', 'style', sty, 'legend', true);
            x.series('',[db.c1*db.i{-1} , (1-db.c1)*(db.e_l_s - db.l_s)*4, ...
                (1-db.c1)*db.i_f, (1-db.c1)*db.prem],... 
            'legend',{'Persistance','Depreciation anticipé','TI etranger','Prim'},'plotfunc',@conbar);
            x.series('Niveau', db.i);
            x.highlight('', plot_hlight); 
            
 x.figure('Politique Monetaire','subplot',[2 1],'range',plot_rng);  
      x.graph('Taux d''interet nominal (percent)','style',sty, 'legend', true); %1st subplot
            x.series('Filtre', db.i);
            x.highlight('', plot_hlight);
      x.graph('Decomposition du Taux d''interet nominal (pp)', 'style', sty, 'legend', true);
            x.series('',[db.c1*db.i{-1} , (1-db.c1)*(db.e_l_s - db.l_s)*4, ...
                (1-db.c1)*db.i_f, (1-db.c1)*db.prem],... 
            'legend',{'Persistance','Depreciation anticipé','TI etranger','Prim'},'plotfunc',@conbar);
            x.series('Niveau', db.i);
            x.highlight('', plot_hlight);            

x.figure('Indice des conditions monetaires reelles','subplot',[1 1],'range',plot_rng);
      x.graph('Decopmosition de l''indice des conditions monetaires reelles (+:restrictif, -:accommodant)','style',sty, 'legend', true); %1st subplot
            x.series('',[db.n1*db.r_gap -(1-db.n1)*db.l_z_gap],... 
            'legend',{'Ecart de Taux d''Interet Reel','Ecart de Taux de Change Reel'},'plotfunc',@conbar);
            x.series('Niveau', db.rmci);
            
% Des chocs graphiques
    pgs = ceil(length(enms)/4); % definissent combien de chiffres sur une page
    for j = 1:pgs
        x.figure(['Chocs (page ',num2str(j),' de ',num2str(pgs),')'],'subplot',[2,2],'range',rngFilt,'dateformat','YY:P','style',sty,'figurescale',0.85);
        for ii = 1:min([4,length(enms)-(j-1)*4])
            tser = dsm.mean.(enms{(j-1)*4+ii});
            rstr = get(tser,'comment');
            x.graph(rstr,'zeroline',true,'style',sty);
%             x.highlight('',plot_hlight,'hPosition','center');
            x.series('',tser);
        end       
    end           

%% Creating tables
% Defining fancy colors for the table
x.tex('','\definecolor{mynewcol1}{rgb}{0,0,0.5}'); 
x.tex('','\definecolor{mynewcol2}{rgb}{0,0.5,0.5}'); 
x.tex('','\definecolor{mynewcol3}{rgb}{0.8,0.5,0.25}'); 
x.tex('','\definecolor{mynewcol4}{rgb}{0.5,0,0}'); 
x.tex('','\definecolor{mynewcol5}{rgb}{0.5,0,0.5}'); 
 
subTface1 = '\bfseries\color{mynewcol1}\large';
subTface2 = '\bfseries\color{mynewcol2}\large';
subTface3 = '\bfseries\color{mynewcol3}\large';
subTface4 = '\bfseries\color{mynewcol4}\large';
subTface5 = '\bfseries\color{mynewcol5}\large';

x.pagebreak();
x.table('Principaux Incicateurs', tblOptions{:});
x.subheading('Taux d''Interet Nominal','typeface',subTface1);
    x.series('Taux directeur',                 db.i,                       'units','% p.a.');
    x.subheading('');

    x.subheading('IPC Inflation','typeface',subTface2);
    x.series('IPC inflation',               delog(db.d4l_cpi),          'units','% YoY');
    x.series('',                            delog4(db.dl_cpi),          'units','% QoQ ann.');
    x.subheading('');

    x.subheading('PIB Reel','typeface',subTface3);
    x.series('Croissance de PIB',          delog(db.d4l_y),            'units','% YoY');
    x.series('L''ecart de production',     db.l_y_gap,                 'units','%');
    x.series('Croissance Potentiel',       delog4(db.dl_y_tnd),        'units','% QoQ ann.');
    x.subheading('');
    
    x.subheading('Conditions Monetaire','typeface',subTface4);
    x.series('Indice des Cond. Monetaire Reel',   db.rmci,                   'units','%');
    x.series('L''ecart de TIR ',      db.r_gap,                 'units','p.p.');
    x.subheading('');
x.pagebreak();
%% Shock decomposition

% Get the name of all observables

xnames =  get(m,'xList');
xcomms =  get(m,'xDescript');
  
x.section('Shock decomposition');

leg_entries     = [decomp.shock_decomp_groups, decomp.shock_decomp_group_rest];

for i = 1:length(decomp.shock_decomp_variables)

    series_name     = decomp.shock_decomp_variables{i};
    figure_name = [xcomms{strcmp(xnames,series_name)},' [',series_name,']'];
    x.figure(figure_name, 'style',sty);

    decomp_contribs = decomp.shock_contrib_db.(decomp.shock_decomp_variables{i}){:,1:end-1};
    decomp_series = db.(series_name);
    x.graph(figure_name,'range',plot_rng,'xlabel',' ','legend',true);
    x.series('',decomp_contribs,'plotFunc',@barcon,'legendEntry',leg_entries);
    x.series('',decomp_series,'legendEntry',NaN); % Background (white)
    x.series('',decomp_series,'legendEntry',NaN); % Foreground
end
%%  
    
x.publish([resDir filesep 'gn_report_filter.pdf']);