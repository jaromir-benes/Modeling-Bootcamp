%% BCRG - OGR: Mission d’assistance technique en analyse 
%% et prevision macroeconomiques 
% b2_run_histsim: Simulation historiques

%% Housekeeping
clear all;
close all;

% Creating folder for results
resDir = 'results/b2_run_histsim';
[a,b,c] = mkdir(resDir);

disp('*** Exécution de simulations historiques ...');

%% Read Model
mod_file = 'gn.mod';
m = model(mod_file,'linear',true);
m = solve(m);
ss = get(m,'sstate');
p = get(m,'param');

%% Load Dates
sdate = qq(2010,1)-get(m,'maxlag');
edate = qq(2018,1);
iter = edate - sdate;
C = rand(iter,3); %random colors

rng_= sdate:edate;

%% Choose which variables to fix
forfix   = 1;     %- foreign variables fixed

%% Load Data
load(['results/a3_run_filter' filesep 'filter_data.mat']);
d = dbcol(mean,1);
%- additional transformations
%    d.dl_z = 4*diff(d.l_z,-1);
d = dbclip(d,sdate+get(m,'maxlag'):edate);

%% Variables
% Names
tmp = get(m,'descript');
names = get(m,'names');
desc = cell('');
for ii=1:numel(names)
  desc.(names{ii}) = {tmp.(names{ii})};
end
% desc.dl_z = {'RER Depreciation (QoQ)'};

% Exogenised variables
forlist = {'dl_cpif','i_f','l_y_gap_f'};
forshock = {'shock_dl_cpif','shock_i_f','shock_l_y_gap_f'};

list_plan ={};
list_shock ={};
sfx = '';
if forfix
  list_plan = list_plan + forlist;
  list_shock = list_shock + forshock;
  sfx = strcat(sfx,'_forfix');
end

%Reported variables
listTable  = {'l_y','l_z','i','r_gap','r','l_s','dl_cpi','dl_cpim',...
  'dl_cpif'};

%% remove filtered shocks

list=dbnames(d);
for i = 1:length(list)
  if ~isempty(strfind(list{i},'shock_'))
    d = rmfield(d,list{i});
  end
end

%% Create simulation plan and run simulations
hsdb = struct();
for t = 0:iter
  simplan = plan(m,sdate+t:sdate+t+60);
  
  if ~isempty(sfx)
    for p = 1 : length(list_plan)
      simplan = exogenise(simplan,list_plan(p),sdate+t:get(d.(list_plan{p}),'last'));
      simplan = endogenise(simplan,list_shock(p),sdate+t:get(d.(list_plan{p}),'last'));
    end
  end
  
  s = simulate(m, d, sdate+t:sdate+t+7, 'anticipate', false,'plan', simplan);
  
  s = dbextend(d,s);
  s = dbclip(s, sdate+t-1:sdate+t+7);
  eval(['s',num2str(t),'= s;']);
  
  vars = dbnames(s);
  
  for j = 1:numel(vars)
    var = vars{j};
    if strcmp(class(s.(var)),'tseries')
    ldate = get(s.(var),'last');
    if t==0
      hsdb.(var) = tseries(ldate,s.(var)(ldate));
    else
      hsdb.(var)(ldate) = s.(var)(ldate);
    end
    end
  end
end

%% Compute forecast error statistics

mea = [];
sta = [];
sse = [];
rmse = [];
rmse_rw = [];

