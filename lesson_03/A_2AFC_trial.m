%% Exercises

% Edit the program above to loop through 10 trials of the 2AFC motion experiment
% and calculate your percent correct.
% Repeat this for the following coherence levels: .1,.2,.3,.4,.5.
% Then plot the percent correct on the y-axis as function of the coherence on the x-axis.
% This is a 'psychometric function'
% Use the 'drawText' and 'waitTill' to measure the response times on a Stroop task:
% Put up, for example, the word 'GREEN' in red text and have the subject type
% the first letter of the written word.
% Compare the RT's for this compared to when the color of the text matches the word.

clear display dots

% Set display parameters
display.dist = 50;  %cm
display.width = 30; %cm
display.skipChecks = 1; %avoid Screen's timing checks and verbosity

% Set up dot parameteursu
dots.nDots = 200;
dots.speed = 5;
dots.lifetime = 12;
dots.apertureSize = [12,12];
dots.center = [0,0];
dots.color = [255,255,255];
dots.size = 8;
dots.coherence = .5;

duration = 1; %seconds

%Start the trial

try
    display = OpenWindow(display);
    
    for i = 1: 10
    drawText(display,[0,6],'Press "u"k for up and "d" for down',[255,255,255]);
    drawText(display,[0,5],'Press Any Key to Begin.',[255,255,255]);
    
    %choose either up or down for the dot direction
    trialDirection = ceil(rand(1)+.5);  %50/50 chance of a 1 (up) or a 2 (down)
    dots.direction = (trialDirection-1)*180; %1 -> 0 degrees, 2 -> 180 degrees

    display = drawFixation(display);

    while KbCheck; end
    KbWait;

    %Show the stimulus
    movingDots(display,dots,duration);

    %Get the response within the first second after the stimulus
    keys = waitTill(1);

    %Interpret the response provide feedback
    if isempty(keys)  %No key was pressed, yellow fixation
        correct = NaN;
        display.fixation.color{1} = [255,255,0];
    else
        %Correct response, green fixation
        if (keys{end}(1)=='u' && dots.direction == 0) || (keys{end}(1)=='d' && dots.direction == 180)
            correct = 1;
            display.fixation.color{1} = [0,255,0];
            %Incorrect response, red fixation
        elseif (keys{end}(1)=='d' && dots.direction == 0) || (keys{end}(1)=='u' && dots.direction == 180)
            correct = 0;
            display.fixation.color{1} = [255,0,0];
            %Wrong key was pressed, blue fixation
        else
            correct = NaN;
            display.fixation.color{1} = [0,0,255];
        end
    end
    end
    
    %Flash the fixation with color
    drawFixation(display);
    waitTill(.5);
    display.fixation.color{1} = [255,255,255];
    drawFixation(display);
    waitTill(.5);

catch ME
    Screen('CloseAll');
    rethrow(ME)
end
Screen('CloseAll');
%% 
% Set display parameters
display.dist = 50;  %cm
display.width = 30; %cm
display.skipChecks = 1; %avoid Screen's timing checks and verbosity

display.text.size = 40;
display.text.color = [255,255,0];
display.text.style =2;
display.text.font = 'Helvetica';

try
    display = OpenWindow(display);
    
    for i = 1: 5
    tic
    display = drawText(display,[0,6],'Please the text correct');
    display = drawText(display,[0,5],'Please Any key to Begin');
    
    while KbCheck; end
    KbWait;
    %Get the response within the first second after the stimulus
    keys = waitTill(1);
    
    drawText(display,[0,0],'Green',[255,0,0]);
    
    display.fixation.color{1} = [255,255,0];
    
    %Interpret the response provide feedback
    if isempty(keys)  % No key was pressed, yellow fixation
        correct = NaN;
        display.fixation.color{1} = [255,255,0];
    else
        %Correct response, green fixation
        if (keys{end}(1)=='u') || (keys{end}(1)=='d')
            correct = 1;
            display.fixation.color{1} = [0,255,0];
            %Incorrect response, red fixation
        elseif (keys{end}(1)=='d') || (keys{end}(1)=='u')
            correct = 0;
            display.fixation.color{1} = [255,0,0];
            %Wrong key was prsessed, blue fixation
        else
            correct = NaN;
            display.fixation.color{1} = [0,0,255];
        end
        toc
    end
    
    end
    Screen(display.windowPtr,'Flip');
    waitTill(2);
    Screen(display.windowPtr,'Flip');
    waitTill(.25);
catch ME
    Screen('CloseAll');
    rethrow(ME)
end
Screen('CloseAll');