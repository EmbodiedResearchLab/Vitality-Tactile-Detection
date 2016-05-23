function [output_array,error_screen,subject_quit] = Channel_Training_Block_1(windowPtr)
%{
%For timings add .5 s before each of the delay_times as well as .5 s after,
so there is a total of 1s more of the red cross. Also add 1 more second for
response - so each trial is 2 seconds longer.

This is for 1 hand, so signal will be sent exclusively to the left hand.

%}

global initial_time
global trialtime
global fixation_time
global solid_black_screen
global green_cross_screen
global white_cross_screen
global delay_times

subject_quit = false;

%Initialize crosshair images and screens

Screen('DrawTexture',windowPtr,solid_black_screen);
Screen(windowPtr,'Flip');

%% 3) Initialize necessary variables - NUM_TRIALS IS HERE!!

%Initialize variables to store stimulus values
% 0 is a blank stimulus
intensity = [0 1]; %whatever 350 um is

%array with num_trials of each stimulus (for a total of 3*num_trials trials)
stimulus_initial_values = [repmat(intensity(1),1,2),repmat(intensity(2),1,8)];

%variables to keep track of output
count =  0;
output_array = [];
Error_Count = 0;
error_screen = false;
trialtime = trialtime + .5;
t = trialtime-fixation_time;

%% 4) Actual presentation of stimuli and input of participant response
while ~isempty(stimulus_initial_values)  
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
    
    
    %Choose random stimulus, and then erase it from initial array
    rand_position = randi([1 size(stimulus_initial_values,2)]);
    stimulus = stimulus_initial_values(rand_position);
    stimulus_initial_values(rand_position) = [];
    
    %Choose random delay time
    % the number of columns
    rand_position_delay = randi([1 size(delay_times,2)]);
    delay_time = delay_times(rand_position_delay);

    %% Delivering Stimuli
    Screen('DrawTexture', windowPtr, white_cross_screen);
    Screen(windowPtr,'Flip');
    
    % Deliver Stimulus
    WaitSecs(delay_time); % Wait randomized delay_time
    time = GetSecs() - initial_time;
    ChannelBeeper(100,stimulus,.01,'Left');
    WaitSecs(fixation_time-delay_time-.01); % White_cross_screen displayed for lenght of fixation_time
    
    %Draw green crosshair
    Screen('DrawTexture', windowPtr, green_cross_screen);
    Screen(windowPtr,'Flip');
    
    % Waits for a keyPress for up to seconds.
    [~, keyCode, s] = KbWait(-3, 2, GetSecs()+t);
    WaitSecs(t - s);
    
    t1 = toc(t0);
    
    %% Evaluating Response
    %keyCode(30) is up arrow)
    if or((stimulus == intensity(1) && keyCode(30) == 1), (stimulus == intensity(2) && keyCode(30) == 0))
        Error_Count = Error_Count + 1;
    end
        %46 is equals
    if (keyCode(46) == 1)
        subject_quit = true;
        fprintf('The subject indicated they wanted to quit at Training Block 1.');
        %When flushed, as part of its exit sequence, Screen closes all its
        %windows, restores the screen's normal color table, and shows the cursor. Or you
        %can get just those effects, without flushing, by calling Screen('CloseAll')
        %or sca - which is an abbreviation for Screen('CloseAll').
        Screen('CloseAll') 
        break;
    end
    
    %Output data appropriately
    count = count + 1;
    data = [count, time, delay_time, stimulus, keyCode(30), t1];
    
    if Error_Count >= 3
        error_screen = true;
    end
     
    output_array = cat(1,output_array,data);
    displayResponses(output_array)
    fprintf('Error: %1.0f.\n', Error_Count)

end

if (error_screen)
    fprintf('Training 1 was incorrectly done.  Check connections, Power Supply, and Volume Settings.');
end
displayResponses(output_array,'All')
