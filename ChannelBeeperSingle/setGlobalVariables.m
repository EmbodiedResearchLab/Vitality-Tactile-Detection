function setGlobalVariables()

	global initial_time
    global windowPtr
    global green_cross_screen
    global red_cross_screen
    global solid_black_screen
    global left_arrow_screen
    global right_arrow_screen
    global square_screen
    
    green_cross = imread('crosshair_green.png');
    red_cross = imread('crosshair_red.png');
    solid_black = imread('solid_black.png');
    left_arrow = imread('left_arrow.png');
    right_arrow = imread('right_arrow.png');
    square = imread('square.png');
    
    % Establishes various screens to be used throughout the experiment.
    green_cross_screen = Screen('MakeTexture',windowPtr,green_cross);
    red_cross_screen = Screen('MakeTexture',windowPtr,red_cross);
    solid_black_screen = Screen('MakeTexture',windowPtr,solid_black);
    left_arrow_screen = Screen('MakeTexture',windowPtr,left_arrow);
    right_arrow_screen = Screen('MakeTexture',windowPtr, right_arrow);
    square_screen = Screen('MakeTexture', windowPtr, square);

	initial_time = GetSecs();
    
    % Initializes PsychSounds as there is some issue with calling
    % ChannelBeeper on the very first trial.
    ChannelBeeper(440,0,.1);


end