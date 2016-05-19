%% TP

clear;
modelo = 1; %1 = primer model, 2 = modelo modificado

modelo_txt = '';

if modelo == 1
    modelo_txt = 'model.txt';
else
    modelo_txt = 'model2.txt';
end

%%                                                                                                      Data (Observed Variables)
k = [3, 4, 10];
n = 10;
m = 3; %cantidad de monedas

%% Sampling
% MCMC Parameters
nchains = 1; % How Many Chains?
nburnin = 1e2; % How Many Burn-in Samples?
nsamples = 5e4;  %How Many Recorded Samples?
nthin = 1; % How Often is a Sample Recorded?
doparallel = 0; % Parallel Option

% Assign Matlab Variables to the Observed Nodes
datastruct = struct('k', k, 'n', n, 'm', m);

%Initialize Unobserved Variables
for i=1:nchains
    if modelo == 1
        S.c = 1/3;
    else
        S.c = round(rand(1,m));
    end
        
    init0(i) = S;
end


% Use JAGS to Sample
tic
fprintf( 'Running JAGS ...\n' );
[samples, stats] = matjags( ...
	datastruct, ...
	fullfile(pwd, modelo_txt), ...
	init0, ...
	'doparallel' , doparallel, ...
	'nchains', nchains,...
	'nburnin', nburnin,...
	'nsamples', nsamples, ...
	'thin', nthin, ...
	'monitorparams', {'c', 'theta'}, ...
	'savejagsoutput' , 1 , ...
	'verbosity' , 1 , ...
	'cleanup' , 0 , ...
	'workingdir' , 'tmpjags' );
toc

%Grafico los resultados
%separar para modelo 1 y 2

theta1 = samples.theta(:,:,1);
theta2 = samples.theta(:,:,2);
theta3 = samples.theta(:,:,3);
c = samples.c();
 
a = ordinal(c, {'moneda 1', 'moneda 2', 'moneda 3'});
histogram(a, 'Normalization', 'probability');

% histogram(theta1, 'Normalization', 'probability');
% hold on
% histogram(theta2, 'Normalization', 'probability');
% hold on
% histogram(theta3, 'Normalization', 'probability')

 

