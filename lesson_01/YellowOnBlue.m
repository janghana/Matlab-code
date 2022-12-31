%% Write a script called 'YellowOnBlue.m' that opens the screen with a blue background,
% puts up yellow letters [255,255,0] saying 'Yellow on Blue',
% pauses for 5 seconds and closes the window.
%% Use the 'Flip' command in a loop instead of the 'Pause' command.
% For example, if your monitor has a frame rate of 60Hz, then a loop with 60 calls to 'Flip
% will take exactly one second.
%% Exercise 1
try
    Screen('Preference', 'SkipSyncTests', 1);
    Screen('Preference?');
    windowPtr=Screen('OpenWindow',0,[0,0,255]);
    for i=1 : 300
    Screen('DrawText',windowPtr,'Yellow on Blue',500,500,[255,255,0]);
    Screen('Flip',windowPtr);
    end
catch ME
    Screen('CloseAll');
    rethrow(ME);
end
Screen('CloseAll');