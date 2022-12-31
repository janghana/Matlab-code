%% Exersises
%
% 1. # Try changing 'myStatistic' to something less 'normal'.  For example,
% 'myStatistic = @(x) abs(mean(x)) is highly skewed.  How does the analysis
% change? What sort of crazy statistics can you make up?  
% % 
clear all
myStatistic = @(x) abs(mean(x))
n = 25;        %size of each data set
nReps = 2000;  %number of data sets or 'experiments'

data = randn(n,nReps);  %n x nReps draws from unit normal probability distribution

populationStat = zeros(1,nReps);
for i=1:nReps
    %Calculate our statistic on each column in 'data'
    populationStat(i) = myStatistic(data(:,i));
end
if strcmp(func2str(myStatistic),'mean')
    disp(sprintf('Expected s.d.: %g, Actual s.d.: %5.3f',1/sqrt(n),std(populationStat)));
end
figure(1)
clf
hist(populationStat,50)  %50 bins
xlabel(func2str(myStatistic));
title('Samples drawn from the population');




%% 2. # Bootstrapping from a single sample of only 25 numbers is pushing the lower
% limit.  Try using a sample of 100 numbers instead and see if the
% percentage of rejections of the null hypothesis gets closer to 5%.

clear all
n = 100;        %size of each data set
myStatistic = @mean;

nReps = 2000;  %number of data sets or 'experiments'

data = randn(n,nReps);  %n x nReps draws from unit normal probability distribution

populationStat = zeros(1,nReps);
for i=1:nReps
    %Calculate our statistic on each column in 'data'
    populationStat(i) = myStatistic(data(:,i));
end
if strcmp(func2str(myStatistic),'mean')
    disp(sprintf('Expected s.d.: %g, Actual s.d.: %5.3f',1/sqrt(n),std(populationStat)));
end

CIrange = 100*(NormalCumulative(1,0,1) - NormalCumulative(-1,0,1))

populationCI = prctile(populationStat,[50-CIrange/2,50+CIrange/2])


x = randn(1,n);
sampleStat = myStatistic(x);

id = ceil(rand(n,nReps)*n);

bootstrapData = x(id);

bootstrapStat = zeros(1,nReps);
for i=1:nReps
    bootstrapStat(i) = myStatistic(bootstrapData(:,i));
end
figure(2)
clf
hist(bootstrapStat,50)  %50 bins
xlabel(func2str(myStatistic))
title('Samples re-drawn from a single sample');

bootstrapCI = prctile(bootstrapStat,[50-CIrange/2,50+CIrange/2]);

hold on
ylim = get(gca,'YLim');
h1=plot(bootstrapCI(1)*[1,1],ylim*1.05,'g-','LineWidth',2);
plot(bootstrapCI(2)*[1,1],ylim*1.05,'g-','LineWidth',2);

plot(sampleStat*[1,1],ylim*1.05,'r-','LineWidth',2);

bootstrapCI = bootstrap(myStatistic,x,nReps,CIrange);

h2=plot(bootstrapCI(1)*[1,1],ylim*1.05,'y-','LineWidth',2);
plot(bootstrapCI(2)*[1,1],ylim*1.05,'y-','LineWidth',2);

legend([h1,h2],{sprintf('original %3.1f%%',CIrange),sprintf('BCa %3.1f%%',CIrange)});

nullStat = mean(populationStat);  %null hypothesis statistic

CIrange = 95;
bootstrapCI = bootstrap(myStatistic,x,nReps,CIrange);

plot(bootstrapCI(1)*[1,1],ylim*1.05,'k-','LineWidth',2);
h3= plot(bootstrapCI(2)*[1,1],ylim*1.05,'k-','LineWidth',2);

legend([h1,h2,h3],{'original','BCa corrected','BCa 95%'});

if nullStat<bootstrapCI(1) || nullStat>bootstrapCI(2)
    str = 'Reject';
else
    str = 'Fail to reject';
end
disp(sprintf('%s the null hypothes at alpha = %5.2f',str,(1-CIrange/100)));


%% 3. # (Advanced) You could try this nonparametric procedure to measure
% variability in the threshold parameter for psychometric function fits.
% For sampling the 2AFC data with replacement, you'll have to sample both
% 'results.intensity' and 'results.response' together.  The 'bootstrap'
% program won't because it isn't written to allow for functions that have
% more than one parameter.  You'll have to either use 'bootci' or modify
% the code in this lesson instead and punt on the 'BCa' correction.