for j=1:length(listTable)
  
  di1=zeros(iter+1,8);
  rw=zeros(iter+1,8);
  for t=0:iter
    u=eval(['s',num2str(t),'.',listTable{j}]);
    v=eval(['d.',listTable{j}]);
    
    di1(t+1) = u(sdate+t)-v(sdate+t);
    rw(t+1) = v(sdate+t)-v(sdate-1+t);

    di1(t+1,2) = u(sdate+1+t)-v(sdate+1+t);
    rw(t+1,2) = v(sdate+1+t)-v(sdate-1+t);

    di1(t+1,3) = u(sdate+2+t)-v(sdate+2+t);
    rw(t+1,3) = v(sdate+2+t)-v(sdate-1+t);
    
    di1(t+1,4) = u(sdate+3+t)-v(sdate+3+t);
    rw(t+1,4) = v(sdate+3+t)-v(sdate-1+t);
    
    di1(t+1,5) = u(sdate+4+t)-v(sdate+4+t);
    rw(t+1,5) = v(sdate+4+t)-v(sdate-1+t);
    
    di1(t+1,6) = u(sdate+5+t)-v(sdate+5+t);
    rw(t+1,6) = v(sdate+5+t)-v(sdate-1+t);
    
    di1(t+1,7) = u(sdate+6+t)-v(sdate+6+t);
    rw(t+1,7) = v(sdate+6+t)-v(sdate-1+t);
    
    di1(t+1,8) = u(sdate+7+t)-v(sdate+7+t);
    rw(t+1,8) = v(sdate+7+t)-v(sdate-1+t);
  end
  
  fprintf([listTable{j},'\t\t\tmean,std and rmse\n']);
  
  b  = nanmean(di1,1);
  b2 = nanstd(di1);
  
  di1(isnan(di1)) = 0;
  b3=(sum(di1.^2))/size(di1,1) ;
  b4=sqrt(b3);
  
  rw(isnan(rw)) = 0;
  b5=sqrt((sum(rw.^2))/size(rw,1));
  
  mea = [mea; b];
  sta = [sta; b2];
  sse = [sse; b3];
  rmse = [rmse; b4];
  rmse_rw = [rmse_rw; b5];
  
end

%% Reporting
disp(' ');
disp('*** Creating report ...');

listqua={'1q','2q','3q','4q','5q','6q','7q','8q'};

for i=1:length(listTable)
  rowNames{i}=desc.(listTable{i}){1};
end

rowIndex=nan(length(listTable),1);
for i=1:length(listTable)
  rowIndex(i)=strmatch(listTable{i},listTable,'exact');
end

if ~isempty(sfx)
  x = report.new(['Historical Evaluation',' (',strrep(sfx,'_','+'),')']);
else
  x = report.new(['Historical Evaluation',' (free)']);
end

listplot = listTable;

for i=1:length(listplot)
  x.pagebreak;
  figure('visible','off');
    pp=plot(rng_,[d.(listplot{i})],'linewidth',2);
    hold on; grid on;
    set(pp,{'color'},{'k'});
  res_string = '';
  for k = 1:iter
    s_tmp = eval(['s',num2str(k)]);
    g = plot(rng_,[s_tmp.(listplot{i})],'linewidth',1);
    set(g,{'linewidth'},{1});
    set(g,{'linestyle'},{'--'});
    set(g,{'color'},{C(k,:)});
    if k==1
      res_string = 's1';
    else
      res_string = [res_string,' & s',num2str(k)];
    end
  end
  resdb = eval(res_string);
  x.userfigure(desc.(listplot{i}){1},gcf,'figurescale',0.75);
  
  if ~isempty(sfx)
    [~,~,~] = mkdir([resDir filesep sfx]);
%     print('-depsc',[resDir filesep sfx filesep mc '_hist_sim_',listplot{i}(1:end)]);
  else
    [~,~,~] = mkdir([resDir filesep 'free']);
  end;
  
end

if ~isempty(sfx)
  save([resDir filesep sfx filesep 'resdb.mat'],'resdb');
else
  save([resDir filesep 'free' filesep 'resdb_free.mat'],'resdb');
end

x.pagebreak;
x.matrix('Mean of error',mea(rowIndex,:),'rownames',rowNames,'colnames',listqua,'format','%.2f');
x.pagebreak;
x.matrix('Std of error',sta(rowIndex,:),'rownames',rowNames,'colnames',listqua,'format','%.2f');
x.pagebreak;
x.matrix('Mean squared error',sse(rowIndex,:),'rownames',rowNames, 'colnames',listqua,'format','%.2f');
x.pagebreak;
x.matrix('Root mean squared error',rmse(rowIndex,:),'rownames',rowNames, 'colnames',listqua,'format','%.2f');
x.pagebreak;
rmseR=rmse./rmse_rw;
x.matrix('RMSE comparison to RW',rmseR(rowIndex,:),'rownames',rowNames, 'colnames',listqua,'format','%.2f');

if ~isempty(sfx)
  report_name=['historical_simulations',sfx];
else
  report_name='historical_simulations_free';
end;

x.publish([resDir filesep report_name,'.pdf'],'maketitle',false,'papersize','a4paper','display',false);

disp(' ');
disp('*** Done!');