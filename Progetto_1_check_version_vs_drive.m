clear
clc

% loading data


% use readmatrix to read numerical values (our data object)
data = readmatrix('Indexes.xlsx','Sheet','TOTAL','Range','B4');

% use readtable to read the entire file and then extract the first column
input = readtable('Indexes.xlsx','Sheet','TOTAL','ReadVariableNames', false, 'TreatAsEmpty',{'NA'});
input=input(4:end,1);
% trasform date info to datetime format
D=table2array(input);
days=D;

% computing daily returns
Dailyreturns = ((data(2:(size(data,1)),:)./data(1:(size(data,1)-1),:))-1)*100;

% Plotting the benchmark's daily returns
figure
plot (days(2:end,1),Dailyreturns(:,1),'Color','b','Marker','d');
hold on 
title ('Benchmark daily returns since 2006');
xlabel('Time');
ylabel('Daily returns');
hold off

% convert daily into monthly 
pM=[];
dM=[];
% find the first end of month
d1=D(1,:);
for j=2:size(data,1)
    if month(d1)==month(D(j,:))
    else
        d1=D(j-1,:);
        break;
    end
end
%dM=d1;

% loop to build data
for i=j:size(data,1)
    if month(d1)==month(D(i,:))
    else
        pM=[pM; data(i-1,:)];
        dM=[dM; D(i-1,:)];
        d1=D(i,:);
    end
end

% monthly returns
rM=((pM(2:(size(pM,1)),:)./pM(1:(size(pM,1)-1),:))-1)*100;
            r_assets=rM(:,2:25);
            r_benchmark=rM(:,1);
            p_assets=pM(:,2:25);
            p_benchmark=pM(:,1);

dM=dM((end-size(rM,1)+1):end,:);
%dM=dM(2:end,:);

% SUDDIVISIONE asset per classi di maturities
% mat1= 3-5, mat2= 5-7, mat3= 7-10
p_mat1= (pM(:,[2 5 8 11 14 17 20 23]));
p_mat2= (pM(:,[3 6 9 12 15 18 21 24]));
p_mat3= (pM(:,[4 7 10 13 16 19 22 25]));
r_mat1= (rM(:,[2 5 8 11 14 17 20 23]));
r_mat2= (rM(:,[3 6 9 12 15 18 21 24]));
r_mat3= (rM(:,[4 7 10 13 16 19 22 25]));

%% 
a=dM(62);%Monti Governemnt and downgrade of Greece by Fitch
b=dM(99);%QE 

% EVOLUTION OF INDEXES ACROSS TIME
%ALL
figure
subplot(2,1,1);
plot(dM,r_benchmark,'Color', 'r','LineStyle','-.',LineWidth=2);
hold on
xlabel('Time','FontSize',12,'FontWeight','bold')
ylabel('Prices','FontSize',12,'FontWeight','bold')
grid("on")
xline(a,'-',{'Sov. Debt Crisis'});
xline(b,'-',{'QE'});
title ('Monthly returns of Benchmark','FontSize',20,'FontWeight','bold')
hold off

subplot(2,1,2);
plot(dM,r_assets,LineWidth=1);
hold on
xlabel('Time','FontSize',12,'FontWeight','bold')
ylabel('Prices','FontSize',12,'FontWeight','bold')
grid("on")
xline(a,'-',{'Sov. Debt Crisis'});
xline(b,'-',{'QE'});
title ('Monthly returns of all assets','FontSize',20,'FontWeight','bold')
legend('NE 3-5','NE 5-7','NE 7-10','FR 3-5', 'FR 5-7', 'FR 7-10', 'GE 3-5', 'GE 5-7', 'GE 7-10', 'IT 3-5', 'IT 5-7', 'IT 7-10', 'PT 3-5', 'PT 5-7', 'PT 7-10', 'ES 3-5', 'ES 5-7', 'ES 7-10', 'US 3-5', 'US 5-7', 'US 7-10', 'JP 3-5', 'JP 5-7', 'JP 7-10')
legend('Location','northwest')
hold off

%JUST MAT1
figure
subplot(2,2,1);
plot(dM,r_mat1,LineWidth=1.5);
hold on
xlabel('Time','FontSize',12,'FontWeight','bold')
ylabel('Prices','FontSize',12,'FontWeight','bold')
grid("on")
xline(a,'-',{'Sov. Debt Crisis'});
xline(b,'-',{'QE'});
title ('Monthly returns of 3-5 Years Maturity Assets','FontSize',20,'FontWeight','bold')
legend('NE','FR','GE','IT','PT','ES','US','JP')
legend('Location','northwest')
hold off

