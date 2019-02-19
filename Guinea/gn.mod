!transition_variables
'Production (100*log)'                      l_y
'Ecart de production (%)'                   l_y_gap
'Production potentielle (100*log)'          l_y_tnd
'PIB: taux croissance annuel (%)'           dl_y
'PIB: glissement annuel (%)'                d4l_y
'Croissance annuel de prod. pot. (%)'       dl_y_tnd

'Inflation: niveau (100*log)'               l_cpi
'Inflation (%, annuel)'                     dl_cpi
'Inflation: glissement annuel (%)'          d4l_cpi
'Cible de l''inflation'                     dl_cpi_tar
'Anticipation de l''inflation'              e_dl_cpi

'Cout marginal de prod.'                    rmc
'Indice des conditions mon. reelles'        rmci

'Taux d''interet nominal'                   i
'Taux d''interet neutre'                    i_neutral

'Taux d''interet reel'                      r
'Tendance du taux d''interet reel'          r_tnd
'Ecart de taux d''interet reel'             r_gap


'Taux de change nominal (USD per GNF)'      l_s
'Esperance(+1) de taux de change nominal'   e_l_s
'Depreciation nominale du change, ann'      dl_s
'Taux de change reel (TCR)'                 l_z
'Ecart du TCR'                              l_z_gap
'Tendance du TCR'                           l_z_tnd
'Depreciation du  TCR'                      dl_z
'Depreciation de la tendance RER, ann.'     dl_z_tnd
'Depreciation de TCR, glissement annuel'    d4l_z
'Prime de risque'                           prem

'Ecart de production a l''etranger'         l_y_gap_f
'IPC etranger'                              l_cpif
'Inflation etrangere, ann.'                 dl_cpif
'Inflation etrangere, glissement ann.'      d4l_cpif
'Inflation importee'                        dl_cpim
'Taux d''interet reel etranger'             rf
'Ecart de taux d''interet reel etranger'    rf_gap
'Tendance du TIR etranger'                  rf_tnd
'Taux d''interet nominal etranger'          i_f

% Decomposition miniere
'PIB reel miniere (100*log)'                                        l_ym
'PIB réel hors-miniere (100*log)'                                   l_yxm
'Croissance de la prod. miniere (%, glissement annuel)'             d4l_ym
'Croissance de la prod. hors-miniere (%, glissement annuel)'        d4l_yxm
'Croissance de la prod. miniere (%, croissance annuel)'             dl_ym
'Croissance de la prod. hors-miniere (%, croissance annuel)'        dl_yxm

'Ecart de production minier (%)'                                    l_ym_gap
'Ecart de production hors-minier (%)'                               l_yxm_gap
'Croissance potentielle de la prod. miniere (%, croissance annuel)' dl_ym_tnd
'Croissance potentielle de la prod. miniere (%, croissance annuel)' dl_yxm_tnd
'Production potentielle miniere (100*log)'                          l_ym_tnd
'Production potentielle hors-miniere (100*log)'                     l_yxm_tnd

'Divergence de croissance du PIB (croissance annuel)'               dl_y_disc
'Divergence de croissance du PIB (glissement annuel)'               d4l_y_disc

!parameters
% Definir des parametres
a1 = 0.7   % l_y_gap{-1} 
a2 = 0.1   % l_y_gap{+1}
a3 = 0.15  % rmci
a4 = 0.1   % l_y_gap_f
a5 = 0.1   % l_ym_gap
b1 = 0.7   % dl_cpi{-1}
b2 = 0.1   % dl_cpi_im-dl_z_tnd
b3 = 0.3   % rmc
 
c1 = 0.2;       % dl_s{-1}
c2 = 0.3;       % dl_cpi{+3} - dl_cpi_tar
c3 = 0.6;       % l_z_gap
c4 = 0.2;       % prem-ss_prem
c_i = 0.4;      % i{-1}
c_e_l_s = 0.5;  % l_s{+1} anticipations prospectifs

d1 = 0.8    % dl_z_tnd{-1}
e1 = 0.8    % dl_y_tnd{-1}
em1 = 0.8   % dl_ym_tnd{-1}
exm1 = 0.8  % dl_yxm_tnd{-1}

