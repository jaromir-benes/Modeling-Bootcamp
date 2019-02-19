%% Simulate Phillips Curve Shocks

close all
clear
clc

load mat/read_models.mat mb mf m

%% Simulate Phillips Curve Shock in First Period

% Simulate backward-looking model
db = sstatedb(mb, 1:20);
db.eps_pi(1) = 1;
sb = simulate( mb, db, 1:20, ...
               'AppendPresample=', true );
           
% Create a new version of the bwl model with a different beta1
mb1 = mb;
mb1.beta1 = 0.5;
mb1 = solve(mb1);
mb1 = sstate(mb1);

% Simulate the other version of the bwl model
sb1 = simulate( mb1, db, 1:20, ...
               'AppendPresample=', true );
 

% Simulate forward-looking model
df = sstatedb(mf, 1:20);
df.eps_pi(1) = 1;
sf = simulate( mf, df, 1:20, ...
               'AppendPresample=', true );

d = sstatedb(m, 1:20);
d.eps_pi(1) = 1;
s = simulate( m, d, 1:20, ...
              'AppendPresample=', true );

dbplot( sb & sf & s, 0:20, ...
        {'pi', 'y', 'eps_pi'}, ...
        'lineWidth=', 2, ...
        'tight=', true );

%% Simulate Anticipated Shock in Period 10

% Simulate backward-looking model
db = sstatedb(mb, 1:20);
db.eps_pi(10) = 1;
sb = simulate( mb, db, 1:20, ...
               'AppendPresample=', true );
           
% Simulate forward-looking model
df = sstatedb(mf, 1:20);
df.eps_pi(10) = 1;
sf = simulate( mf, df, 1:20, ...
               'AppendPresample=', true );
 
d = sstatedb(m, 1:20);
d.eps_pi(10) = 1;
s = simulate( m, d, 1:20, ...
              'AppendPresample=', true );
          
dbplot( sb & sf & s, 0:20, ...
        {'pi', 'y', 'eps_pi'}, ...
        'lineWidth=', 2, ...
        'tight=', true );

%% Simuate Unanticipated Shock in Period 10

%% Simulate Anticipated Shock That Did Not Occur in the End

