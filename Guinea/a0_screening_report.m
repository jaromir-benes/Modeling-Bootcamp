%% BCRG - OGR: Mission d’assistance technique en analyse 
%% et prévision macroéconomiques 

%% Menage
clear all
close all
clc

% Creer une dossier pour les resultats
resDir = 'results\a0_screening_report';
[~,~,~] = mkdir(resDir);

% Ajouter la dossier des donnees au Search PAth
addpath('donnees');

%% Charger les donnees
dm = dbload('db_monthly.csv','delimiter',';');
dq = dbload('db_quarterly.csv','delimiter',';');
dy = dbload('db_yearly.csv','delimiter',';');
dx = dbload('db_external.csv','delimiter',';');

% Transformer les donnees
% Base de donnees trimestrielle
dq.l_y = 100*log(convert(dy.pib_reel,'q'));
dq.l_ny = 100*log(convert(dy.pibn,'q'));
[dq.l_y_tnd, dq.l_y_gap] = hpf(dq.l_y);
dq.l_usd_gnf = 100*log(convert(dm.usd_gnf,'q'));
dq.l_eur_gnf = 100*log(convert(dm.eur_gnf,'q'));
dq.l_cpi_f = 100*log(dx.cpi_us);
dq.usd_gnf = convert(dm.usd_gnf,'q');
dq.eur_gnf = convert(dm.eur_gnf,'q');

% Convertir les indice des prix au frequence trimestrielle
cpi_list = {'','_local','_import','_food','_clothing','_ameu','_house_energie','_trans','_health',...
    '_cult','_educ','_hotel','_other'};
for i = 1:length(cpi_list)
    cpi_name = ['cpi' cpi_list{i}];
    l_cpi_name = ['l_cpi' cpi_list{i}];
    dq.(l_cpi_name) = 100*log(convert(dm.(cpi_name),'q'));
end

% Taux d'interet
dq.ir = convert(dm.ir,'q');
dm.rir = dm.ir-pct(dm.cpi,-12);
[dm.rir_tnd, dm.rir_gap] = hpf(dm.rir); 
% RER
dq.l_z = dq.l_usd_gnf + dq.l_cpi_f - dq.l_cpi;
[dq.l_z_tnd, dq.l_z_gap] = hpf(dq.l_z);

%% Definir le style des graphiques
sty = struct();
sty.line.linewidth = {2, 1,2,2,2,2};                % epaisseur des lignes
sty.line.linestyle = {'-';'--';'-';'-';'-';'-'};    % Style des lignes
sty.axes.box = 'off';                               % Box du legende: off
sty.legend.location='SouthOutside';                 % Location des legendes: dehors et au-dessues de la graphique
sty.legend.orientation = 'Horizontal';              % 
sty.zeroline = 'true';

%% Rapport les donnees
% Creer l'objet du rapport
x = report.new('Faits stylises de la Guinee');

% Vue d'ensemble
x.figure('Vue d''ensemble','subplot',[2,2],'range',qq(2005,1):enddate(dq.l_cpi),'style',sty,...
    'dateformat','YYYY:P','figurescale',0.85);
x.graph('Croissance du PIB Reel (%)');
x.series({'Glissement Annuel','Croissance Annuelle'},[diff(dq.l_y,-4) diff(dq.l_y,-1)*4]);
x.graph('Inflation (%) (100*log)');
x.series({'Glissement Annuel','Croissance Annuelle'},[diff(dq.l_cpi,-4) diff(dq.l_cpi,-1)*4]);
x.graph('Taux directeur (%, p.a.)');
x.series('',dq.ir);
x.graph('USD/GNF depreciation (%)','legend',true);
x.series({'Annuel', 'Trimestriele'},[pct(dq.usd_gnf,-4), pct(dq.usd_gnf,1)*4]);

% PIB Reel
x.figure('Produits Interieur Brut Reel Observe','subplot',[2,1],'range',qq(2005,1):enddate(dq.l_y),'style',sty,...
    'dateformat','YYYY:P','figurescale',0.85);
x.graph(['PIB Reel (100*log)', ', derniere obs.: ' dat2char(get(dq.l_y,'last'))]);
x.series('',dq.l_y);
x.graph(['Croissance du PIB Reel (100*log)', ', derniere obs.: ' dat2char(get(dq.l_y,'last'))],'legend',true);
x.series({'Glissement Annuel','Croissance Annuelle'},[diff(dq.l_y,-4) diff(dq.l_y,-1)*4]);

