function [output_array,error_screen,subject_quit] = Channel_Training_Double(windowPtr,train,varargin)
%{
%For timings add .5 s before each of the delay_times as well as .5 s after,
so there is a total of 1s more of the red cross. Also add 1 more second for
response - so each trial is 2 seconds longer.

%}
global initial_time
global trialtime
global fixation_time
global delay_times
global solid_black_screen
global green_cross_screen
global left_arrow_screen
global right_arrow_screen
global yes
global esc

if train == 1
    trialtime = trialtime + .5;
    left_intensity = [0 1];
    right_intensity = [0 1];
else
    left_intensity = [0 2*varargin{1}];
    right_intensity = [0 2*varargin{2}];
end

subject_quit = false;

Screen('DrawTexture',windowPtr,solid_black_screen);
Screen(windowPtr,'Flip');

%% 3) Initialize necessary variables - NUM_TRIALS IS HERE!!

%Desired number of trials per intensity
total_trials = 20;

square_trials = round(total_trials*0);
stim_trials = round(total_trials*1);

is_both = 0;
is_real = 1;
trial_type_values = [repmat(is_both,1,square_trials), repmat(is_real,1,stim_trials)];

%Initialize variables to store stimulus values
%% I believe that this would be different when we 
%array with num_trials of each stimulus (for a total of 3*num_trials trials)
left_stim_values = [repmat(left_intensity(1),1,2), repmat(left_intensity(2),1,8)];
right_stim_values = [repmat(right_intensity(1),1,2), repmat(right_intensity(2),1,8)];
    
trials_per_hand = stim_trials/2;
which_hand_values = [repmat({'Left'},1,trials_per_hand), repmat({'Right'},1,trials_per_hand)];
%array with delay times (in seconds)

t = trialtime - fixation_time;

%variables to keep track of output
output_array = [];
Error_Count = 0;
error_screen = false;

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
    % 1) choose whether it's a real trial or a both (fake) trial
    trial_validity_random = randi([1 size(trial_type_values,2)]);
    trial_validity = trial_type_values(trial_validity_random);
    %erase the value chosen, shrinking the trials to do by 1
    trial_type_values(trial_validity_random) = [];
    
    % if the trial is a null trial, I just need to wait 3 seconds
    if trial_validity == is_real
        t0 = tic;
        RunTime = GetSecs() - initial_time;
    
        % Choose which hand trial stimulates and deletes element from
        % randomization array.
        which_hand_random = randi([1 numel(which_hand_values)]);
        which_hand = which_hand_values(which_hand_random);
        which_hand_values(which_hand_random) = [];
        
        % 2) Choose the random delay time (from 1100 to 1500 ms in 100ms increments)
        rand_position_delay = randi([1 numel(delay_times)]);
        delay_time = delay_times(rand_position_delay);
        
        if strcmp(which_hand,'Left');
            % 3) choose weighted random stimulus intensity for the
            % stimulated hand.
            stim_values_random = randi([1 size(left_stim_values,2)]);
            stimulus = left_stim_values(stim_values_random);
            left_stim_values(stim_values_random) = [];
            
            
            % 4) Display the left or right arrow picture to direct which hand to modulate attention to
            time_cue = GetSecs();
            Screen('DrawTexture',windowPtr,left_arrow_screen);
            Screen(windowPtr,'Flip');
            
        elseif strcmp(which_hand,'Right');
            % 3) Choose weighted random stimulus intensity for the
            % stimulated hand.
            %rand_stimulus_position = randi([1 size(right_initial_values,2)]);
            stim_values_random = randi([1 size(right_stim_values,2)]);
            stimulus = right_stim_values(stim_values_random);
            right_stim_values(stim_values_random) = [];

            % 4) Display the left or right arrow picture to direct which hand to modulate attention to
            time_cue = GetSecs();
            Screen('DrawTexture',windowPtr,right_arrow_screen);
            Screen(windowPtr,'Flip');
        else
            fprintf('Whichever hand is being used is invalid');
            fprintf('which_hand_values: %d',which_hand_random)
            fprintf('which_hand: %s', which_hand)
        end
        
        % 5) Wait the chosen delay time
        WaitSecs(delay_time);
        % 6) Deliver 10ms stimulus
        ChannelBeeper(100,stimulus,.01, which_hand);
        %ChannelBeeper(100,stimulus,.01,which_hand);
        
        % 7) Wait 2-delayTime-.01 (so that there has been a total of 2 s since cue)
        WaitSecs(fixation_time - delay_time - .01);
        
        % Draw green crosshair
        Screen('DrawTexture',windowPtr,green_cross_screen);
        time_green = Screen(windowPtr,'Flip');
        
        % 8) give user up to t seconds for response y or n
        [rt, keyCode, ~] = KbWait(-3, 2, GetSecs()+t);
        key = find(keyCode, 1);
        if isempty(key)
            key = 0;
        end
        WaitSecs(trialtime - (rt-time_cue));
        
        reaction_time = rt-time_green;
        t1 = toc(t0);
    end
    
%% Evaluating Response
    if or(or(stimulus == left_intensity(1), stimulus == right_intensity(1)) && or(key == yes, key == 0), or(stimulus == left_intensity(2), stimulus == right_intensity(2)) && key ~= yes)
        Error_Count = Error_Count+1;
    end
    
    if key == esc
        subject_quit = true;
        fprintf('The subject indicated they wanted to quit at Training Block %1.0f.', train);
        sca
        break;
    end
    
    data = [i, RunTime, delay_time, which_hand, stimulus, key, t1, reaction_time, Error_Count];
    
    if Error_Count >= 5
        error_screen = true;
    end
    
    output_array = cat(1,output_array,data);
    displayResponses(output_array,'Error')
end

if error_screen
    fprintf('Training %1.0f was incorrectly done.  Check connections, Power Supply, and Volume Settings.\n',train);
end

displayResponses(output_array,'All');

end