%%
clear
clc
    load Progetto_pt1.mat
    
%% EQUILIBRIUM

history = readmatrix('Indexes.xlsx','Sheet','Historical Benchmark','Range',['B4']);
input2 = readtable('Indexes.xlsx','Sheet','Historical Benchmark','DatetimeType','datetime','Range','A4:A5967');
% trasform date info to datetime format
D2=table2array(input2);
days2=D2;

pM2=[];
dM2=[];

% find the first end of month
dhist=D2(1,:);
for j=1:size(history,1)
    if month(dhist)==month(D2(j,:))
    else
        dhist=D2(j-1,:);
        break;
    end
end

% loop to build data
for i=j:size(history,1)
    if month(dhist)==month(D2(i,:))
    else
        pM2=[pM2; history(i-1,:)];
        dM2=[dM2; D2(i-1,:)];
        dhist=D2(i,:);
    end
end

% monthly returns
rM2=((pM2(2:(size(pM2,1)),:)./pM2(1:(size(pM2,1)-1),:))-1)*100;
            
dM2=dM2((end-size(rM2,1)+1):end,:);

% Historical monthly avg return and covariance matrix of our benchmark
r_meq = mean(rM2);
var_meq = var(rM2);

%% 2016-2021

m_benchmark = mean(r_benchmark(120:end,:));
std_benchmark = sqrt(var(r_benchmark(120:end,:)));

%% Compute equilibrium moments

alpha=zeros(size(r_assets(120:end,:),2),1);              % alpha
beta=zeros(size(r_assets(120:end,:),2),1);               % beta
r2=zeros(size(r_assets(120:end,:),2),1);                 % r-squared
eqret=zeros(size(r_assets(120:end,:),2),1);              % equilibrium return
resid=zeros(size(r_assets(120:end,:),1), ...
    size(r_assets(120:end,:),2));                        % residuals

for i=1:size(r_assets(120:end,:),2)
    out=regstats(r_assets(120:end,i),r_benchmark(120:end,:),'linear',{'beta','r','rsquare','tstat'});
    % storing
    alpha(i,1)=out.beta(1);
    beta(i,1)=out.beta(2);
    r2(i,1)=out.rsquare;
    resid(:,i)=out.r;
    eqret(i,1)=out.beta(2)*(r_meq);
end

% compute optimal portfolios by means of equilibrium returns
MMe=eqret';
MVe=beta*(beta')*var_meq+diag(diag(cov(resid)));

%% Equilibrium EF
nport=100;
 pEq= Portfolio ('AssetList', lab(:,2:25));
 pEq= pEq.setDefaultConstraints;
 pEq = pEq.setAssetMoments(MMe, MVe);
 figure
 plotFrontier(pEq);
 hold on
 title 'Equilibrium Efficient Frontier 2016-2021'
 scatter(std_benchmark,m_benchmark,LineWidth=3);
 legend('Equilibrium EF','Benchmark',Location='best');
 hold off

 %% 2006-2011

 m_benchmark2 = mean(r_benchmark(1:60,:));
 std_benchmark2 = sqrt(var(r_benchmark(1:60,:)));

%% Compute equilibrium moments

alpha2=zeros(size(r_assets(1:60,:),2),1);              % alpha
beta2=zeros(size(r_assets(1:60,:),2),1);               % beta
r2_=zeros(size(r_assets(1:60,:),2),1);                 % r-squared
eqret2=zeros(size(r_assets(1:60,:),2),1);              % equilibrium return
resid2=zeros(size(r_assets(1:60,:),1), ...
    size(r_assets(1:60,:),2));                        % residuals

for i=1:size(r_assets(1:60,:),2)
    out2=regstats(r_assets(1:60,i),r_benchmark(1:60,:),'linear',{'beta','r','rsquare','tstat'});
    % storing
    alpha2(i,1)=out2.beta(1);
    beta2(i,1)=out2.beta(2);
    r2_(i,1)=out2.rsquare;
    resid2(:,i)=out2.r;
    eqret2(i,1)=out2.beta(2)*(r_meq);
end

% compute optimal portfolios by means of equilibrium returns
MMe2=eqret2';
MVe2=beta2*(beta2')*var_meq+diag(diag(cov(resid2)));

%% Equilibrium EF
nport=100;
 pEq2= Portfolio ('AssetList', lab(:,2:25));
 pEq2= pEq2.setDefaultConstraints;
 pEq2 = pEq2.setAssetMoments(MMe2, MVe2);
 figure
 plotFrontier(pEq2);
 hold on
 title 'Equilibrium Efficient Frontier 2006-2011'
 scatter(std_benchmark2,m_benchmark2,LineWidth=3);
 legend('Equilibrium EF','Benchmark',Location='best');
 hold off

 save Equilibrium.mat