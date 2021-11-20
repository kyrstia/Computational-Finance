clear
clc

load Progetto_pt1.mat;

w=60;
%5years simulation for benchmark (last 5 years)
CR_bench=cumprod(r_benchmark(120:end,1)/100+1)-1;

%5years simulation for EW portfolio (last 5 years: 2016-2021)
[r,c]=size(r_assets);
PortRetEW=zeros(w,1); 
for j=120:179
    PortRetEW(j-119,1)=mean(r_assets(j,:));
end
CR_EW=cumprod(PortRetEW(:,1)/100+1)-1;

%Plot
figure
plot(dM(120:end),CR_bench,'Color', 'r','LineStyle','-.',LineWidth=2);
hold on
plot(dM(120:end),CR_EW,'Color', 'b','LineStyle','-.',LineWidth=2);
lgd=legend('Benchmark','EW portfolio');
xlabel('Time','FontSize',12,'FontWeight','bold')
ylabel('Cumulated returns','FontSize',12,'FontWeight','bold')
grid("on")
title ('Cumulated returns - 2017-2021','FontSize',20,'FontWeight','bold')
hold off

