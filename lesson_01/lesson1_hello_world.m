% In this script we'll learn how to open a 'screen' using the psychtoolbox,
% put up some text, pause, and close the window. Once you get this working,
% you're well off the ground for putting up stimuli with the psychtoolbox.

%% The first Screen command will be 'OpenWindow', the first in the list.
%  To see more about how to use that command, use the Screen command like this.

%Screen('OpenWindow?');

%[windowPtr,rect]=Screen('OpenWindow',windowPtrOrScreenNumber [,color]
%[,rect][,pixelSize][,numberOfBuffers][,stereomode][,multisample][,imagingm ode]);

%Arguments in [brackets] are optional.

%% The second Screen command is 'CloseAll'. We'll use 'OpenWindow' and 'Close'
% together because if we just use 'OpenWindow' alone it'll leave the computer
% in a state where we can't see the Matlab command window.
% Here's a simple set of commands that opens the screen and then closes it.
% Be sure to run these two lines together:

% windowPtr=Screen('OpenWindow',0);
% Screen('CloseAll');

% The second argument '0' means open the default screen on your computer.
% If you have an external monitor (or projector), you can use '1'.

%% We can put up text in our screen with the Screen function 'DrawText'.
% These four lines open the screen, put up some text,
% pauses for two seconds and closes it:

Screen('Preference', 'SkipSyncTests', 1);
Screen('Preference?');
windowPtr=Screen('OpenWindow',0);
Screen('DrawText',windowPtr,'Hello World!',500,500);
Screen('Flip',windowPtr);
pause(2)
Screen('CloseAll');
% The variable 'windowPtr' returned by 'Screen' when you open
% the window is important - it holds a pointer to the memory register for 
% the window which needs to be passed back into 'Screen' every time you use it.
% Wzhat is this 'Flip' command? This is an important Screen function that
% waits for a signal that the monitor has refreshed before showing everything that
% has been shown since the previous 'Flip' command.
% (Actually it's performing a technique called 'double buffering' which
% involves flipping between two 'display surfaces',
% but we don't need to go into that right now.)
% 'Flip' serves two useful functions.
% First it ensures that any drawing happens after the screen refresh to avoid
% 'tearing' artifacts that occur when a refresh occurs in the middle of putting up
% graphics. Second, it gives you control over the timing of your animations.
% As long as all of your drawing occurs in less than it a single frame
% (usually something like 1/60 of a second), then your animation will be performed
% at exactly the frame rate of the monitor, which is a very reliable thing.

%% try- catch
% It can be inconvenient if you have a bug in your program that causes the program to terminate
% when the screen is open. To get out of this you have to switch to the command window
% by going to the task manager, switching to the matlab command window and typing (blindly)
% "Screen('CloseAll')". A nice way around this by using the 'try' and 'catch' commands
% (Thanks to Sungjun Joo for this suggestion). 'try' and 'catch' are commands that
% allow control over how errors are handled in Matlab. Here's an example:

try
    windowPtr = Screen('OpenWindow', 0);
    %Place a bad line of code here...
catch ME
    Screen('CloseAll');
    rethrow(ME);
end
Screen('CloseAll');
% This should function normally, but if you add a bad line of code anywhere between 'try' and me',
% control will be sent to the lines following the 'catch' command. Here, the screen is closes and
% the error message is displayed in the command window using the 'rethrow' command.
%% A customized version of OpenWindow

% You may get a series of scary warnings both in the command window and on the screen when Screen is used,
% depending on the computer you're using. When a screen is opened,
% a variety of checks are made by Screen to determine issues such as the timing of the refresh rate.
% Don't let the guys who wrote the psychtoolbox know I said this,
% but I find some of these dire warnings to be not so dire, like the ones about skipping video frames.
% Fortunately, you can turn these warnings off using the 'Screen('Preference') command.

% You can set a variety of screen attributes with the'Screen('Preference') command.
% You can get help the usual way:
Screen('Preference?');
%% I've written a function called 'OpenWindow' that calls 'OpenScreen' 
% after setting some of the preferences beforehand to avoid warnings (if desired).
% I find this function useful because it hides a bunch of ugly lines that I used to have to include
% every time I opened the window. It also opens the screen to a default color of black.

% It also introduces a structure called 'display' that contains useful information 
% about the current computer display, such as the 'windowPtr' variable.
% Later we'll add fields to this structure about the viewing distance that
% will allow us to define our stimuli in 'real-world' parameters
% like degrees of visual angle and seconds rather than display-oriented parameters
% like pixels and frames.

% Here's an example of how to use 'OpenWindow'.

try
    display.skipChecks =1;
    display.bkColor = [255,255,255];
    display = OpenWindow(display);
    Screen(display.windowPtr,'DrawText','Psychophysics Rules!',500,500,[255,0,0]);
    Screen('Flip',display.windowPtr);
    pause(2)
catch ME
    Screen('CloseAll');
    rethrow(ME)
end
Screen('CloseAll');
%% Note the [255,0,0] which defines the color of the text to be red (r,g,b).

%Also check out the display structure:

%display
%display = 

%    skipChecks: 1
%       bkColor: [255 255 255]
%     screenNum: 0
%     windowPtr: 10
%     frameRate: 60.0553
%    resolution: [2048 768]
%        center: [1024 384]
        
% (Your results may vary).
% It has fields with information about the display's frame rate and screen resolution.

% You can set some parameters for OpenWindow by passing in an existing 'display' structure.
% More information about this can be seen by getting help:

help OpenWindow


% display = OpenWindow([display])
 
% Calls the psychtoolbox command "Screen('OpenWindow') using the 'display'
% structure convention.

% Inputs:
%    display             A structure containing display information with fields:
%        screenNum       Screen Number (default is 0)
%        bkColor         Background color (default is black: [0,0,0])
%        skipChecks      Flag for skpping screen synchronization (default is 0, or don't check)
%                        When set to 1, vbl sync check will be skipped,
%                        along with the text and annoying visual (!) warning
 
% Outputs:
%    display             Same structure, but with additional fields filled in:
%        windowPtr       Pointer to window, as returned by 'Screen'
%        frameRate       Frame rate in Hz, as determined by Screen('GetFlipInterval')
%        resolution      [width,height] of screen in pixels
%        center          [x,y] center of screeen in pixels 
  
% Note: for full functionality, the additional fields of 'display' should be
% filled in:
 
%        dist             distance of viewer from screen (cm)
%        width            width of screen (cm)

% Exercises

% For this week's exercises, please use the 'try' and 'catch' commands as described here,
% and use the OpenWindow function.

% Write a script called 'YellowOnBlue.m' that opens the screen with a blue background,
% puts up yellow letters [255,255,0] saying 'Yellow on Blue',
% pauses for 5 seconds and closes the window.
% Use the 'Flip' command in a loop instead of the 'Pause' command. For example,
% if your monitor has a frame rate of 60Hz, then a loop with 60 calls to 'Flip'
% will take exactly one second.
