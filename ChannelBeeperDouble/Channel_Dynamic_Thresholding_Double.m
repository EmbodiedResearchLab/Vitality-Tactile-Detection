function [output_array,subject_quit,new_left_threshold, new_right_threshold, left, right] = Channel_Dynamic_Thresholding_Double(windowPtr,left_threshold,right_threshold)
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

% Do we want to always cue the same hand that we are going to stimulate or
% do we want to include other trials where we cue the wrong hand or don't
% cue a hand at all.
%% 1) Initialise Screens and other necessary variables

global initial_time
global trialtime
global fixation_time
global delay_times
global solid_black_screen
global green_cross_screen
global left_arrow_screen
global right_arrow_screen
global square_screen
global yes
global no
global esc

subject_quit = false;

Screen('DrawTexture',windowPtr,solid_black_screen);
Screen(windowPtr,'Flip');

WaitSecs(3);

%% 3) Initialize necessary variables - NUM_TRIALS IS HERE!!

%Desired number of trials on detection threshold (70% of time) intensity per hand
% out of these trials, .45 will go to each hand, and .1 will be specified as NOTHING (square)
% when something is directed to a hand, 70% will be as expected (@ threshold), 20% will be null, and 10% will be double threshold
% according to the math, there will be 800 total trials, leading to 252 alpha-modulated data points for each hand
total_trials = round(100/.7); % Cathy wanted 100 trials at threshold

square_trials = round(total_trials*0);
stim_trials = round(total_trials*1);

left_thresh_trials = round(stim_trials*.7)/2;
left_null_trials = round(stim_trials*.2)/2;
left_supra_trials = round(stim_trials*.1)/2;

right_thresh_trials = left_thresh_trials;
right_null_trials = left_null_trials;
right_supra_trials = left_supra_trials;

%{
percent_both = .1;
percent_real = 1 - percent_both;
both_trials = total_trials*percent_both;
real_trials = total_trials*percent_real;
%}

% this is to make an array with total_trials*percent_both 0's and total_trials*percent_real 1's
% this array will be used to choose whether to do a real trial (left or right arrow) or a both trial (square)
is_both = 0;
is_real = 1;

trial_type_values = [repmat(is_both,1,square_trials), repmat(is_real,1,stim_trials)];

% Initialize variables to store stimulus values
left_intensity = [0, left_threshold, left_threshold*2];
left_stim_values = [repmat(left_intensity(1),1,left_null_trials), repmat(left_intensity(2),1,left_thresh_trials), repmat(left_intensity(3),1,left_supra_trials)];
right_intensity = [0, right_threshold, right_threshold*2];
right_stim_values = [repmat(right_intensity(1),1,right_null_trials), repmat(right_intensity(2),1,right_thresh_trials), repmat(right_intensity(3),1,right_supra_trials)];

% this is where I will join two arrays, one for left hand and the other for right hand
% each of the joined arrays will have half the amount of real trials
num_hands = 2;
trials_per_hand = stim_trials/num_hands;
which_hand_values = [repmat({'Left'},1,trials_per_hand),repmat({'Right'},1,trials_per_hand)];

% 2 array with num_trials of each stimulus for each hand (1 array for each hand, left and right)
% the first repmat signifies the null trials, which are 20% of the real trials
% the second repmat signifies the modulation trials w/ tested intensity, which are 70% of the real trials
% the third repmat signifies the supra trials, which are 10% of the real trials

%Initializing variables to keep track of output
output_array = []; %overall output
% this is a X by 2 array, with the first column = left + second column = right
% whichever column is not being used will have a -1
threshold_output_array = []; %array that only stores responses from threshold stimuli
count_threshold = 0; %number of threshold stimuli

%The equivalent of .005 V (to increase or decrease the threshold by)
change = .01;

%value to store the changing threshold
left_threshold_changing = left_intensity(2);
right_threshold_changing = right_intensity(2);

t = trialtime - fixation_time;
left(trials_per_hand) = struct('trial', [], 'time',[], 'delay_time', [], 'stimulus', [], 'response', [], 'runtime', [], 'reaction',[]);
right(trials_per_hand) = struct('trial', [], 'time',[], 'delay_time', [], 'stimulus', [], 'response', [], 'runtime', [], 'reaction',[]);
if square_trials > 0
    square(square_trials) = struct('trial', [], 'stimulus', []);