f1 = 0.99   % dl_cpi_tar{-1}
g1 = 0.9    % r_tnd{-1}
h1 = 0.8    % dl_cpif{-1}
i1 = 0.9    % rf_tnd{-1}
k1 = 0.9    % l_y_gap_f{-1}
l1 = 0.8    % rf_tnd{-1}
m1 = 0.4    % rmc: l_y_gap
n1 = 0.4    % rmci: r_gap
o1 = 0.8    % i_f{-1}
p1 = 0.8    % prem{-1}

s1 = 0.3;   % proportion du secteur miniere
am1 = 0.5;  % l_ym_gap{-1}
am2 = 0.8;  % l_y_gap_f

'SS de la production potentielle m.'    ss_dl_ym_tnd    = 3.5;
'SS de la production potentielle xm'    ss_dl_yxm_tnd   = 5.5;
'SS du cible de l''inflation'           ss_dl_cpi_tar   = 8.0; % FMI
'SS du prim du risque'                  ss_prem         = 6.0;    
'SS du tendance du TIR etranger'        ss_rf_tnd       = -0.5;
'SS de l''inflation etranger'           ss_dl_cpif      = 2.0;
'SS de la depreciation du TCR'          ss_dl_z_tnd     = -3.5;

std_shock_l_ym_gap      = 1.50;
std_shock_l_yxm_gap     = 1.0;
std_shock_dl_ym_tnd     = 0.75;
std_shock_dl_yxm_tnd    = 0.75;
std_shock_dl_cpi        = 1.50;
std_shock_dl_cpi_tar    = 0.50;
std_shock_dl_s          = 6.00;
std_shock_dl_z_tnd      = 2.00;
std_shock_l_y_gap_f     = 0.40;
std_shock_dl_cpif       = 1.00;
std_shock_rf_tnd        = 0.10;
std_shock_prem          = 2.00;
std_shock_i_f           = 0.10;
std_shock_dl_y_disc     = 0.20;

!transition_shocks
'Choc sur la demande miniere'           shock_l_ym_gap
'Choc sur la demande ex-miniere'        shock_l_yxm_gap
'Choc sur la production potentielle'    shock_dl_ym_tnd
'Choc sur la production potentielle'    shock_dl_yxm_tnd
'Choc sur offre'                        shock_dl_cpi
'Choc sur le cible inflation'           shock_dl_cpi_tar
'Choc sur la politique monetaire'       shock_dl_s
'Choc sur la tendance de TCR'           shock_dl_z_tnd
'Choc sur ecart du PIB etranger'        shock_l_y_gap_f
'Choc sur inflation etranger'           shock_dl_cpif
'Choc sur tendance du TIR etranger'     shock_rf_tnd
'Choc sur la prim du risque'            shock_prem
'Choc sur le taux interet nominal'      shock_i_f
shock_dl_y_disc

!transition_equations
% Courbes IS
l_y_gap = s1*l_ym_gap + (1-s1)*l_yxm_gap;

l_yxm_gap = a1*l_yxm_gap{-1} + a2*l_yxm_gap{+1} ...
    - a3*rmci + a4*l_y_gap_f + a5*l_ym_gap ...
    + shock_l_yxm_gap;
rmci = n1*r_gap - (1-n1)*l_z_gap;

l_ym_gap  = am1*l_ym_gap{-1} + am2*l_y_gap_f + shock_l_ym_gap;

% Courbe de Phillips
dl_cpi = b1*dl_cpi{-1} + (1-b1-b2)*e_dl_cpi + b2*(dl_cpim - dl_z_tnd) + b3*rmc + shock_dl_cpi;
rmc     = m1*l_yxm_gap + (1-m1)*l_z_gap;
dl_cpim = dl_cpif + dl_s;
e_dl_cpi= dl_cpi{+1}; 

% Regle de la politique Monetaire
dl_s = c1 * dl_s{-1} ...
    + (1-c1)*(dl_z_tnd + dl_cpi_tar - ss_dl_cpif ...
             - c2*(dl_cpi{+3} - dl_cpi_tar) ...
             - c3*l_z_gap) ...
             + c4*(prem-ss_prem) ... 
             + shock_dl_s;                
