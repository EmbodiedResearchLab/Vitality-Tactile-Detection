function [output_array,subject_quit, new_threshold, stim] = Channel_Dynamic_Thresholding_Single(windowPtr,threshold)
%{

This is a script to perform the dynamic thresholding procedure as described
in Jones 2007. In the procedure, there will be 70% dynamic thresholding
trials, 20% null trials, and 10% suprathreshold (ie 100%). Specifically,
the suprathreshold trials will be two times the detection threshold
obtained from PEST.

Dynamic thresholding works as follows - if two correct threshold stimuli
are percieved in a row, then the threshold will be lowered by .005 V. If
three threshold stimuli are failed to be percieved in a row, then the
threshold will increase by .005 V.

%}

%% 1) Initialise Screens and other necessary variables

global initial_time
global trialtime
global fixation_time
global delay_times
global white_cross_screen
global red_cross_screen
global green_cross_screen
global solid_black_screen
global yes
global no
global esc
subject_quit = false;

Screen('DrawTexture',windowPtr,solid_black_screen);
Screen(windowPtr,'Flip');

WaitSecs(3);

%% 3) Initialize necessary variables - NUM_TRIALS IS HERE!!

% Desired number of trials on detection threshold (70% of time) intensity per hand
% out of these trials, .45 will go to each hand, and .1 will be specified as NOTHING (square)
% when something is directed to a hand, 70% will be as expected (@ threshold), 20% will be null, and 10% will be double threshold
% according to the math, there will be 800 total trials, leading to 252 alpha-modulated data points for each hand
total_trials = round(100/.7); %This creates 143 trials, which is based on target of 100 mid intensity trials

square_trials = round(total_trials*.0);
stim_trials = round(total_trials*1);

thresh_trials = round(stim_trials*.7);
null_trials = round(stim_trials*.2);
supra_trials = round(stim_trials*.1);

% this is to make an array with total_trials*percent_both 0's and total_trials*percent_real 1's
% this array will be used to choose whether to do a real trial (left or right arrow) or a both trial (square)
is_both = 0;
is_real = 1;

trial_type_values = [repmat(is_both,1,square_trials), repmat(is_real,1,stim_trials)];

%Initialize variables to store stimulus values
intensity = [0, threshold, threshold*2];
stim_values = [repmat(intensity(1),1,null_trials), repmat(intensity(2),1,thresh_trials), repmat(intensity(3),1,supra_trials)];

t = trialtime - fixation_time;

%Initializing variables to keep track of output

output_array = []; %overall output
threshold_output_array = []; %array that only stores responses from threshold stimuli
count_threshold = 0; %number of threshold stimuli

%The equivalent of .005 V (to increase or decrease the threshold by)
change = .01;

%value to store the changing threshold
updated_threshold = intensity(2);
stim(stim_trials) = struct('trial',[],'time',[],'delay_time',[],'stimulus',[],'response',[],'runtime',[],'reaction',[]);
%% 4) Actual presentation of stimuli and input of participant response
for i = 1:total_trials
%{    
    1) choose whether it's a real trial or a both (fake) trial
    THE FOLLOWING STEPS WILL ONLY TAKE ACCOUNT REAL TRIALS
    2) choose the random delay time (from 1000 to 1400 ms in 100ms increments)
    3) choose weighted random stimulus intensity for the hand in question
    4) display the left or right arrow picture to direct which hand to modulate attention to
    5) wait the chosen delay time
    6) deliver 10ms stimulus
    7) wait fixation_time-delayTime-.010 (so that there has been a total of 2 s since cue)
    8) give user up to 1 s for response y or n
    9) Checks to see if the threshold needs to be changed and does so
    10) Outputs array of data
