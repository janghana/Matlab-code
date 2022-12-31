display.dist = 50;  %viewing distance (cm)
display.width = 30; %width of screen (cm)

dots.nDots = 100;                % number of dots
dots.color = [255,255,255];      % color of the dots
dots.size = 10;                   % size of dots (pixels)
dots.center = [0,0];           % center of the field of dots (x,y)
dots.apertureSize = [12,12];     % size of rectangular aperture [w,h] in degrees.

display.resolution = [1440, 900];

dots.x = (rand(1,dots.nDots)-.5)*dots.apertureSize(1) + dots.center(1);
dots.y = (rand(1,dots.nDots)-.5)*dots.apertureSize(2) + dots.center(2);

pixpos.x = angle2pix(display,dots.x);
pixpos.y = angle2pix(display,dots.y);

pixpos.x = pixpos.x + display.resolution(1)/2;
pixpos.y = pixpos.y + display.resolution(2)/2;

dots.speed = 3;       %degrees/second
dots.duration = 5;    %seconds

l = dots.center(1)-dots.apertureSize(1)/2;
r = dots.center(1)+dots.apertureSize(1)/2;
b = dots.center(2)-dots.apertureSize(2)/2;
t = dots.center(2)+dots.apertureSize(2)/2;

try
    display.skipChecks=1;
    display = OpenWindow(display);
    nFrames = secs2frames(display,dots.duration);
    for i = 1:1:dots.nDots
        dots.direction = randperm(dots.nDots, 1);  %degrees (clockwise from straight up)
        dx(i) = dots.speed*sin(dots.direction*pi/180)/display.frameRate;
        dy(i) = -dots.speed*cos(dots.direction*pi/180)/display.frameRate;
    end
    j = 0;
    tic
    for i=1:nFrames
        %Use the equation of an ellipse to determine which dots fall inside.
        
        goodDots = (dots.x-dots.center(1)).^2/(dots.apertureSize(1)/2)^2 + ...
            (dots.y-dots.center(2)).^2/(dots.apertureSize(2)/2)^2 < 1;
        
        pixpos.x = angle2pix(display,dots.x)+ display.resolution(1)/2;
        pixpos.y = angle2pix(display,dots.y)+ display.resolution(2)/2;
        
        %Draw only the 'good dots'
        Screen('DrawDots',display.windowPtr,[pixpos.x(goodDots);pixpos.y(goodDots)], dots.size, dots.color,[0,0],1);
        
        dots.x = dots.x + dx;
        dots.y = dots.y + dy;
        
        dots.x(dots.x<l) = dots.x(dots.x<l) + dots.apertureSize(1);
        dots.x(dots.x>r) = dots.x(dots.x>r) - dots.apertureSize(1);
        dots.y(dots.y<b) = dots.y(dots.y<b) + dots.apertureSize(2);
        dots.y(dots.y>t) = dots.y(dots.y>t) - dots.apertureSize(2);
        j = j+1;

        Screen('Flip',display.windowPtr);
    end
    toc
catch ME
    Screen('CloseAll');
    rethrow(ME)
end
Screen('CloseAll');
clear dx
clear dy

% quiz 3 : 10000��