end
%% 4) Actual presentation of stimuli and input of participant response
for i = 1:total_trials
%{    
    1) choose whether it's a real trial or a both (fake) trial
    THE FOLLOWING STEPS WILL ONLY TAKE ACCOUNT REAL TRIALS
    2) choose which hand it's for
    3) choose the random delay time (from 1000 to 1400 ms in 100ms increments)
    4) choose weighted random stimulus intensity for the hand in question
    5) display the left or right arrow picture to direct which hand to modulate attention to
    6) wait the chosen delay time
    7) deliver 10ms stimulus
    8) wait 2-delayTime-.01 (so that there has been a total of 2 s since cue)
    9) give user up to 1 s for response y or n
    10) Checks to see if the threshold needs to be changed and does so
    11) Outputs array of data
%}    
    t0 = tic;
    RunTime = GetSecs() - initial_time;
    % 1) choose whether it's a real trial or a both (fake) trial
    trial_validity_random = randi([1 size(trial_type_values,2)]);
    trial_validity = trial_type_values(trial_validity_random);
    %erase the value chosen, shrinking the trials to do by 1
    trial_type_values(trial_validity_random) = [];
    
    % if the trial is a null trial, I just need to wait 3 seconds
    if trial_validity == is_real

        % Choose which hand trial stimulates and deletes element from
        % randomization array.
        which_hand_random = randi([1 numel(which_hand_values)]);
        which_hand = which_hand_values(which_hand_random);
        which_hand_values(which_hand_random) = [];
        
        % 2) Choose the random delay time (from 1000 to 1400 ms in 100ms increments)
        rand_position_delay = randi([1 numel(delay_times)]);
        delay_time = delay_times(rand_position_delay);
        
        time = GetSecs();
        if strcmp(which_hand,'Left');
            % 3) choose weighted random stimulus intensity for the
            % stimulated hand.
            stim_values_random = randi([1 size(left_stim_values,2)]);
            %rand_stimulus_position = randi([1 size(left_initial_values,2)]);
            if left_stim_values(stim_values_random) == left_intensity(2)
                stimulus = left_threshold_changing;
            else
                stimulus = left_stim_values(stim_values_random);
            end
            %{    
            if (left_initial_values(rand_stimulus_position) == 0)
                stimulus = left_intensity(1);
            elseif (left_initial_values(rand_stimulus_position) == 1)
                stimulus = left_threshold_changing;
            elseif (left_initial_values(rand_stimulus_position) == 2)
                stimulus = left_intensity(3);
            end
            left_initial_values(rand_stimulus_position) = [];
            %}
            left_stim_values(stim_values_random) = [];
            
            % 4) Display the left or right arrow picture to direct which hand to modulate attention to
            nidaqTriggerInterface('on','Left'); % Turns on the square wave for digital trigger
            Screen('DrawTexture',windowPtr,left_arrow_screen);
            Screen(windowPtr,'Flip');
            
        elseif strcmp(which_hand,'Right');
            % 3) Choose weighted random stimulus intensity for the
            % stimulated hand.
            %rand_stimulus_position = randi([1 size(right_initial_values,2)]);
            stim_values_random = randi([1 size(right_stim_values,2)]);
            if right_stim_values(stim_values_random) == right_intensity(2)
                stimulus = right_threshold_changing;
            else
                stimulus = right_stim_values(stim_values_random);
            end
            right_stim_values(stim_values_random) = [];
            
            %{
            if (right_initial_values(rand_stimulus_position) == 0)
                stimulus = right_intensity(1);
            elseif (right_initial_values(rand_stimulus_position) == 1)
                stimulus = right_threshold_changing;
            elseif (right_initial_values(rand_stimulus_position) == 2)
                stimulus = right_intensity(3);
            end
            right_initial_values(rand_stimulus_position) = [];
            %}
            
            % 4) Display the left or right arrow picture to direct which hand to modulate attention to
            nidaqTriggerInterface('on','Right'); % Turns on the square wave for digital trigger
            Screen('DrawTexture',windowPtr,right_arrow_screen);
            Screen(windowPtr,'Flip');
        else
            fprintf('Whichever hand is being used is invalid');
            fprintf('which_hand_values: %d',which_hand_random)
            fprintf('which_hand: %s', which_hand)
        end
        nidaqTriggerInterface('off'); % Turns off the square wave for digital trigger
        
        % 5) Wait the chosen delay time
        WaitSecs(delay_time);
        
        % 6) Deliver 10ms stimulus
        time_stim = GetSecs();
        ChannelBeeperTrigger(100,stimulus,.01, which_hand);
        %ChannelBeeper(100,stimulus,.01,which_hand);
        
        % 7) Wait 2-delayTime-.01 (so that there has been a total of 2 s since cue)
        WaitSecs(fixation_time - delay_time - .01);
        
        % Draw green crosshair
        Screen('DrawTexture',windowPtr,green_cross_screen);
        Screen(windowPtr,'Flip');
        
        % 8) give user up to t seconds for response y or n
        
        % Checks for detection, gives
        [rt, keyCode, ~] = KbWait(-3, 2, GetSecs()+t);
        key = find(keyCode, 1);
        if isempty(key)
            key = 0;
        end
        nidaqTriggerInterface('on',which_hand,stimulus,key);
        nidaqTriggerInterface('off');
        WaitSecs(trialtime - (rt-time));
        
        reaction_time = rt-time_stim;
        t1 = toc(t0);
        %% Dynamic Threshold

        % Left Side
        if (strcmp(which_hand,'Left'))
            if (stimulus == left_threshold_changing)
                threshold_output_array = cat(1,threshold_output_array,[keyCode(30),-1]);
                count_threshold = count_threshold + 1;
                
                % And if it is detected, and previous threshold stimulus was
                % detected, then reduce threshold
                if key == yes
                    if (count_threshold > 1)
                        % so many possibilites of null pointer issues in the line
                        % below
                        if (threshold_output_array(count_threshold-1) == 1)
                            left_threshold_changing = left_threshold_changing - change;
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
                        if (threshold_output_array(count_threshold-1) == 0 && threshold_output_array(count_threshold-2) == 0)
                            left_threshold_changing = left_threshold_changing + change;
                            threshold_output_array = [];
                            count_threshold = 0;
                        end
                    end
                end
            end
            %right side
        elseif (strcmp(which_hand, 'Right'))
            if (stimulus == right_threshold_changing)
                threshold_output_array = cat(1,threshold_output_array,[-1,keyCode(30)]);
                count_threshold = count_threshold + 1;
                
                % And if it is detected, and previous threshold stimulus was
                % detected, then reduce threshold
                if key == yes
                    if (count_threshold > 1)
                        % so many possibilites of null pointer issues in the line
                        % below
                        if (threshold_output_array(count_threshold-1) == yes)
                            right_threshold_changing = right_threshold_changing - change;
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
                            right_threshold_changing = right_threshold_changing + change;
                            threshold_output_array = [];
                            count_threshold = 0;
                        end
                    end
                end
            end
        else
            printf('Issue in determining the hand');
            break;
        end
        
        %% Output Array and breaks
        
        % Add a break every third of the task
        if i == round(total_trials/3) || i == 2*round(total_trials/3)
            display_instructions(windowPtr,6);
        end
        
        %Check for quitting (= is to quit)
        if key == esc
            subject_quit = true;
            fprintf('The subject indicated they wanted to quit at Dynamic Thresholding.');
            Screen('CloseAll')
            break;
        end
        
    elseif trial_validity == is_both
        which_hand = {'square'};
        Screen('DrawTexture',windowPtr,square_screen);
        Screen(windowPtr,'Flip');
        WaitSecs(trialtime);
    else
        fprintf('There is an error in determining trial validity. The value of the trial validity in question is neither real or both');
    end
    %Output data appropriately
    data = [i, RunTime, delay_time, which_hand, stimulus, key, t1, reaction_time];
    output_array = cat(1,output_array,data);
    
    %Output data
    if strcmp(which_hand, 'Left')
        left(i) = struct('trial', i, 'time', t1, 'delay_time', data(3), 'stimulus', data(5), 'response', data(6), 'runtime', t1, 'reaction', reaction_time);
    elseif strcmp(which_hand, 'Right')
        right(i) =  struct('trial', i, 'time', t1, 'delay_time', data(3), 'stimulus', data(5), 'response', data(6), 'runtime', t1, 'reaction', reaction_time);
    else
        square(i) = struct('trial', i, 'stimulus', data(5));
    end
    displayResponses(output_array)
end

% allowing the variables to be returned
new_right_threshold = right_threshold_changing;
new_left_threshold = left_threshold_changing;
displayResponses(output_array, 'All')
end
