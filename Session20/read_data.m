%% Read US Data from FRED Database 


%% Clear Workspace 

close all
clear
clc


%% Read Monthly and Quarterly Series 

% Monthly data
dm = databank.fromFred({ 'CPIAUCNS->cpi_u'      ... CPI All Items Not SA
                         'CPIAUCSL->cpi'        ... CPI All Items SA
                         'CPILFESL->cpi_xfe'    ... CPI Less Food Energy SA
                         'PCEPI->pce' });       ... PCE Price Index SA

% Quarterly data
dq = databank.fromFred({ 'GDPC1->gdp'           ... Real GDP SA
                         'PCECTPI->pce' });     ... PCE Price Index SA


%% Print Contents of Databanks 

disp(dm)
disp(dq)


%% Save Databanks to MAT Files 

save mat/read_data.mat dm dq