% Decomposition du PIB
x.figure('Decomposition du PIB','subplot',[2,1],'range',yy(2005,1):enddate(dy.GDP_prim),'style',sty,...
    'dateformat','YYYY:P','figurescale',0.85); % ,'highlight',yytoday():enddate(dy.GDP_prim)
    x.graph(['Decomposition du PIB (%, croissance annuel)', ', derniere obs.: ' dat2char(get(dy.GDP_prim,'last'))],'legend',true);
    x.series('',pct(dy.pib_reel));
    x.series({'Global','Primaire','Secondaire','Tertiare','DTI'},...
    pct([dy.GDP_prim, dy.GDP_sec, dy.GDP_tert, dy.GDP_DTI],-1)*[dy.GDP_prim{-1}, dy.GDP_sec{-1}, dy.GDP_tert{-1}, dy.GDP_DTI{-1}]/dy.pib_reel{-1},...
    'plotfunc',@conbar);
    x.highlight('', yytoday():enddate(dy.GDP_prim));
x.graph(['Decomposition du PIB (%, croissance annuel)', ', derniere obs.: ' dat2char(get(dy.GDP_prim,'last'))],'legend',true);
    x.series('',dy.pib_reel/dy.pib_reel*100);
    x.series({'','Primaire','Secondaire','Tertiare','DTI'},...
    100*[dy.GDP_prim, dy.GDP_sec, dy.GDP_tert, dy.GDP_DTI]/dy.pib_reel,...
    'plotfunc',@conbar);
    x.highlight('', yytoday():enddate(dy.GDP_prim));
    
% Ecart de production
x.figure('PIB Reel: Filtration Hodrick-Prescott','subplot',[2,1],'range',qq(2005,1):enddate(dq.l_y),'style',sty,...
    'dateformat','YYYY:P','figurescale',0.85);
x.graph(['PIB Reel: Tendance et niveau (100*log)', ', derniere obs.: ' dat2char(get(dq.l_y,'last'))],'legend',true);
x.series({'Tendance','Niveau'},[dq.l_y_tnd,dq.l_y]);
x.graph(['Ecart de production', ', derniere obs.: ' dat2char(get(dq.l_y_gap,'last'))]);
x.series('', dq.l_y_gap,'zeroline',true,'plotfunc',@bar);

% PIB Nominal
x.figure('Produits Interieur Brut Nominal Observe','subplot',[2,1],'range',qq(2005,1):enddate(dq.l_ny),...
    'style', sty,'dateformat','YYYY:P','figurescale',0.85);
x.graph(['PIB Nominal (100*log)', ', derniere obs.: ' dat2char(get(dq.l_ny,'last'))]);
x.series('',dq.l_ny);
x.graph(['Croissance du PIB Nominal (100*log)', ', derniere obs.: ' dat2char(get(dq.l_ny,'last'))],'legend',true);
x.series({'Glissement Annuel','Croissance Annuelle'},[diff(dq.l_ny,-4) diff(dq.l_ny,-1)*4]);

% Inflation: general indice
x.figure('Inflation','subplot',[2,1],'range',mm(2005,1):enddate(dm.cpi),...
    'style', sty,'dateformat','YYYY:P','figurescale',0.85);
x.graph(['IPC: indice general', ', derniere obs.: ' dat2char(get(dm.cpi,'last'))]);
x.series({''},dm.cpi);
x.graph(['Inflation', ', derniere obs.: ' dat2char(get(dm.cpi,'last'))],'legend',true);
x.series({'Glissement Annuel','Croissance Annuelle'},[pct(dm.cpi,-12) pct(dm.cpi,-1)*12]);

fh = figure('visible','off');
rng = qq(2005,1):get(dq.l_cpi,'last');

subplot(211)
    [AX1,H1,H2] =  plotyy(rng, diff(dq.l_cpi,-4), rng , 4*diff((100*log(dx.oil)+dq.l_usd_gnf),-1));
    set([H1, H2],'Linewidth',2);
    set(AX1(2),'YLim',[-300,300]);
    set(AX1(1),'YLim',[-20,50]);
    grid on;
    title('Inflation vs. prix de petrole (% croissance annuel)');
    legend([H1;H2],'HIPC Inflation','Prix de petrole (%, ann.)');
