%% Exercises

% Generate your own psychometric function for coherernce
% by running the 3-down 1-up staircase method on yourself.
% Plot the staircase and the psychometric function like we did here.
% Save the results in a file called 'results.mat' (save results results)

% Small step sizes are useful to adequately sample the range of intensities,
% but if the step sizes are too small, the staircase may never get down
% (or up) to the threshold. One way to fix this is to have the step
% sizes start out large in the beginning of the staircase.
% Write a version of the 3-down 1-up staircase method where the step sizes
% are 0.2 for the first 10 trials an then drop to 0.1 for the remaining 35.

% What percent correct should a staircase converge to
% if you did a 2-down 1-up staircase?
% You might have noticed that you can predict how difficult the next trial
% will be based on your recent performance - e.g.
% after making a mistake the next trial may be noticeably easier.
% This predictability can be reduced by using a 'double staircase' method
% where two staircases are run in parallel. Modify the code above with
% two staircases, each with 30 trials each where intensity for
% each trial is determined randomly from one of the two staircases.
% Hint: you'll have to keep track of two different 'correctInaRow' values
% and coherence values but you can store the results in the same structure
% as before.

% Modify the code to calculate your 'speed discrimination' psychometric
% function using a 'two-interval forced-choice procedure'.
% Each trial will consist of two successive stimuli instead of one.
% One interval will have dots set to the 'baseline' speed (5 deg/sec).
% The second will be set to that speed plus an increment.
% The order will be randomized on each trial and the task for
% the subject is to determine which interval
% '1' or '2' has the faster speed. Adjust the increment
% in a 3-down 1-up staircase. You'll have to choose
% your own starting increment and step size to see what works best.

%%

clear all

display.dist = 50;  %cm
display.width = 30; %cm
display.skipChecks = 1; %avoid Screen's timing checks and verbosity

% Insead of a list of coherence values, we'll choose a starting value and a
% step size.  We can choose any number of trials.

design.startingCoherence =  1;
design.stepSize = .5;
design.nTrials = 60;

% We'll use the same timing parameters:
design.stimDur = 1.;           %duration of stimulus (sec)
design.responseInterval = .5;  %window in time to record the subject's response
design.ITI = 1.5;             %inter-trial-interval (time between the start of each trial)

% And we need to define the parameters for the dots
dots.nDots = 200;
dots.speed = 5;
dots.lifetime = 12;
dots.apertureSize = [12,12];
dots.center = [0,0];
dots.color = [255,255,255];
dots.size = 8;
dots.coherence = design.startingCoherence;       %coherence  level for the first trial

% Design a list of directions randomly chosen for each trial
temp = ceil(rand(1,design.nTrials)+.5);  %50/50 chance of a 1 (up) or a 2 (down)
design.directions = (temp-1)*180; %1 -> 0 degrees, 2 -> 180 degrees

%set up a 'results' structure
results.intensity = NaN*ones(1,design.nTrials);  %to  be filled in after each trial
results.response = NaN*ones(1,design.nTrials);   %to  be filled in after each trial

%this parameter keeps track of the number of correct responses in a row
correctInaRow = 0;

