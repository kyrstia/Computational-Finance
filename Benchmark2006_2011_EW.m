clear
clc
    load Progetto_pt1.mat
    load Equilibrium.mat
    load Rolling_EWMA.mat

 %% EF Unconstrained Portfolio
 
 nport=100;
 pp= Portfolio ('AssetList', lab(:,2:25),'LowerBound',-1,'UpperBound',1);
 pp = estimateAssetMoments(pp,r_assets(1:60,:));
 figure
 plotFrontier(pp);
 hold on
 title 'Unconstrained Efficient Frontier - Base benchmark'
 scatter(EWVol_b_0611, EWMean_b_0611, LineWidth=3);
 lgd=legend('Unconstrained Efficient Frontier','Base Benchmark',Location='best');
 xlim([-0.5 10]);
 ylim([-0.5 3]);
 hold off

%% Equally weighted portfolio

ppEW=Portfolio(pp,'InitPort',1/pp.NumAssets);
figure
ppEW.plotFrontier(nport);
hold on
title 'Efficient Frontier - Equally weighted Benchmark'
xlim([-0.5 5]);
ylim([-0.5 3]);
hold off

%% EF with both Base Benchmark and EW Benchmark

ppEW=Portfolio(pp,'InitPort',1/pp.NumAssets);
figure
ppEW.plotFrontier(nport);
hold on
title 'EF - Comparison btw Base Bench and EW Bench'
scatter(EWVol_b_0611,EWMean_b_0611,LineWidth=3,DisplayName='Base benchmark');
xlim([-0.5 3]);
ylim([-0.5 2]);
hold off

%% No short selling 
 
 nport=100;
 ppNSS= Portfolio ('AssetList', lab(:,2:25),'LowerBound',0,'UpperBound',1);
 ppNSS = estimateAssetMoments(ppNSS, r_assets(1:60,:));
 figure
 plotFrontier(ppNSS);
 hold on
 title 'Efficient Frontier No Short Selling - Base benchmark'
 scatter(EWVol_b_0611,EWMean_b_0611,LineWidth=3);
 legend('Efficient Frontier no SS','Initial Benchmark');
 xlim([-0.5 5]);
 ylim([-0.5 3]);
 hold off
 
 %% Equilibrium EF
 
 figure
 plotFrontier(pEq2);
 hold on
 title 'Equilibrium Efficient Frontier 2006-2011'
 scatter(EWVol_b_0611,EWMean_b_0611,LineWidth=3);
 legend('Equilibrium EF','Benchmark',Location='best');
 hold off

 %% Overall comparison of EFs
 
 figure 
 ppEW.plotFrontier(nport); hold on; 
 plotFrontier(pp);
 plotFrontier(pEq2);
 plotFrontier(ppNSS);
 scatter(EWVol_b_0611,EWMean_b_0611,LineWidth=3);
 title 'Different Efficient Frontiers';
 legend('EW benchmark','EW EF','Unconstrained EF','Equilibrium EF','No SS EF','Base Benchmark',Location='best');
 xlim([-0.5 5]);
 ylim([-0.5 3]);
 hold off

 save Benchmark_2006-2011_EW.mat