subplot(212)
    [AX1,H1,H2] =  plotyy(rng, diff(dq.l_cpi_food,-4), rng , 4*diff((100*log(dx.food)+dq.l_usd_gnf),-1));
    set([H1, H2],'Linewidth',2);
    set(AX1(2),'YLim',[-300,300]);
    set(AX1(1),'YLim',[-20,50]);
    grid on;
    title('Inflation des produits alimentaires vs. prix alimentaires mondiaux (% croissance annuel)');
    legend([H1;H2],'Guinee','Global');
x.userfigure('',fh);


x.figure('Decomposition de l''inflation','subplot',[1,1],'range',mm(2005,1):enddate(dm.cpi),...
    'style', sty,'dateformat','YYYY:P','figurescale',0.85);
x.graph('Glissement annuel', 'style', sty, 'legend', true);
    x.series({''},pct(dm.cpi,-12));             
    x.series({'','Alim.','Vet.','Ameub.','Trans.','Log.','Sante','Cult.','Educ.','Hotel','Autre'},...
                 pct([dm.cpi_food, dm.cpi_clothing, dm.cpi_ameu, dm.cpi_trans, dm.cpi_house_energie,...
                 dm.cpi_health, dm.cpi_cult, dm.cpi_educ, dm.cpi_hotel, dm.cpi_other],-12).*...
                 [dm.w_cpi_food{-12}, dm.w_cpi_clothing{-12}, dm.w_cpi_ameu{-12}, dm.w_cpi_trans{-12}, dm.w_cpi_house_energie{-12},...
                 dm.w_cpi_health{-12}, dm.w_cpi_cult{-12}, dm.w_cpi_educ{-12}, dm.w_cpi_hotel{-12}, dm.w_cpi_other{-12}]/10000, 'plotfunc',@conbar);

x.figure('Decomposition de l''inflation II.','subplot',[1,1],'range',mm(2005,1):enddate(dm.cpi),...
    'style', sty,'dateformat','YYYY:P','figurescale',0.85);
x.graph('Croissance mensuel', 'style', sty, 'legend', true);
    x.series({''},apct(dm.cpi,-1));             
    x.series({'','Alim.','Vet.','Ameub.','Trans.','Log.','Sante','Cult.','Educ.','Hotel','Autre'},...
                 apct([dm.cpi_food, dm.cpi_clothing, dm.cpi_ameu, dm.cpi_trans, dm.cpi_house_energie,...
                 dm.cpi_health, dm.cpi_cult, dm.cpi_educ, dm.cpi_hotel, dm.cpi_other],-1)*...
                 [dm.w_cpi_food{-1}, dm.w_cpi_clothing{-1}, dm.w_cpi_ameu{-1}, dm.w_cpi_trans{-1}, dm.w_cpi_house_energie{-1},...
                 dm.w_cpi_health{-1}, dm.w_cpi_cult{-1}, dm.w_cpi_educ{-1}, dm.w_cpi_hotel{-1}, dm.w_cpi_other{-1}]/10000, 'plotfunc',@conbar);             
             
% Inflation: sous-indices I.
x.figure('Inflation: sous-inidices I.','subplot',[2,2],'range',mm(2005,1):enddate(dm.cpi),...
    'style', sty,'dateformat','YYYY:P','figurescale',0.85);
x.graph(['Inflation: Produits locaux (100*log)', ', derniere obs.: ' dat2char(get(dm.cpi_local,'last'))],'zeroline',true);
    x.series({'Glissement Annuel','Croissance Annuelle'},[pct(dm.cpi_local,-12), pct(dm.cpi_local,-1)*12]);
x.graph(['Inflation: Produits importes (100*log)', ', derniere obs.: ' dat2char(get(dm.cpi_import,'last'))],'zeroline',true);
    x.series({'Glissement Annuel','Croissance Annuelle'},[pct(dm.cpi_import,-12), pct(dm.cpi_import,-1)*12]);
x.graph(['Inflation: Alimentation (100*log)', ', derniere obs.: ' dat2char(get(dm.cpi_food,'last'))],'zeroline',true);
    x.series({'Glissement Annuel','Croissance Annuelle'},[pct(dm.cpi_food,-12), pct(dm.cpi_food,-1)*12]);
