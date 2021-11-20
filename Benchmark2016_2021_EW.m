clear
clc
    load Progetto_pt1.mat
    load Equilibrium.mat
    load Rolling_EWMA.mat

 %% EF Unconstrained Portfolio
 
 nport=100;
 p= Portfolio ('AssetList', lab(:,2:25),'LowerBound',-1,'UpperBound',1);
 p = estimateAssetMoments(p,r_assets(120:end,:));
 figure
 plotFrontier(p);
 hold on
 title 'Unconstrained EF - Base benchmark'
 scatter(EWVol_b,EWMean_b,LineWidth=3);
 lgd=legend('Unconstrained EF','Base Benchmark',Location='east');
 xlim([-0.5 10]);
 ylim([-0.5 3]);
 hold off

%% Equally weighted portfolio

pEW=Portfolio(p,'InitPort',1/p.NumAssets);
figure
pEW.plotFrontier(nport);
hold on
title 'Efficient Frontier - Equally weighted Benchmark'
xlim([-0.5 5]);
ylim([-0.5 3]);
hold off

%% EF with both Base Benchmark and EW Benchmark

pEW=Portfolio(p,'InitPort',1/p.NumAssets);
figure
pEW.plotFrontier(nport);
hold on
title 'EF - Comparison btw Base Bench and EW Bench'
scatter(EWVol_b,EWMean_b,LineWidth=3,DisplayName='Base benchmark');
xlim([-0.5 3]);
ylim([-0.5 2]);
hold off

%% No short selling 

 nport=100;
 pNSS= Portfolio ('AssetList', lab(:,2:25),'LowerBound',0,'UpperBound',1);
 pNSS = estimateAssetMoments(pNSS, r_assets(120:end,:));
 figure
 plotFrontier(pNSS);
 hold on
 title 'Efficient Frontier No Short Selling - Base benchmark'
 scatter(EWVol_b,EWMean_b,LineWidth=3);
 lgd=legend('Efficient Frontier no SS','Initial Benchmark');
 xlim([-0.5 5]);
 ylim([-0.5 3]);
 hold off

%% Equilibrium EF

 figure
 plotFrontier(pEq);
 hold on
 title 'Equilibrium Efficient Frontier 2016-2021'
 scatter(EWVol_b,EWMean_b,LineWidth=3);
 legend('Equilibrium EF','Benchmark',Location='best');
 hold off

 %% Overall comparison of EFs

 figure 
 pEW.plotFrontier(nport); hold on; 
 plotFrontier(p);
 plotFrontier(pEq);
 plotFrontier(pNSS);
 scatter(EWVol_b,EWMean_b,LineWidth=3);
 title 'Different Efficient Frontiers';
 legend('EW benchmark','EW EF','Unconstrained EF','Equilibrium EF','No SS EF','Base Benchmark',Location='best');
 xlim([-0.5 5]);
 ylim([-0.5 3]);
 hold off

 save Benchmark_2016-2021_EW.mat