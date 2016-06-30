function [output_array,error_screen,subject_quit] = Channel_Training(windowPtr,train)
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
end

subject_quit = false;

Screen('DrawTexture',windowPtr,solid_black_screen);
Screen(windowPtr,'Flip');

%% 3) Initialize necessary variables - NUM_TRIALS IS HERE!!

%Desired number of trials per intensity
num_trials = 5;

%Initialize variables to store stimulus values
%% I believe that this would be different when we 
num_intensities = 2;
% 0 is a blank stimulus
intensity = [0 1];

%array with num_trials of each stimulus (for a total of 3*num_trials trials)
stimulus_initial_values = [repmat(intensity(1),1,num_trials),repmat(intensity(2),1,num_trials)];
hand_values = {'Left', 'Right'};
%array with delay times (in seconds)

t = trialtime - fixation_time;

%variables to keep track of output
count =  0;
output_array = [];
error_count = 0;
error_screen = false;

%% 4) Actual presentation of stimuli and input of participant response
for i = 1:num_intensities*num_trials
    t0 = tic;
    % 1) choose random stimulus intensity
    % 2) choose random delay time (from 500 ms to 1500 ms)
    % 3) choose which hand
    % 4) display the right or left arrow according to whichever hand it is
    % 5) deliver stimulus in fixed 100 ms interval 1000 - 1400 ms after
    % presentation of red crosshair
    % 6) Wait an additional 500 ms (so total of 2.5 s since cue)
    % 7) displays green crosshair
    % 8) gives user up to 1 s for response y or n
    % 9) repeats loop
    
    
    % Choose random stimulus, and then erase it from initial array
    rand_position = randi([1 size(stimulus_initial_values,2)]);
    stimulus = stimulus_initial_values(rand_position);
    
    % Assigns a blank value to the rand_position
    stimulus_initial_values(rand_position) = [];
    
    %Choose random delay time
    % the number of columns
    rand_position_delay = randi([1 size(delay_times,2)]);
    delay_time = delay_times(rand_position_delay);

    which_hand = hand_values(randi(2));

    % Left Hand
    if strcmp(which_hand, 'Left')
        Screen('DrawTexture',windowPtr,left_arrow_screen);
        Screen(windowPtr,'Flip');
        WaitSecs(delay_time);
        
        %Deliver Stimulus
        time = GetSecs() - initial_time;
        ChannelBeeper(100,stimulus,.01,'Left');
    % right hand
    elseif strcmp(which_hand, 'Right')
        Screen('DrawTexture',windowPtr,right_arrow_screen);
        Screen(windowPtr,'Flip');
        WaitSecs(delay_time);
        
        %Deliver Stimulus
        time = GetSecs() - initial_time;
        ChannelBeeper(100,stimulus,.01,'Right');
    end
    % Ensure that the fixation screen is present for 'fixation_time' secs
    WaitSecs(fixation_time - delay_time - .01)
    
    %Draw green crosshair
    Screen('DrawTexture',windowPtr,green_cross_screen);
    Screen(windowPtr,'Flip');
    
    % Records Participant's Response
    [rt, keyCode, ~] = KbWait(-3, 2, GetSecs()+t);
        key = find(keyCode, 1);
        if isempty(key)
            key = 0;
        end
    % with the above line of code, keypress is standardized to 2 seconds
    WaitSecs(trialtime - (rt-time));
    
    %NEED TO DEFINE REACTION TIME (6.29.16 BC); e.g. "reaction_time = rt-time_stim;" (from Channel_Training.m for single hand) 
    t1 = toc(t0);
    
    %% Output data appropriately
    if or((stimulus == intensity(1) && key == yes), (stimulus == intensity(2) && key ~= yes))
        error_count = error_count + 1;
    end
    
    count = count + 1;
    data = [count, time, delay_time, which_hand, stimulus, keyCode(30), t1,reaction_time, error_count];
    
    %46 is equals
    if key == esc
        subject_quit = true;
        fprintf('The subject indicated they wanted to quit at Training Block %1.0f.\n',train);
        %When flushed, as part of its exit sequence, Screen closes all its
        %windows, restores the screen's normal color table, and shows the cursor. Or you
        %can get just those effects, without flushing, by calling Screen('CloseAll')
        %or sca - which is an abbreviation for Screen('CloseAll').
        Screen('CloseAll') 
        break;
    end

    if error_count >= 3
        error_screen = true;
    end
    
    output_array = cat(1,output_array,data);
    
    %Output data
    displayResponses(output_array, 'Error') 

end

if error_screen
    fprintf('Training %1.0f was incorrectly done.  Check connections, Power Supply, and Volume Settings.\n',train);
end

displayResponses(output_array,'All')

end