x.graph(['Inflation: Habillement et chaussures (100*log)', ', derniere obs.: ' dat2char(get(dm.cpi_clothing,'last'))],'zeroline',true,'legend',true);
    x.series({'Glissement Annuel','Croissance Annuelle'},[pct(dm.cpi_clothing,-12), pct(dm.cpi_clothing,-1)*12]);

% Inflation: sous-indices II.
x.figure('Inflation: sous-inidices II.','subplot',[2,2],'range',mm(2005,1):enddate(dm.cpi),...
    'style', sty,'dateformat','YYYY:P','figurescale',0.85);
x.graph(['Inflation: Ameublement/Equipement menager (100*log)', ', derniere obs.: ' dat2char(get(dm.cpi_ameu,'last'))],'zeroline',true);
x.series({'Glissement Annuel','Croissance Annuelle'},[pct(dm.cpi_ameu,-12), pct(dm.cpi_ameu,-1)*12]);
x.graph(['Inflation: Transport (100*log)', ', derniere obs.: ' dat2char(get(dm.cpi_trans,'last'))],'zeroline',true);
x.series({'Glissement Annuel','Croissance Annuelle'},[pct(dm.cpi_trans,-12), pct(dm.cpi_trans,-1)*12]);
x.graph(['Inflation: Logement/Electricite/Eau/Gaz (100*log)', ', derniere obs.: ' dat2char(get(dm.cpi_house_energie,'last'))],'zeroline',true);
x.series({'Glissement Annuel','Croissance Annuelle'},[pct(dm.cpi_house_energie,-12), pct(dm.cpi_house_energie,-1)*12]);
x.graph(['Inflation: Sante (100*log)', ', derniere obs.: ' dat2char(get(dm.cpi_health,'last'))],'zeroline',true,'legend',true);
x.series({'Glissement Annuel','Croissance Annuelle'},[pct(dm.cpi_health,-12), pct(dm.cpi_health,-1)*12]);

% Inflation: sous-indices III.
x.figure('Inflation: sous-inidices III.','subplot',[2,2],'range',mm(2005,1):enddate(dm.cpi),...
    'style', sty,'dateformat','YYYY:P','figurescale',0.85);
x.graph(['Inflation: Loisir/spectacle/culture (100*log)', ', derniere obs.: ' dat2char(get(dm.cpi_cult,'last'))],'zeroline',true);
x.series({'Glissement Annuel','Croissance Annuelle'},[pct(dm.cpi_cult,-12), pct(dm.cpi_cult,-1)*12]);
x.graph(['Inflation: Enseignement (100*log)', ', derniere obs.: ' dat2char(get(dm.cpi_educ,'last'))],'zeroline',true);
x.series({'Glissement Annuel','Croissance Annuelle'},[pct(dm.cpi_educ,-12), pct(dm.cpi_educ,-1)*12]);
x.graph(['Inflation: Hotels cafe restaurants (100*log)', ', derniere obs.: ' dat2char(get(dm.cpi_hotel,'last'))],'zeroline',true);
x.series({'Glissement Annuel','Croissance Annuelle'},[pct(dm.cpi_hotel,-12), pct(dm.cpi_hotel,-1)*12]);
x.graph(['Inflation: Autre (100*log)', ', derniere obs.: ' dat2char(get(dm.cpi_other,'last'))],'zeroline',true,'legend',true);
x.series({'Glissement Annuel','Croissance Annuelle'},[pct(dm.cpi_other,-12), pct(dm.cpi_other,-1)*12]);

% Masse monétaire
x.figure('Masse monetaire (M2, milliard GNF)','subplot',[2,1],'range', mm(2005,1):enddate(dm.M2),'style',sty,...
    'dateformat','YYYY:P','figurescale',0.85);
x.graph(['Masse Monetaire (milliard GNF)', ', derniere obs.: ' dat2char(get(dq.l_y,'last'))]);
x.series('',dm.M2);
x.graph(['Croissance du Masse monetaire', ', derniere obs.: ' dat2char(get(dq.l_y,'last'))],'zeroline',true,'legend',true);
x.series({'Glissement Annuel','Croissance Annuelle'},[pct(dm.M2,-12) pct(dm.M2,-1)*12]);

