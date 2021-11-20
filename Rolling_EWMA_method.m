clear
clc

load Progetto_pt1.mat;

% sample moments (mean, covariance, standard deviation) with ROLLING METHOD:
% benchmark+assets
% rM includes the monthly returns (the first col is the market index which we
% exclude)
w=60;   % size of the window 
ncol=25; % nb of columns=>to avoid changing one by one ncol->25

% pre-allocating for mean, covariance and standard deviation
rollMean=zeros(size(rM,1)-w,size(rM,2)); %size(rM,2) because we include the benchmark
rollVar=zeros(size(rM,1)-w,size(rM,2),size(rM,2)); 
    
for j=w:(size(rM,1)-1)
    rollMean(j-w+1,:)=mean(rM(j-w+1:j,1:size(rM,2)));
    rollVar(j-w+1,:,:)=cov(rM(j-w+1:j,1:size(rM,2))); 
end


%plot rolling expected volatilities: *con la loop di sopra?*
rollVol=zeros(size(rollMean));
for j=1:(size(rollMean,2))
    rollVol(:,j)=sqrt(rollVar(:,j,j));%POSSIBLE TO USE a submatrix and diag?
end



% sample moments (mean, covariance,standard deviation) with EWMA method:benchmark+assets
lambda=0.9; % smoothing factor

% pre-allocating for mean and covariance
EWMean=zeros(size(rM,1)-w,size(rM,2)); 
EWVar=zeros(size(rM,1)-w,size(rM,2),size(rM,2)); 
    
% initialization with sample moments of the first rolling sample
EWMean(1,:)=mean(rM(1:w,1:size(rM,2))); %use the first 60 rows and col 2 to 16 because we exclude the eur market
EWVar(1,:,:)=cov(rM(1:w,1:size(rM,2)));
for j=(w+1):(size(rM,1)) %see formula in the slides
    EWMean(j-w+1,:)=lambda*EWMean(j-w,:)+(1-lambda)*rM(j,1:size(rM,2));
    EWVar(j-w+1,:,:)=lambda*squeeze(EWVar(j-w,:,:))+(1-lambda)*(rM(j,1:size(rM,2))'*rM(j,1:size(rM,2)));
end

EWVol=zeros(size(EWMean));
for j=1:(size(EWMean,2))
    EWVol(:,j)=sqrt(EWVar(:,j,j));%POSSIBLE TO USE a submatrix and diag?
end

%rolling moments benchmark - last 5 years - 2016-2021
rollMean_b=rollMean(size(rollMean,2),1);
rollVol_b=rollVol(size(rollVol,2),1);

%rolling moments benchmark 2006-2011
rollMean_b_0611=rollMean(1,1);
rollVol_b_0611=rollVol(1,1);

%EWMA moments benchmark - 2006-2011
EWMean_b_0611=EWMean(1,1);
EWVol_b_0611=EWVol(1,1);

%EWMA moments benchmark - last 5 years - 2016-2021
EWMean_b=EWMean(w,1);
EWVol_b=EWVol(w,1);


save Rolling_EWMA.mat;




















