function [CI,sampleStat] = bootstrapWeibullThreshold(results,pInit,nReps,CIRange,BCFlag)
% [CI,sampleStat] = bootstrapWeibullThreshold(results,pInit,nReps,CIRange,BCFlag)
if ~exist('BCFlag')
    BCFlag = 1;  %use bias accellerated by default
end

if ~exist('alphaCrit')
    CIrange = 68.27;  %corresponds to +/- 1 s.d. for a normal distribution
end

if ~exist('nReps')
    nReps=2000;
end

% Save the 'intensity' values
x = results.intensity;
n = length(x);

% Turn off fit's output to the command window
pInit.shutup = 1;

% Calculate the threshold for the original data
freeList ={'t','b'};
pBest = fit('fitPsychometricFunction',pInit,freeList,results,'Weibull');

% Save the threshold
sampleStat = pBest.t;

% Evaluate the best-fitting Weibull function at the intensity values
prob = Weibull(pBest,x);

bootResults.intensity = results.intensity;
bootstrapStat=  zeros(1,nReps);

% set up the 'waitbar'
h = waitbar(0,sprintf('Step 1: Bootstrapping with %d fits',nReps));

% Loop through nReps times, calling 'fit' with a new parametrically sampled
% data set
for i=1:nReps
    %generate a 'fake' set of responses based on the binary process
    bootResults.response = floor(rand(size(x))+prob);
    %fit the 'fake' data set and store the threshold
    [pBootBest,logLikelihoodBest] = fit('fitPsychometricFunction',pBest,freeList,bootResults,'Weibull');
    bootstrapStat(i) = pBootBest.t;
        % update the 'waitbar'
    waitbar(i/nReps,h)
end
%remove the waitbar
delete(h);

%% Generate the 'bias-corrected and accelerated' parameters z0 and a


if BCFlag
    z0 = inverseNormalCDF(sum(bootstrapStat<sampleStat)/nReps);
    thetai = zeros(1,n);
    h = waitbar(0,'Step 2: bias corrected and accelerated algorithm');
    for i=1:n
        id = [1:(i-1),(i+1):n];
        resultsi.intensity = results.intensity(id);
        resultsi.response = results.response(id);
        pBesti = fit('fitPsychometricFunction',pBest,freeList,resultsi,'Weibull');
        thetai(i) = pBesti.t;
                % update the 'waitbar'
    waitbar(i/n,h)
    end
    delete(h)
    a = sum( (mean(thetai)-thetai).^3)/(6*(sum( (mean(thetai)-thetai).^2).^(3/2)));
    
else
    z0 =0;
    a=0;
end

%% Calculate the 'bias-corrected and accelerated' percentiles

zLo = inverseNormalCDF((1-CIrange/100)/2);
zHi = inverseNormalCDF((1+CIrange/100)/2);

zClo = z0 + (z0+zLo)/(1-a*(z0+zLo));
bcaLo = NormalCumulative(zClo,0,1);

zChi = z0 + (z0+zHi)/(1-a*(z0+zHi));
bcaHi = NormalCumulative(zChi,0,1);

CI(1) = prctile(bootstrapStat,100*bcaLo);
CI(2) = prctile(bootstrapStat,100*bcaHi);