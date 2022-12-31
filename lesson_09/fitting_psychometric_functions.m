%% Exercises

% Find your own coherence threshold by fitting the Weibull function to your own psychophysical data
% generated in Lesson 4.
% Run 50 trials with a coherence level set at your own threshold and
% see how close the percent correct is to 80%
% What happens when you use different intial parameters when calling 'fit'?
% Try some wild and crazy starting values. You might find some interesting 'fits'.
% This illustrates the need to choose sensible initial values.
% If your function surface is convoluted then a bad set of initial parameters may settle into a 'local minimum'.

%% Exercises 1


x = linspace(.05,1,101);
p.t = .5;
bList = 1:4;
figure(3)
clf
subplot(1,2,1)
y = zeros(length(bList),length(x));
for i=1:length(bList)
    p.b = bList(i);
    y(i,:) = Weibull(p,x);
end
plot(log(x),y')
set(gca,'XTick',log([.1,.2,.4,.8]));
logx2raw;
legend(num2str(bList'),'Location','NorthWest');
xlabel('Intensity');
ylabel('Proportion Correct');
title('Varying b with t=0.3');

p.b = 2;
tList = [.1,.2,.4,.8];
subplot(1,2,2)
y = zeros(length(tList),length(x));
for i=1:length(tList)
    p.t = tList(i);
    y(i,:) = Weibull(p,x);
end
plot(log(x),y')

legend(num2str(tList'),'Location','NorthWest');
xlabel('Intensity');
ylabel('Proportion Correct');
set(gca,'XTick',log(tList));
logx2raw
title('Varying t with b=2');

%% 
load resultsStaircase1
% Strip out the trials where there was an invalid response (if there are any).
 
goodTrials = ~isnan(results.response);
results.response = results.response(goodTrials);
results.intensity = results.intensity(goodTrials);

figure(3)
plotPsycho(results,'Coherence');

%% 

pGuess.t =0.125;
pGuess.b = 2;

x = exp(linspace(log(min(results.intensity)),log(max(results.intensity)),101));

%x = logspace(log(min(results.intensity)),log(max(results.intensity)),101);
y= Weibull(pGuess,x);

hold on

plot(log(x),y*100,'r-','LineWidth',2);

y = Weibull(pGuess,results.intensity);
y = y*.99+.005;
fitPsychometricFunction(pGuess,results,'Weibull');

pBetter.t =0.125;
pBetter.b = 3;
fitPsychometricFunction(pBetter,results,'Weibull');


y = Weibull(pBetter,x);
hold on
plot(log(x),100*y,'y-','LineWidth',2);


bList = linspace(0,4,31);
tList = exp(linspace(log(.05),log(0.25),31));

% Loop through the lists in a nested loop to evaluate the log likelihood
% for all possible pairs of values of b and t.

logLikelihoodSurface = zeros(length(bList),length(tList));

for i=1:length(bList)
    for j=1:length(tList)
        p.b = bList(i);
        p.t = tList(j);
        y = Weibull(p,results.intensity);
        logLikelihoodSurface(i,j) = fitPsychometricFunction(p,results,'Weibull');
    end
end

figure(4)
clf
contour(log(tList),bList,logLikelihoodSurface,linspace(20,30,50))
xlabel('t');
ylabel('b');
logx2raw(exp(1),2);

%
% We can plot the most recent set of parameters as a symbol on this contour
% plot.  

hold on
plot(log(pGuess.t),pGuess.b,'o','MarkerFaceColor','r');
plot(log(pBetter.t),pBetter.b,'o','MarkerFaceColor','y');


% Starting parameters
pInit.t = .125;
pInit.b = 3;

[pBest,logLikelihoodBest] = fit('fitPsychometricFunction',pInit,{'b','t'},results,'Weibull')

%
% Note that the parameters changed from the initial values, and the
% resulting log likelihood is lower than the two used earlier (using
% 'pGuess and pBetter'.  Let's plot the best-fitting parameters on the
% contour plot in green:

plot(log(pBest.t),pBest.b,'o','MarkerFaceColor','g');

%
% See how this best-fitting pair of parameters falls in the middle of the
% circular-shaped contour.  This is the lowest point on the surface.  
%
% We now have the best fitting parameters.  Let's draw the best predictions
% in green on top of the psychometric function data:

y = Weibull(pBest,x);
figure(3)
plot(log(x),100*y,'g-','LineWidth',2);

%
% By design, the parameter 't' is the stimulus intensity that should
% predict 80% correct performance.  We'll put the threshold in the title of
% the figure

title(sprintf('Coherence thresold: %5.4f',pBest.t));

%
% We can demonstrate this by drawing a horizontal line at ~80% correct to
% the curve and down to the threshold value on the x-axis:

plot(log([min(x),pBest.t,pBest.t]),100*(1/2)^(1/3)*[1,1,0],'k-');

% Fixed and free parameters.
%
% Suppose for some reason we want to find the threshold while fixing the
% slope to be 3.  With 'fit' it's easy - all we do is change the list of
% 'free' parameters (the third argument sent to 'fit'):

% Initial parameters
pInit.t = .3;
pInit.b = 4;
[pBest,logLikelihoodBest] = fit('fitPsychometricFunction',pInit,{'t'},results,'Weibull')

%
% We can show this on the contour plot.  The threshold will be the
% best-fitting value along the horizontal line where b=1:

figure(4)
plot(log([min(tList),max(tList)]),pBest.b*[1,1],'k-')
plot(log(pBest.t),pBest.b,'ko','MarkerFaceColor','m');



%% 

% What happens when you use different intial parameters when calling 'fit'?
% Try some wild and crazy starting values. You might find some interesting 'fits'.
% This illustrates the need to choose sensible initial values.
% If your function surface is convoluted then a bad set of initial parameters may settle into a 'local minimum'.