% PTINC
i = c_i*i{-1} + (1-c_i)*((e_l_s - l_s)*4 + i_f + prem);
e_l_s  = c_e_l_s*l_s{+1} ...
             + (1-c_e_l_s)*(l_s{-1} ...
             + 2/4*(dl_z_tnd + dl_cpi_tar - ss_dl_cpif));

dl_s = 4*(l_s - l_s{-1});

% PTINC reel
r_tnd = rf_tnd + dl_z_tnd + prem;

l_z = l_s + l_cpif - l_cpi;
l_z = l_z_tnd + l_z_gap;
dl_z = 4*(l_z - l_z{-1});
d4l_z = l_z - l_z{-4};
l_z_tnd = l_z_tnd{-1} + dl_z_tnd/4;

% Tendances
% dl_y_tnd    = e1*dl_y_tnd{-1} + (1-e1)*ss_dl_y_tnd + shock_dl_y_tnd;
dl_z_tnd = d1*dl_z_tnd{-1} + (1-d1)*ss_dl_z_tnd + shock_dl_z_tnd;
dl_cpi_tar  = f1*dl_cpi_tar{-1} + (1-f1)*ss_dl_cpi_tar + shock_dl_cpi_tar;
prem        = p1*prem{-1} + (1-p1)*ss_prem + shock_prem;

% Identites, definitions
l_y         = l_y_tnd + l_y_gap; 
l_ym  = l_ym_tnd + l_ym_gap;
l_yxm = l_yxm_tnd + l_yxm_gap;

dl_y_tnd    = 4*(l_y_tnd - l_y_tnd{-1});
dl_ym_tnd  = 4*(l_ym_tnd - l_ym_tnd{-1});
dl_yxm_tnd = 4*(l_yxm_tnd - l_yxm_tnd{-1});

dl_ym_tnd    = em1*dl_ym_tnd{-1} + (1-em1)*ss_dl_ym_tnd + shock_dl_ym_tnd;
dl_yxm_tnd   = exm1*dl_yxm_tnd{-1} + (1-exm1)*ss_dl_yxm_tnd + shock_dl_yxm_tnd;

dl_y    = 4*(l_y - l_y{-1});
dl_ym  = 4*(l_ym - l_ym{-1});
dl_yxm = 4*(l_yxm - l_yxm{-1});

dl_y        = s1*dl_ym + (1-s1)*dl_yxm + dl_y_disc;
dl_y_disc   = shock_dl_y_disc;
d4l_y_disc  = (dl_y_disc + dl_y_disc{-1} + dl_y_disc{-2} + dl_y_disc{-3})/4;

d4l_ym  = l_ym - l_ym{-4};
d4l_yxm = l_yxm - l_yxm{-4};
d4l_y   = l_y - l_y{-4};

i_neutral = r_tnd + dl_cpi_tar;
r = i - dl_cpi{+1};
r = r_tnd + r_gap;

dl_cpi  = 4*(l_cpi - l_cpi{-1}); 
d4l_cpi = l_cpi-l_cpi{-4};

% Block etrangere
l_y_gap_f = k1*l_y_gap_f{-1} + shock_l_y_gap_f;

l_cpif = l_cpif{-1} + dl_cpif/4;
dl_cpif = h1 * dl_cpif{-1} + (1-h1) * ss_dl_cpif + shock_dl_cpif;
d4l_cpif = l_cpif-l_cpif{-4};

i_f = o1*i_f{-1} + (1-o1)*(rf_tnd + ss_dl_cpif) + shock_i_f;
rf = i_f - d4l_cpif;
rf = rf_tnd + rf_gap;
rf_tnd = l1*rf_tnd{-1} + (1-l1)*ss_rf_tnd + shock_rf_tnd;

!measurement_variables
obs_l_y
obs_l_ym
obs_l_yxm
obs_dl_cpi
obs_l_s
obs_l_cpif
obs_i_f
obs_rf_tnd
obs_l_y_gap_f

!measurement_equations
obs_l_y         = l_y;
obs_l_ym       = l_ym;
obs_l_yxm      = l_yxm;
obs_dl_cpi      = dl_cpi;
obs_l_s         = l_s;
obs_l_cpif      = l_cpif;
obs_i_f         = i_f;
obs_rf_tnd      = rf_tnd;
obs_l_y_gap_f = l_y_gap_f;