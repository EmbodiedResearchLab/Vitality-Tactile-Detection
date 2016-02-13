function [output_array,error_screen,subject_quit] = Training_Block_2(windowPtr)
%{

%}
global initial_time
global SoundHandle
subject_quit = false;
%Initialize crosshair images and screens
green_cross = imread('crosshair_green.png');
red_cross = imread('crosshair_red.png');
solid_black = imread('solid_black.png');
green_cross_screen = Screen('MakeTexture',windowPtr,green_cross);
red_cross_screen = Screen('MakeTexture',windowPtr,red_cross);
solid_black_screen = Screen('MakeTexture',windowPtr,solid_black);

Screen('DrawTexture',windowPtr,solid_black_screen);
Screen(windowPtr,'Flip');

WaitSecs(3);

%% 3) Initialize necessary variables - NUM_TRIALS IS HERE!!

%Desired number of trials per intensity
num_trials = 5;

%Initialize variables to store stimulus values
num_intensities = 2;
intensity_1 = 0;
intensity_2 = 1; %whatever 350 um is

%array with num_trials of each stimulus (for a total of 3*num_trials trials)
stimulus_initial_values = [repmat(intensity_1,1,num_trials),repmat(intensity_2,1,num_trials)];

%array with delay times
delay_times = [.5 .6 .7 .8 .9 1 1.1 1.2 1.3 1.4 1.5];

%variables to keep track of output
count =  0;
output_array = [];
error_count = 0;
error_screen = false;

%% 4) Actual presentation of stimuli and input of participant response
for (i = 1:num_intensities*num_trials)
    
    % 1) choose random stimulus intensity
    % 2) choose random delay time (from 500 ms to 1500 ms)
    % 3) display red cross hair
    % 4) deliver stimulus in fixed 100 ms interval 500 - 1500 ms after
    % presentation of red crosshair
    % 5) Wait an additional 500 ms (so total of 2 s since cue)
    % 6) displays green crosshair
    % 7) gives user up to 1 s for response y or n
    % 8) repeats loop
    
    
    %Choose random stimulus, and then erase it from initial array
    rand_position = randi([1 size(stimulus_initial_values,2)]);
    stimulus = stimulus_initial_values(rand_position);
    stimulus_initial_values(rand_position) = [];
    
    %Choose random delay time
    rand_position_delay = randi([1 size(delay_times,2)]);
    delay_time = delay_times(rand_position_delay);
    
    %Draw red crosshair
    Screen('DrawTexture',windowPtr,red_cross_screen);
    Screen(windowPtr,'Flip');
    
    WaitSecs(delay_time);
    
    %Deliver Stimulus
    time = GetSecs() - initial_time;
    ChannelBeeper(100,stimulus,.01,'Left');
    WaitSecs(2 - delay_time - .01)
    
    %Draw green crosshair
    Screen('DrawTexture',windowPtr,green_cross_screen);
    Screen(windowPtr,'Flip');
    
    % Checks for detection, gives
    [s, keyCode, delta] = KbWait(-3, 2, GetSecs()+1);
    
    WaitSecs(1 - delta);
    
    %Output data appropriately
    count = count + 1;
    data = [count, time, delay_time, stimulus, keyCode(30)];
    
    if (stimulus == intensity_1 && keyCode(30) == 1)
        
        error_count = error_count + 1;
        
    elseif (stimulus == intensity_2 && keyCode(30) == 0)
        
        error_count = error_count + 1;
        
    end
        %46 is =
    if (keyCode(46) == 1)
        subject_quit = true;
        fprintf('The subject indicated they wanted to quit at Training Block 2.');
        Screen('CloseAll')
        break;
    end
    
    if (error_count >= 3)
        error_screen = true;
    end
    
    output_array = cat(1,output_array,data);
    %Output data
    output_array(end,:)
    error_count
end

if (error_screen)
    fprintf('Training 2 was incorrectly done.');
end



%Screen('CloseAll')


