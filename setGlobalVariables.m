function [windowPtr, rect] = setGlobalVariables()
    addpath('Stimuli') % Folder contains images of instructions, cues, etc.
    
	global initial_time
    global screens
    global white_cross_screen
    global green_cross_screen
    global red_cross_screen
    global solid_black_screen
    global left_arrow_screen
    global right_arrow_screen
    global square_screen
    global trialtime
    global fixation_time
    global delay_times
    
    % Open first screen, solid black
    screens = 1;
    Screen('Preference','SyncTestSettings', .005, 50, .5, 5);
    [windowPtr, rect] = Screen('OpenWindow', screens, [0 0 0]);
    
    % Establishes various screens to be used throughout the experiment.
    white_cross = imread('crosshair_white.png');
    green_cross = imread('crosshair_green.png');
    red_cross = imread('crosshair_red.png');
    solid_black = imread('solid_black.png');
    left_arrow = imread('left_arrow.png');
    right_arrow = imread('right_arrow.png');
    square = imread('square.png');
    white_cross_screen = Screen('MakeTexture',windowPtr, white_cross);
    green_cross_screen = Screen('MakeTexture',windowPtr, green_cross);
    red_cross_screen = Screen('MakeTexture',windowPtr, red_cross);
    solid_black_screen = Screen('MakeTexture',windowPtr, solid_black);
    left_arrow_screen = Screen('MakeTexture',windowPtr, left_arrow);
    right_arrow_screen = Screen('MakeTexture',windowPtr, right_arrow);
    %square_screen = Screen('MakeTexture', windowPtr, square);
    square_screen = 1; % Debugging.  Need to make a black screen with a white square.
    
    % Initializes PsychSounds as there is some issue with calling
    % ChannelBeeper on the very first trial.
    ChannelBeeper(440,0,.1); % Avoids a delay later on
    
    % Get initial time for the experiment
	initial_time = GetSecs();
    
    % Trial Parameters
    trialtime = 3; % The length of time for each trial
    fixation_time = 1.5; % Cross if 1 stimulator; Arrow if 2 stimulators.  Amount of time that cue/fixation is on the screen.  Consistent for every trial
    delay_times = 1.0:0.1:1.4;
end