function [windowPtr, rect] = setGlobalVariables()
    %addpath('Stimuli/Old') % Folder contains images of instructions, cues, etc.
    addpath('Stimuli/new')
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
    global yes
    global no
    global esc
    
    % Open first screen, solid black
    if ismac %
        screens = 1; % 0 - Same screen; 1 Monitor Screen
    elseif ispc
        screens = 2; % 0 - Shared screens; 1 Computer Screen; 2 Monitor Screen
    end
    Screen('Preference','SyncTestSettings', .005, 50, .5, 5);
    [windowPtr, rect] = Screen('OpenWindow', screens, [0 0 0]);
    
    % Establishes various screens to be used throughout the experiment.
    white_cross = imread('crosshair_white.png');
    green_cross = imread('crosshair_green.png');
    red_cross = imread('crosshair_red.png');
    solid_black = imread('solid_black.png');
    left_arrow = imread('left_arrow.png');
    right_arrow = imread('right_arrow.png');
    %square = imread('square.png');
    white_cross_screen = Screen('MakeTexture',windowPtr, white_cross);
    green_cross_screen = Screen('MakeTexture',windowPtr, green_cross);
    red_cross_screen = Screen('MakeTexture',windowPtr, red_cross);
    solid_black_screen = Screen('MakeTexture',windowPtr, solid_black);
    left_arrow_screen = Screen('MakeTexture',windowPtr, left_arrow);
    right_arrow_screen = Screen('MakeTexture',windowPtr, right_arrow);
    square_screen = 1; % Debugging.  Need to make a black screen with a white square.
    
    % Initializes PsychSounds as there is some issue with calling
    % ChannelBeeper on the very first trial.
    %ChannelBeeper(440,0,.1); % Avoids a delay later on
    ChannelBeeperTrigger(440,0,.1,'Right', .5)
    
    % Get initial time for the experiment
	initial_time = GetSecs();
    
    % Trial Parameters
    trialtime = 3.5; % The length of time for each trial
    fixation_time = 2; %1.6; % Cross if 1 stimulator; Arrow if 2 stimulators.  Amount of time that cue/fixation is on the screen.  Consistent for every trial
    delay_times = 1.1:0.1:1.6;
    
    % Determine responses
    %[yes, no, esc] = checkKeyResponses();
    yes = 49; 
    no = 50; 
    esc = 13 ;
    
end