% Taux d'interet
x.figure('Conditions Monetaire I.','subplot',[1,1],'range',startdate(dm.ir_ib_7j):enddate(dm.ir),'style',sty,...
    'dateformat','YYYY:P','figurescale',0.85);
x.graph(['Taux d''interet - comparison', ', derniere obs.: ' dat2char(get(dm.ir,'last'))],'legend',true);
x.series({'Taux directeur','Taux interbancaire a 7 jours', 'BDT a 91 jours', 'BDT a 182 jours', 'BDT a 364 jours'},...
    [dm.ir, dm.ir_ib_7j dm.bdt_91j dm.bdt_182j dm.bdt_364j]);

% Liquidité Excédentaire
x.figure('Conditions Monetaire II.','subplot',[1,1],'range',startdate(dm.res_ex):enddate(dm.res_ex),'style',sty,...
    'dateformat','YYYY:P','figurescale',0.85);
x.graph(['Montant des Reserves du Secteur Bancaire  (Insuffisance(-)/Excedent(+)) (en GNF)', ', derniere obs.: ' dat2char(get(dm.res_ex,'last'))],'legend',true);
x.series('', dm.res_ex);

% Créances sur l'État et Avoirs Extérieurs Nets
x.figure('Conditions Monetaire III.','subplot',[2,1],'range',mm(2011,1):enddate(dm.cre_etat),'style',sty,...
    'dateformat','YYYY:P','figurescale',0.85);
x.graph(['Créances sur l''Etat (milliard GNF)', ', derniere obs.: ' dat2char(get(dm.cre_etat,'last'))]);
x.series('',dm.cre_etat);
x.graph(['Croissance de Créances sur l''Etat (%, glissement annuel)', ', derniere obs.: ' dat2char(get(dm.cre_etat,'last'))]);
x.series('Glissement annuel',pct(dm.cre_etat,-12));

% Avoirs Exterieurs Net
x.figure('Avoir Exterieur Net.','subplot',[1,1],'range',startdate(dm.av_ext_net):enddate(dm.av_ext_net),'style',sty,...
    'marker',{'','*','+','x','o'},...
    'dateformat','YYYY:P','figurescale',0.85);
x.graph(['Avoirs Exterieurs Net (million USD)', ', derniere obs.: ' dat2char(get(dm.av_ext_net,'last'))],'zeroline',true,'legend', true);
x.series('',dm.av_ext_net);

% Taux de change nominal
x.figure('Taux de change nominal: USD/GNF','subplot',[2,1],'range',mm(2005,1):enddate(dm.usd_gnf),'style',sty,...
    'dateformat','YYYY:P','figurescale',0.85);
x.graph(['USD/GNF', ', derniere obs.: ' dat2char(get(dm.usd_gnf,'last'))],'legend',true);
x.series({'Officiel','Parallel'},[dm.usd_gnf dm.usd_gnf_p]);
x.graph(['USD/GNF depreciation officielle (%)', ', derniere obs.: ' dat2char(get(dm.usd_gnf,'last'))],'zeroline',true,'legend', true);
x.series({'Annuel', 'Trimestriele'},[pct(dm.usd_gnf,-12), pct(dm.usd_gnf,1)*12]);

% Taux de change nominal
x.figure('Taux de change nominal: EUR/GNF','subplot',[2,1],'range',mm(2005,1):enddate(dm.eur_gnf),'style',sty,...
    'dateformat','YYYY:P','figurescale',0.85);
x.graph(['EUR/GNF', ', derniere obs.: ' dat2char(get(dm.eur_gnf,'last'))]);
x.series('', dm.eur_gnf);
x.graph(['EUR/GNF depreciation (%)', ', derniere obs.: ' dat2char(get(dm.eur_gnf,'last'))],'zeroline',true,'legend', true);
x.series({'Annuel', 'Trimestrielle'}, [pct(dm.eur_gnf,-12), pct(dm.eur_gnf,-1)*12]);

% Taux de change reel par BCRG
x.figure('Taux de change effectif par BCRG','subplot',[2,1],'range',qq(2005,1):enddate(dq.tcer),'style',sty,...
    'dateformat','YYYY:P','figurescale',0.85);
