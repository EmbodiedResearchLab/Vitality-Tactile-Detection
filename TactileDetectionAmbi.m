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
left_arrow = imread('left_arrow.png');
right_arrow = imread('right_arrow.png');
square = imread('square.png');

green_cross_screen = Screen('MakeTexture',windowPtr,green_cross);
red_cross_screen = Screen('MakeTexture',windowPtr,red_cross);
solid_black_screen = Screen('MakeTexture',windowPtr,solid_black);
left_arrow_screen = Screen('MakeTexture',windowPtr,left_arrow);
right_arrow_screen = Screen('MakeTexture',windowPtr, right_arrow);
square_screen = Screen('MakeTexture', windowPtr, right_arrow);


Screen('DrawTexture',windowPtr,solid_black_screen);
Screen(windowPtr,'Flip');

WaitSecs(3);

%% 3) Initialize necessary variables - NUM_TRIALS IS HERE!!

%Desired number of trials on detection threshold (70% of time) intensity per hand
% out of these trials, .45 will go to each hand, and .1 will be specified as NOTHING (square)
% when something is directed to a hand, 70% will be as expected (@ threshold), 20% will be null, and 10% will be double threshold
% according to the math, there will be 800 total trials, leading to 252 alpha-modulated data points for each hand
total_trials = 800; 

percent_both = .1;
percent_real = 1 - percent_both;
both_trials = total_trials*percent_both;
real_trials = total_trials*percent_real;

% this is to make an array with total_trials*percent_both 0's and total_trials*percent_real 1's
% this array will be used to choose whether to do a real trial (left or right arrow) or a both trial (square)
is_both = 0;
is_real = 1;

trial_type_values = [repmat(is_both,1,both_trials), repmat(is_real,1,real_trials)];

% this is where I will join two arrays, one for left hand and the other for right hand
% each of the joined arrays will have half the amount of real trials
num_hands = 2;
trials_per_hand = real_trials/num_hands;
which_hand_values = [repmat('Left',1,trials_per_hand),repmat('Right',1,trials_per_hand)];



% desired number of total trials

%Initialize variables to store stimulus values
left_null_trial_intensity = 0;
left_tested_intensity = left_threshold;
left_suprathreshold_intensity = left_threshold*2;

right_null_trial_intensity = 0;
right_tested_intensity = right_threshold;
right_suprathreshold_intensity = right_threshold*2;



% 2 array with num_trials of each stimulus for each hand (1 array for each hand, left and right)
% the first repmat signifies the null trials, which are 20% of the real trials
% the second repmat signifies the modulation trials w/ tested intensity, which are 70% of the real trials
% the third repmat signifies the 

left_initial_values = [repmat(left_null_trial_intensity,1,trials_per_hand*.2),repmat(left_tested_intensity,1,trials_per_hand*.7),repmat(left_suprathreshold_intensity,1,trials_per_hand*.1)];
right_initial_values = [repmat(right_null_trial_intensity,1,trials_per_hand*.2),repmat(tested_intensity,1,trials_per_hand*.7),repmat(suprathreshold_intensity,1,trials_per_hand*.1)];


% array with delay times
delay_times = [1 1.1 1.2 1.3 1.4];

%variables to keep track of output
count =  0;
output_array = [];


%% 4) Actual presentation of stimuli and input of participant response
for (i = 1:total_trials)
    
    % 1) choose whether it's a real trial or a both (fake) trial
    % THE FOLLOWING STEPS WILL ONLY TAKE ACCOUNT REAL TRIALS
    % 2) choose which hand it's for
    % 3) choose the random delay time (from 1000 to 1400 ms in 100ms increments)
    % 4) choose weighted random stimulus intensity for the hand in question
    % 5) display the left or right arrow picture to direct which hand to modulate attention to
    % 6) wait the chosen delay time
    % 7) deliver 10ms stimulus
    % 8) wait 2-delayTime-.01 (so that there has been a total of 2 s since cue)
    % 9) give user up to 1 s for response y or n
    % 10) repeat loop


    % 1) choose whether it's a real trial or a both (fake) trial
    trial_validity_random = randi([1 size(trial_type_values,2)]);
    trial_validity = trial_type_values(trial_validity_random);
    %erase the value chosen, shrinking the trials to do by 1
    trial_type_values(trial_validity_random) = [];

    % if the trial is a null trial, I just need to wait 3 seconds
    if trial_validity == is_real

        % 2) choose which hand it's for
        which_hand_random = randi([1 size(which_hand_values,2)]);
        which_hand = which_hand_values(which_hand_random);
        %erase the value chosen, shrinking the trials to do by 1
        which_hand_values(which_hand_random) = [];

        % 3) choose the random delay time (from 1000 to 1400 ms in 100ms increments)
        rand_position_delay = randi([1 size(delay_times,2)]);
        delay_time = delay_times(rand_position_delay);

        % 4) choose weighted random stimulus intensity for the hand in question
        %initialize the stimulus variable
        % 5) display the left or right arrow picture to direct which hand to modulate attention to


        stimulus = -1;

        if strcmp(which_hand,'Left');
            %Choose random stimulus, and then erase it from initial array
            rand_stimulus_position = randi([1 size(left_initial_values,2)]);
            stimulus = left_initial_values(rand_stimulus_position);
            left_initial_values(rand_stimulus_position) = [];

            Screen('DrawTexture',windowPtr,left_arrow_screen);
            Screen(windowPtr,'Flip');

        else strcmp(which_hand,'Right');
            rand_stimulus_position = randi([1 size(right_initial_values,2)]);
            stimulus = right_initial_values(rand_stimulus_position);
            left_initial_values(rand_stimulus_position) = [];

            Screen('DrawTexture',windowPtr,right_arrow_screen);
            Screen(windowPtr,'Flip');

        else
            printf('Whichever hand is being used is invalid');
            which_hand_random
            which_hand
        end

        % 6) wait the chosen delay time






    elseif trial_validity == is_both
        Screen('DrawTexture',windowPtr,square_screen);
        Screen(windowPtr,'Flip');
        WaitSecs(3);
    else
        printf('There is an error in determining trial validity.  ' ... 
            'The value of the trial validity in question is neither real or both');
    end

    
    
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
    if (i == round(total_trials/3) || i == 2*round(total_trials/3))
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


