
%% TP

clear;

%% Data (Observed Variables)
k1 = 3;
n1 = 10;
k2 = 4;
n2 = 10;
k3 = 10;
n3 = 10;

%% Sampling
% MCMC Parameters
nchains = 1; % How Many Chains?
nburnin = 1e2; % How Many Burn-in Samples?
nsamples = 5e4;  %How Many Recorded Samples?
nthin = 1; % How Often is a Sample Recorded?
doparallel = 0; % Parallel Option

% Assign Matlab Variables to the Observed Nodes
datastruct = struct('k1',k1,'n1',n1,'k2',k2,'n2',n2,'k3',k3,'n3',n3);

%Initialize Unobserved Variables
for i=1:nchains
    S.theta1 = 0.5; % An Initial Value for the Success Rate
    S.theta2 = 0.5;
    S.theta3 = 0.5;
    init0(i) = S;
end


% Use JAGS to Sample
tic
fprintf( 'Running JAGS ...\n' );
[samples, stats] = matjags( ...
	datastruct, ...
	fullfile(pwd, 'model.txt'), ...
	init0, ...
	'doparallel' , doparallel, ...
	'nchains', nchains,...
	'nburnin', nburnin,...
	'nsamples', nsamples, ...
	'thin', nthin, ...
	'monitorparams', {'theta1', 'theta2', 'theta3'}, ...
	'savejagsoutput' , 1 , ...
	'verbosity' , 1 , ...
	'cleanup' , 0 , ...
	'workingdir' , 'tmpjags' );
toc

%Grafico los resultados

theta1 = samples.theta1();
theta2 = samples.theta2();
theta3 = samples.theta3();

histogram(theta1, 'Normalization', 'probability')
hold on
%histogram(theta2, 'Normalization', 'pdf')
hold on
%histogram(theta3, 'Normalization', 'pdf')
% mean(theta1)
% mean(theta2)
% mean(theta3)



% 
% figure(3);clf;hold on;
% eps = .01; binsc = eps/2:eps:1-eps/2; binse = 0:eps:1;
% count = histc(reshape(samples.theta,1,[]),binse);
% count = count(1:end-1);
% count = count/sum(count)/eps;
% ph = plot(binsc,count,'k-');
% set(gca,'box','on','fontsize',14,'xtick',[0:.2:1],'ytick',[1:ceil(max(get(gca,'ylim')))]);
% xlabel('Rate','fontsize',16);
% ylabel('Posterior Density','fontsize',16);
