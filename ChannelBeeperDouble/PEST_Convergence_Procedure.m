function [detection_threshold, output_array,subject_quit] = PEST_Convergence_Procedure(windowPtr, PEST_hand)
%{
From the IRB:
This algorithm follows (Dai 1995) and (Jones 2007) in determining the
tactile detection threshold.

First, a strong tactile stimulus (100%
amplitude, 350 um deflection) is presented, followed by a weak stimulus
(50% amplitude), and a blank stimulus. If the subject reports detection of
the strong and the weak tactile stimuli, then the next set of stimuli will
be given the 50% value set for the strong stimulus and a new value at
one-half the distance between the weak and blank stimulus for the middle
stimulus. If the subject does not detect the middle stimulus, then the
maximum stimulus will remain the same, the middle stimulus will become the
new minimum stimulus, and the new value for the middle stimulus will be the
average of the maximum and new minimum. The procedure will be repeated
until the change in the amplitude of movement for the piezoelectric between
trials is 5 um. This process will take 3 minutes.
%}

global initial_time
global trialtime
global fixation_time
global delay_times
global left_arrow_screen
global right_arrow_screen
global white_cross_screen
global green_cross_screen
global solid_black_screen
global yes
global no
global esc

%% 1) Setting up Psych Toolbox Audio and Visual

subject_quit = false;
white = false;

%Display blank screen for 3 seconds as a precursor to trial
Screen('DrawTexture',windowPtr,solid_black_screen);
Screen(windowPtr,'Flip');

WaitSecs(3);

%% 4) Initialize variables for tactile detection threshold and random delay times
%Initialize variables to store stimulus values
max_stim = .9; %the equivalent of 350 um
mid_stim = max_stim/2;
min_stim = 0;

%Initialize variable to detect 5 um difference
delta_threshold = .02; % the equivalent of 5 um

%Initialize boolean for while loop
threshold_not_reached = true;

%Detection Threshold
detection_threshold = 1;

%Variable to keep track of repeated trials (bc if repeated too many times
%then want to restart)
repeat_num = 0;

t = trialtime - fixation_time;
%Index to keep track of loop
count = 0;

%Stores and outputs: 1) trial number, 2) time delay of stimulus, 3)
%magnitude of stimulus, 4) detected or not
output_array = [];

