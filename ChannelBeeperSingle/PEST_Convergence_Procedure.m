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
global white_cross_screen
global green_cross_screen
global solid_black_screen
global trialtime
global fixation_time
global delay_times

%% 1) Setting up Psych Toolbox Audio and Visual

subject_quit = false;

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
repeat_111 = 0;
repeat_000 = 0;

%Delay times
delay_times = [1.0 1.1 1.2 1.3 1.4];
t = trialtime - fixation_time;
%Index to keep track of loop
count = 0;

%Stores and outputs: 1) trial number, 2) time delay of stimulus, 3)
%magnitude of stimulus, 4) detected or not
output_array = [];


%% 5) For loop of actual task
while (threshold_not_reached)
    t0 = tic;
    % 1) Present red crosshair
    % 2) Deliver stimulus with variable time delay
    % 3) Present green crosshair
    % 4) Record response
    % 5) Repeat for other two intensities
    % 6) Update stimulation intensities
    
    % Generate variable delay time
    rand_position_1 = randi([1 size(delay_times,2)]);
    delay_time_1 = delay_times(rand_position_1);
    
    %% Delivery of Max stimulus
    %Draw red crosshair
    Screen('DrawTexture',windowPtr,white_cross_screen);
    Screen(windowPtr,'Flip');
    WaitSecs(delay_time_1);
    
    %Max stimulus
    time_1 = GetSecs() - initial_time;
    ChannelBeeper(100, max_stim, .01, PEST_hand);
    WaitSecs(fixation_time - delay_time_1 - .01)
    
    %Draw green crosshair
    Screen('DrawTexture',windowPtr,green_cross_screen);
    Screen(windowPtr,'Flip');
    [s_max, keyCode_max, ~] = KbWait(-3, 2, GetSecs()+t);
    WaitSecs(t - s_max);
    t_max = toc(t0);
    %% Delivery of Mid stimulus
    
    % Generate variable delay time
    rand_position_2 = randi([1 size(delay_times,2)]);
    delay_time_2 = delay_times(rand_position_2);
    
    %Draw red crosshair
    Screen('DrawTexture',windowPtr,red_cross_screen);
    Screen(windowPtr,'Flip');
    WaitSecs(delay_time_2);
    
    %Mid stimulus
    time_2 = GetSecs() - initial_time;
    ChannelBeeper(100, mid_stim, .01, PEST_hand);
    WaitSecs(fixation_time - delay_time_2 - .01)
    
    %Draw green crosshair
    Screen('DrawTexture',windowPtr,green_cross_screen);
    Screen(windowPtr,'Flip');
    [s_mid, keyCode_mid, ~] = KbWait(-3, 2, GetSecs()+t);
    WaitSecs(t - s_mid);
    t_mid = toc(t0);
    %% Delivery of Min stimulus
    
    % Generate variable delay time
    rand_position_3 = randi([1 size(delay_times,2)]);
    delay_time_3 = delay_times(rand_position_3);
    
    %Draw red crosshair
    Screen('DrawTexture',windowPtr,red_cross_screen);
    Screen(windowPtr,'Flip');
    WaitSecs(delay_time_3);
    
    %Min stimulus
    time_3 = GetSecs() - initial_time;
    ChannelBeeper(100, min_stim, .01, PEST_hand);
    WaitSecs(fixation_time - delay_time_3 - .01)
    
    %Draw green crosshair
    Screen('DrawTexture',windowPtr,green_cross_screen);
    Screen(windowPtr,'Flip');
    [s_min, keyCode_min, ~] = KbWait(-3, 2, GetSecs()+t);
    WaitSecs(t - s_min);
    t_min = toc(t0);
    %% Adjustment of weights
    % Keeps track of participant's response (1 is 30, 2 is 31)
    max_detected = keyCode_max(30);
    mid_detected = keyCode_mid(30);
    min_detected = keyCode_min(30);
    
    %Store trial information in array to output
    count = count + 3;
    
    max_data = [(count - 2), time_1, delay_time_1, max_stim, max_detected, t_max];
    mid_data = [(count - 1), time_2, delay_time_2, mid_stim, mid_detected, t_mid];
    min_data = [(count), time_3, delay_time_3, min_stim, min_detected, t_min];
    
    output_array = cat(1,output_array,max_data,mid_data,min_data);
    %Output each trial's results
    displayResponses(output_array)
    
    
    %% Changing Intensities
    
    % If max,mid,min = 0,0,0 then repeat trials up to 5 times, then quit
    if (max_detected == 0 && mid_detected == 0 && min_detected == 0)
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
    if (max_detected == 1 && (mid_stim - min_stim) <= delta_threshold)
        detection_threshold = mid_stim;
        threshold_not_reached = false;
        % display the output_array to the experimenter here
        displayResponses(output_array,'All')
    end
    
    % If mid detected, move down, if not, move up
    if (max_detected == 1 && mid_detected == 1)
        max_stim = mid_stim;
        mid_stim = (min_stim + mid_stim)/2;
    elseif (max_detected == 1 && mid_detected == 0 && min_detected == 0)
        min_stim = mid_stim;
        mid_stim = (max_stim + min_stim)/2;
    end
    
    if (keyCode_max(46) == 1 || keyCode_mid(46) == 1 || keyCode_min(46) == 1)
        subject_quit = true;
        fprintf('The subject indicated they wanted to quit during PEST.');
        Screen('CloseAll')
        break;
    end
    
    %Screen('CloseAll')
end