%JUST MAT2
subplot(2,2,2);
plot(dM,r_mat2,LineWidth=1.5);
hold on
xlabel('Time','FontSize',12,'FontWeight','bold')
ylabel('Prices','FontSize',12,'FontWeight','bold')
grid("on")
xline(a,'-',{'Sov. Debt Crisis'});
xline(b,'-',{'QE'});
title ('Monthly returns of 5-7 Years Maturity Assets','FontSize',20,'FontWeight','bold')
legend('NE','FR','GE','IT','PT','ES','US','JP')
legend('Location','northwest')
hold off

%JUST MAT3
subplot(2,2,3);
plot(dM,r_mat3,LineWidth=1.5);
hold on 
xlabel('Time','FontSize',12,'FontWeight','bold')
ylabel('Prices','FontSize',12,'FontWeight','bold')
grid("on")
xline(a,'-',{'Sov. Debt Crisis'});
xline(b,'-',{'QE'});
title ('Monthly returns of 7-10 Years Maturity Assets','FontSize',20,'FontWeight','bold')
legend('NE','FR','GE','IT','PT','ES','US','JP')
legend('Location','northwest')
hold off

%%

% names
lab={ 'EU 5-7 Years','Netherlands 3-5' 'Netherlands 5-7' 'Netherlands 7-10' 'France 3-5' 'France 5-7' 'France 7-10' 'Germany 3-5' 'Germany 5-7' 'Germany 7-10' 'Italy 3-5' 'Italy 5-7' 'Italy 7-10' 'Portugal 3-5' 'Portugal 5-7' 'Portugal 7-10' 'Spain 3-5' 'Spain 5-7' 'Spain 7-10' 'USA 3-5' 'USA 5-7' 'USA 7-10' 'Japan 3-5' 'Japan 5-7' 'Japan 7-10' };
AvgMreturns=mean(rM(:,2:25));
% grafico a barre per mostrare il rendimento medio dei diversi asset
figure
bar(1:24,AvgMreturns);
title 'Average monthly returns'
set(gca,'Xtick',1:24,'XTickLabel',lab(2:25));
%set(gca,'XTickLabel',lab(2:25));

% covariance matrix
MVariance=cov(rM(:,2:25));
% grafico a barre per mostrare la variabilità media dei diversi asset
figure
bar(1:24,sqrt(diag(MVariance)));
title 'Average std deviation'
set(gca,'Xtick',1:24,'XTickLabel',lab(2:25));

% computing relevant scalars
A=(AvgMreturns/MVariance)*(AvgMreturns'); %A=MM*(MV\MM');
B=(AvgMreturns/MVariance)*ones(length(AvgMreturns),1); % because MV is symmetric
% B=ones(length(MM),1)'*inv(MV)*MM';
C=(ones(1,length(AvgMreturns))/MVariance)*ones(length(AvgMreturns),1);
D=A*C-B*B;

% Global Minimum Variance portfolio: weights, mean, stdev
wGMV=(MVariance\ones(size(MVariance,1),1))/sum(MVariance\ones(size(MVariance,1),1));
% rGMV=MM*wGMV;
rGMV=B/C;
% sGMV=sqrt((wGMV')*MV*wGMV);
% sGMV=1/sqrt(sum((MV)\ones(size(MV,1),1)));
sGMV=1/sqrt(C);


figure;
bar(1:24,wGMV);
title 'Weight of GMV Portfolio'
set(gca,'Xtick',1:24,'XTickLabel',lab(2:25));

% Maximum trade-off portfolio: weights, mean, stdev
wTAN=(MVariance\AvgMreturns')/sum(MVariance\AvgMreturns');
%wTAN=(inv(MV'*MV)*MV'*MM')/sum(inv(MV'*MV)*MV'*MM');
%rTAN=sum(MM*wTAN);
rTAN=A/B;
%sTAN=sqrt((wTAN')*MV*wTAN);
sTAN=sqrt(A)/abs(B);

figure;
bar(1:24,wTAN);
title 'Weights of Tangency Portfolio'
set(gca,'Xtick',1:24,'XTickLabel',lab(2:25));


% number of points
nport=100;
% lower return limit is rGMV
% max return limit is set at 5 times the rGMV
rmin=rGMV;
rmax=rGMV*5;
rr=zeros(nport+1,1);
rs=zeros(nport+1,1);
rr(1)=rGMV;
rs(1)=sGMV;
rstep=(rmax-rmin)/nport;
for j=1:nport
    rr(j+1)=rr(j)+rstep;
    rs(j+1)=sqrt((C/D)*(rr(j+1)^2)-2*(B/D)*rr(j+1)+(A/D));
end

% plot the EF
figure
plot(rs,rr)
title 'Efficient Frontier'
% add GMV and T portfolios
hold on 
scatter(sGMV,rGMV,'filled','r')
scatter(sTAN,rTAN,'filled','g')
scatter(sqrt(diag(MVariance)),AvgMreturns,'filled','k')
hold off

save Progetto_pt1.mat;