%}    
    
    % 1) choose whether it's a real trial or a both (fake) trial
    trial_validity_random = randi([1 size(trial_type_values,2)]);
    trial_validity = trial_type_values(trial_validity_random);
    %erase the value chosen, shrinking the trials to do by 1
    trial_type_values(trial_validity_random) = [];
    
    % if the trial is a null trial, I just need to wait 3 seconds
    if trial_validity == is_real
        t0 = tic;
        RunTime = GetSecs()-initial_time;
        % 2) choose the random delay time (from 1000 to 1400 ms in 100ms increments)
        rand_position_delay = randi([1 size(delay_times,2)]);
        delay_time = delay_times(rand_position_delay);
        
        % 3) choose weighted random stimulus intensity
        %initialize the stimulus variable
        stim_values_random = randi([1 size(stim_values,2)]);
        if stim_values(stim_values_random) == intensity(2) % if this is a threshold trial
            stimulus = updated_threshold;
        elseif stim_values(stim_values_random == intensity(3)) % if this is a suprathreshold trial
            stimulus = updated_threshold*2;
        else % if this is a nullthreshold trial
            stimulus = stim_values(stim_values_random);
        end
        stim_values(stim_values_random) = [];
        
        % 4) display the white crosshair to wait for incoming stimulus
        time = GetSecs();
        nidaqTriggerInterface('on','white')
        Screen('DrawTexture',windowPtr,white_cross_screen);
        Screen(windowPtr,'Flip');
        nidaqTriggerInterface('off');

        
        % 5) wait the chosen delay time
        WaitSecs(delay_time);
        
        % 6) deliver 10ms stimulus and wait duration of fixation time
        % before changing screens
        time_stim = GetSecs(); %- initial_time;
        ChannelBeeperTrigger(100,stimulus,.01, 'Left', updated_threshold);
        %ChannelBeeper(100,stimulus,.01,'Left');
        
        % 7) Wait until fixation_time has elapsed.
        WaitSecs(fixation_time - delay_time - .01);
        
        % Draw green crosshair
        Screen('DrawTexture',windowPtr,green_cross_screen);
        Screen(windowPtr,'Flip');
        
        % 8) give user up to t s for response y or n
        % Checks for detection, gives
        [rt, keyCode, ~] = KbWait(-3, 2, GetSecs()+t);
        key = find(keyCode);
        if isempty(key);
            key = 0;
        end
        nidaqTriggerInterface('on','white',updated_threshold, stimulus,key)
        nidaqTriggerInterface('off');
        WaitSecs(trialtime - (rt-time)); % This is each trial is standardized to length of the trial
        
        reaction_time = rt-time_stim;
        t1 = toc(t0);
        %% dynamic thresholding
        
        if stimulus == updated_threshold
            threshold_output_array = cat(1,threshold_output_array,[key,-1]);
            count_threshold = count_threshold + 1;
            
            % And if it is detected, and previous threshold stimulus was
            % detected, then reduce threshold
            
            % If participant responds "yes" 
            if key == yes 
                if (count_threshold > 1)
                    % so many possibilites of null pointer issues in the line
                    % below
                    if (threshold_output_array(count_threshold-1) == yes)
                        updated_threshold = updated_threshold - change;
                        threshold_output_array = [];
                        count_threshold = 0;
                    end
                end
                
                % If it wasn't detected, and previous two threshold stimuli weren't
                % detected, then increase threshold
            else
                if (count_threshold > 2)
                    % so many possibilites of null pointer issues in the line
                    % below
                    if (threshold_output_array(count_threshold-1) == no && threshold_output_array(count_threshold-2) == no)
                        updated_threshold = updated_threshold + change;
                        threshold_output_array = [];
                        count_threshold = 0;
                    end
                end
            end
        end        
        
    elseif trial_validity == is_both
        Screen('DrawTexture',windowPtr,red_cross_screen);
        Screen(windowPtr,'Flip');
        WaitSecs(3);
    end
    
    %% Output Array and breaks
    
    % Add a break every third of the task
    if (i == round(total_trials/3) || i == 2*round(total_trials/3))
        display_instructions(windowPtr,6);
    end
    
    % Check for quitting (= is to quit)
    if key == esc
        subject_quit = true;
        fprintf('The subject indicated they wanted to quit at Dynamic Thresholding.');
        Screen('CloseAll')
        break;
    end
    
    %Output data appropriately
    data = [i, RunTime, delay_time, stimulus, key, t1, reaction_time];
    output_array = cat(1,output_array,data);
    
    %Output data
    displayResponses(output_array)
    
    %% Responses into Structs
    stim(i) = struct('trial',i,'time',RunTime,'delay_time',delay_time,'stimulus',stimulus,'response',key,'runtime',t1,'reaction',reaction_time);
    
end

% allowing the variables to be returned
new_threshold = updated_threshold;
displayResponses(output_array, 'All')

end
