function [output_array,subject_quit] = TactileDetectionTask(windowPtr,left_threshold,right_threshold)
%{
My notes:
First, instructions will be set on the screen for five minutes or until the
participant presses any button. There will then be a black screen for 3
seconds to ready the participant. A green fixation cross will then appear
on the screen for 2 seconds, during which a tactile stimulus (either 100%
detection threshold, 66% detection threshold, or a blank) will be
delivered. 

Specifically, the stimulus will be delivered in fixed 100 ms
increments from 500 - 1500 ms increments. Following this, the green cross
will remain for another 500 ms, for a total of 2 s. The crosshair will then
switch to white, and the participant will have one second to indicate
whether they detected the stimulus ('y') or they did not ('n'). 

This loop (starting with the presentation of the green fixation cross) 
will continue for the indicated number of trials. 

From the IRB:
Each trial will consist of an initial white fixation cross to signal the
beginning of a trial. The fixation cross will change to the color green and
a 60 dB, 2 kHz tone will be deilivered to both ears to mask audible clicks
from the tactile stimulation apparatus. This tone will remain for 2.5
seconds in which either a tactile stimulus will be delivered at a
randomized time between 500 and 1000 ms (fixed 100 ms interval) after the
visual cue (change in fixation cross color). At the end of the 2.5 s visual
cue, and at least 400 ms after stimulation, participants will report
detection or nondetection of the stimulus. The next trial will begin 1
second after cessation of the visual cue. Stimuli will be presented at
three possible intensities (66% detection threshold, 100% detection
threshold, and null trials). Each block will consist of 144 trials lasting
7 minutes.
%}

global initial_time
global SoundChannel
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
total_trials = 200;
null = total_trials*.1;
supra = total_trials*.2;

%Initialize variables to store stimulus values
num_intensities = 3;
intensity = [0 detection_threshold detection_threshold*1.5];

if strcmp(channelDirection, 'Left')
    if stimulus == intensity(1)
        outputSingleScan(s, dec2binvec(1,8))
    elseif stimulus == intensity(2)
        outputSingleScan(s, dec2binvec(2,8))
    elseif stimulus == intensity(3)
        outputSingleScan(s, dec2binvec(3,8))
    end
elseif strcmp(channelDirection, 'Right')
    if stimulus == intensity(1)
        outputSingleScan(s, dec2binvec(4,8))
    elseif stimulus == intensity(2)
        outputSingleScan(s, dec2binvec(5,8))
    elseif stimulus == intensity(3)
        outputSingleScan(s, dec2binvec(6,8))
    end
end



%array with num_trials of each stimulus (for a total of 3*num_trials trials)
stimulus_initial_values = [repmat(intensity(1),1,null),repmat(intensity(2),1,num_trials),repmat(intensity(3),1,supra)];

%array with delay times
delay_times = [.5 .6 .7 .8 .9 1 1.1 1.2 1.3 1.4 1.5];

%variables to keep track of output
count =  0;
output_array = [];

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
    Beeper(100,stimulus,.01);
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
    
    output_array = cat(1,output_array,data);
    %Output data
    output_array(end,:)
    if (i == round(num_intensities*num_trials/3) || i == 2*round(num_intensities*num_trials/3))
        display_instructions(windowPtr,6)
    end
        %46 is equals
    if (keyCode(46) == 1)
        subject_quit = true;
        fprintf('The subject indicated they wanted to quit at Tactile Detection Task.');
        Screen('CloseAll')
        break;    
    end
end
    
    
    
%Screen('CloseAll')