x.graph(['Taux de change effective', ', derniere obs.: ' dat2char(get(dq.tcer,'last'))]);
x.series({'Reel','Nominal'}, [dq.tcer dq.tcen]);
x.graph(['Depreciation des taux de change effectif (%, glissement annuel)', ', derniere obs.: ' dat2char(get(dq.tcer,'last'))],'zeroline',true,'legend', true);
x.series({'TCER', 'TCEN'}, [pct(dq.tcer,-4), pct(dq.tcen,-4)]);

% Taux de change reel
x.figure('Taux de change reel: Filtrage Hodrick-Prescott','subplot',[2,1],'range',qq(2005,1):enddate(dq.l_z),'style',sty,...
    'dateformat','YYYY:P','figurescale',0.85);
x.graph(['Tendance et niveau (100*log)', ', derniere obs.: ' dat2char(get(dq.l_z_tnd,'last'))],'legend',true);
x.series({'Tendance','Niveau'},[dq.l_z_tnd,dq.l_z]);
x.graph(['Ecart de taux de change reel', ', derniere obs.: ' dat2char(get(dq.l_z,'last'))]);
x.series('', dq.l_z_gap,'zeroline',true,'plotfunc',@bar);

% Variable d'etrangere
x.figure('Variables etrangeres','subplot',[2,2],'range',qq(2005,1):enddate(dx.cpi_us),'style',sty,...
    'dateformat','YYYY:P','figurescale',0.85);
x.graph('Inflation d''etats-Unis (100*log)');
x.series('',diff(100*log(dx.cpi_us),-4));
x.graph('Taux de fonds federaux (Etats-Unis)');
x.series('',dx.i_fed_us);
x.graph('USD/EUR');
x.series('',dx.usd_eur);

% Prix des produits de base
x.figure('Prix des produits de base','subplot',[2,2],'range',qq(2005,1):enddate(dx.oil),'style',sty,...
    'dateformat','YYYY:P','figurescale',0.85);
x.graph('Petrole brut Brent (USD)');
x.series('',dx.oil);
x.graph('Or, prix au comptant (USD)');
x.series('',dx.gold);
x.graph('Indice des prix des diamants industriels (USD)');
x.series('',dx.diam);
x.graph('Indice des prix des aliments (2002-2004 = 100, FAO (ONU), USD)');
x.series('',dx.food);

%% Creez des tableaux
% Definir les options
tblRng  = enddate(dq.l_cpi)-8:enddate(dq.l_cpi);
tblRng_annual = dat2ypf(enddate(dq.l_cpi)-16):dat2ypf(enddate(dq.l_cpi));
tblOptions={'range',tblRng,'decimal',1,...
            'dateformat','YYFP',...
            'long',true,...
            'longfoot','---continued',...
            'longfootposition','right',...
            'typeface','\color{black}',...
                      'captiontypeface','\LARGE\bfseries\color{black}'};


% Definir des couleurs pour la tableau
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

% Definir des fonctions supplementaires pour gerer les donnees
delog = @(x) 100*(exp(x/100)-1);
delog4 = @(x) 400*(exp(x/400)-1);
dbev = @(str) dbeval(dsm,str);


x.pagebreak();
x.table('Principaux indicateurs', tblOptions{:});

    x.subheading('PIB Reel'); % ,'typeface',subTface1
    x.series('Croissance du PIB',               delog(diff(dq.l_y,-4)),         'units','% YoY');
    x.series('Output gap',                      dq.l_y_gap,                     'units','%');
    x.series('Croissance potentielle',          delog4(diff(dq.l_y_tnd,-1)*4),  'units','% QoQ ann.');
    x.subheading('');

    x.subheading('Taux d''interets nominal');
    x.series('Taux directeur',                  dq.ir,                          'units','% p.a.');
    x.subheading('');

    x.subheading('IPC Inflation');
    x.series('IPC Inflation',                   delog(diff(dq.l_cpi,-4)),       'units','% YoY');
    x.series('',                                delog4(diff(dq.l_cpi)*4),       'units','% QoQ ann.');
    x.subheading('');
    
    x.subheading('Prix de produits brut');
    x.series('Petrole brut Brent',              dx.oil,                         'units','USD');
    x.series('Or',                              dx.gold,                        'units','USD');
    x.series('Diamant',                         dx.diam,                        'units','USD');
    x.series('Aliments',                        dx.food,                        'units','indice, 2002-2004 = 100');    
    x.subheading('');    
    
x.pagebreak();

x.publish([resDir filesep 'gn_screening_report.pdf'])