%% 5) For loop of actual task
while threshold_not_reached
    t0 = tic;
    % 1) Present red crosshair
    % 2) Deliver stimulus with variable time delay
    % 3) Present green crosshair
    % 4) Record response
    % 5) Repeat for other two intensities
    % 6) Update stimulation intensities
    
    % Generate variable delay time
    rand_position = randi([1 size(delay_times,2)],[1 3]);
    delay_time = delay_times(rand_position);
    
    % Toggles presentation screen to arrows or white_cross_screen whether
    % white is true or false.
    if white
        stim_screen = white_cross_screen;
    elseif strcmp(PEST_hand, 'Left')
        stim_screen = left_arrow_screen;
    elseif strcmp(PEST_hand, 'Right')
        stim_screen = right_arrow_screen;
    end
    %% Delivery of Max stimulus
    %Draw Cue Screen Screen
    time_cue_max = GetSecs();
    Screen('DrawTexture',windowPtr,stim_screen);
    Screen(windowPtr,'Flip');
    WaitSecs(delay_time(1));
    
    %Max stimulus
    time_1 = GetSecs() - initial_time;
    ChannelBeeper(100, max_stim, .01, PEST_hand);
    
    % Wait until fixation_time has elapsed.
    WaitSecs(fixation_time - delay_time(1) - .01);
    
    %Draw green crosshair
    Screen('DrawTexture',windowPtr,green_cross_screen);
    time_green_max = Screen(windowPtr,'Flip');
   
    % Give participant up to t s for response y or n
    % Checks for detection, gives
    [s_max, keyCode, ~] = KbWait(-3, 2, GetSecs()+t);
    keyMax = find(keyCode);
    if isempty(keyMax)
        keyMax = 0;
    end
    
    WaitSecs(trialtime - (s_max - time_cue_max));
    reaction_time_max = s_max - time_green_max;
    t_max = toc(t0);
 %% Delivery of Mid stimulus
    %Draw Cue Screen Screen
    time_cue_mid = GetSecs();
    Screen('DrawTexture',windowPtr,stim_screen);
    Screen(windowPtr,'Flip');
    WaitSecs(delay_time(2));
    
    %Max stimulus
    time_2 = GetSecs() - initial_time;
    ChannelBeeper(100, mid_stim, .01, PEST_hand);
    
    % Wait until fixation_time has elapsed.
    WaitSecs(fixation_time - delay_time(2) - .01);
    
    %Draw green crosshair
    Screen('DrawTexture',windowPtr,green_cross_screen);
    time_green_mid = Screen(windowPtr,'Flip');

    % Give participant up to t s for response y or n
    % Checks for detection, gives
    [s_mid, keyCode, ~] = KbWait(-3, 2, GetSecs()+t);
    keyMid = find(keyCode);
    if isempty(keyMid)
        keyMid = 0;
    end
    
    WaitSecs(trialtime - (s_mid - time_cue_mid));
    reaction_time_mid = s_mid - time_green_mid;
    t_mid = toc(t0);    
    %% Delivery of Min stimulus
    %Draw Cue Screen Screen
    time_cue_min = GetSecs();
    Screen('DrawTexture',windowPtr,stim_screen);
    Screen(windowPtr,'Flip');
    WaitSecs(delay_time(3));
    
    %Max stimulus
    time_3 = GetSecs() - initial_time;
    ChannelBeeper(100, min_stim, .01, PEST_hand);
    
    % Wait until fixation_time has elapsed.
    WaitSecs(fixation_time - delay_time(3) - .01);
    
    %Draw green crosshair
    Screen('DrawTexture',windowPtr,green_cross_screen);
    time_green_min = Screen(windowPtr,'Flip');
    
    % Give participant up to t s for response y or n
    % Checks for detection, gives
    [s_min, keyCode, ~] = KbWait(-3, 2, GetSecs()+t);
    keyMin = find(keyCode);
    if isempty(keyMin)
        keyMin = 0;
    end
    
    WaitSecs(trialtime - (s_min - time_cue_min));
    reaction_time_min = s_min - time_green_min;
    t_min = toc(t0);
    %% Adjustment of weights
    % Keeps track of participant's response (1 is 30, 2 is 31)
   
    %Store trial information in array to output
    count = count + 3;
    
    max_data = {(count - 2), time_1, delay_time(1), PEST_hand, max_stim, keyMax, t_max, reaction_time_max};
    mid_data = {(count - 1), time_2, delay_time(2), PEST_hand, mid_stim, keyMid, t_mid, reaction_time_mid};
    min_data = {(count), time_3, delay_time(3), PEST_hand, min_stim, keyMin, t_min, reaction_time_min};
    
    output_array = cat(1,output_array,max_data,mid_data,min_data);
    %Output each trial's results
    displayResponses(output_array,'Threes')    
    
    %% Changing Intensities
    % If max,mid,min = 0,0,0 then repeat trials up to 5 times, then quit
    if (keyMax == no && keyMid == no && keyMin == no)
        if repeat_num >= 5
            %Screen('CloseAll')
            threshold_not_reached = false;
        end

        repeat_num = repeat_num + 1;
        max_stim = max_stim*1.2;
        mid_stim = mid_stim*1.2;
        min_stim = min_stim*1.2;
    end
    
    % Check to see if threshold reached
    if (keyMax == yes && (mid_stim - min_stim) <= delta_threshold)
        detection_threshold = mid_stim;
        threshold_not_reached = false;
        % display the output_array to the experimenter here
        displayResponses(output_array)
    end
    
    % If mid detected, move down, if not, move up
    if (keyMax == yes && keyMid == yes)
        max_stim = mid_stim;
        mid_stim = (min_stim + mid_stim)/2;
    elseif (keyMax == yes && keyMid == no && keyMid == no)
        min_stim = mid_stim;
        mid_stim = (max_stim + min_stim)/2;
    end
    
    if (keyMax == esc || keyMid == esc || keyMin == esc)
        subject_quit = true;
        fprintf('The participant indicated they wanted to quit during PEST.');
        Screen('CloseAll')
        break;
    end

end
displayResponses(output_array,'All')

end