%Let's open the screen and get going!
try
    display = OpenWindow(display);

    drawText(display,[0,6],'Press "u" for up and "d" for down',[255,255,255]);
    drawText(display,[0,5],'Press Any Key to Begin.',[255,255,255]);

    display = drawFixation(display);

    while KbCheck; end
    KbWait;

    %record the clock time at the beginning
    startTime = GetSecs;
    %loop through the trials
    for trialNum = 1:design.nTrials
        %set the coherence level and the direction for this trial
        dots.direction = design.directions(trialNum);
        
        %Show the stimulus
        movingDots(display,dots,design.stimDur);

        %Get the response within the first second after the stimulus
        keys = waitTill(design.responseInterval);

        %Interpret the response provide feedback and deal with
        results.intensity(trialNum) = dots.coherence;

        if isempty(keys)  %No key was pressed, yellow fixation
            correct = NaN;
            display.fixation.color{1} = [255,255,0];
        else
            %Correct response, green fixation
            if (keys{end}(1)=='u' && dots.direction == 0) || (keys{end}(1)=='d' && dots.direction == 180)
                results.response(trialNum) = 1;
                correctInaRow = correctInaRow +1;
                 if correctInaRow == 3
                    dots.coherence = dots.coherence*design.stepSize;

                    correctInaRow = 0;
                end
                display.fixation.color{1} = [0,255,0];
                 %Incorrect response, red fixation
            elseif (keys{end}(1)=='d' && dots.direction == 0) || (keys{end}(1)=='u' && dots.direction == 180)
                results.response(trialNum) = 0;
                dots.coherence = dots.coherence/design.stepSize;
                dots.coherence = min(dots.coherence,1);
                correctInaRow = 0;
                display.fixation.color{1} = [255,0,0];
            else %Wrong key was upressed, blue fixation
                results.response(trialNum) = NaN;
                display.fixation.color{1} = [0,0,255];
                %Note, for wrong keypresses, don't update the staircase
                %parameters
            end
        end

        %Flash the fixation with color
        drawFixation(display);
        waitTill(.15);
        display.fixation.color{1} = [255,255,255];
        drawFixation(display);

        %Now wait for the clock to catch up to the time for the next trial
        waitTill(trialNum*design.ITI,startTime);
    end

catch ME
    Screen('CloseAll');
    rethrow(ME)
end
Screen('CloseAll');

% Save the results
save results results design

%% Plotting the staircase

% It's useful to look at how the intensity (coherence) values changed from trial to trial.
% This can be seen by simply plotting the values in 'results.intensity' with matlab's
% 'stairs' function. We'll plot the intensity values on a log axis so that they're equally spaced.

figure(1)
clf
stairs(log(results.intensity));

%% Let's get fancy and plot green and red symbols where trials had correct and
% incorrect responses respectively:

correctTrials = results.response==1;
hold on
plot(find(correctTrials),log(results.intensity(correctTrials)),'ko','MarkerFaceColor','g');

incorrectTrials = results.response==0;
plot(find(incorrectTrials),log(results.intensity(incorrectTrials)),'ko','MarkerFaceColor','r');
set(gca,'YTick',log(2.^[-4:0]))
logy2raw;

xlabel('Trial Number')
ylabel('Coherence');

%% You can see from my example (running myself sitting in my office) that
% the staircase is hovering around a coherence level between 0.1 and 0.2.

% Let's plot the psychometric function from the same data using similar code as before.
% The one change we'll make is to have the size of each symbol grow with the number of
% trials presented at the corresponding stimulus intensity.
% This lets us get a feeling for the 'weight' of each data point.
% (This wasn't necessary for constant stimuli. Why not?)

intensities = unique(results.intensity);

% Then we'll loop through these intensities calculating the proportion of times that
% 'response' is equal to 1:

nCorrect = zeros(1,length(intensities));
nTrials = zeros(1,length(intensities));

for i=1:length(intensities)
    id = results.intensity == intensities(i) & ~isnan(results.response);
    nTrials(i) = sum(id);
    nCorrect(i) = sum(results.response(id));
end

pCorrect = nCorrect./nTrials;

figure(2)
clf
hold on
 plot(log(intensities),100*pCorrect,'-','MarkerFaceColor','b');
 %loop through each intensity so each data point can have it's own size.
for i=1:length(intensities)
    sz = nTrials(i)+2;
    plot(log(intensities(i)),100*pCorrect(i),'ko-','MarkerFaceColor','b','MarkerSize',sz);
end

set(gca,'XTick',log(intensities));
logx2raw;
set(gca,'YLim',[0,100]);
xlabel('Coherence');
ylabel('Percent Correct');