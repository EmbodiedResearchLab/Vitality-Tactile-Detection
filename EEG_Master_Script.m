%EEG Group Master Script - Dynamic Thresholding

%This script will contain the following procedure:

%Set up - 30 min
% 1) Dipole Creation -- 6 minutes, 10 seconds
% 2) Training Blocks (1+2) -- 2.5 minutes
% 2) PEST - 3 min
% 3) Tacti1leDetection Task - 20 min

% Clean up - 20 min
% then repeat for the two control conditions
%
%
%% Initializing Psychtoolbox functions
%Initialize Psych Sound

% Clear the workspace
clear all;
close all;
sca;

% initializes screens to 1, which means it will always refer to the extra
% monitor, not to the computer that has the code.
setGlobalVariables();
global screens
global SoundHandle

%% Prep for Save.  Experimenter Inputs
subjectID = input('Subject ID: ','s'); % Identify Subject ID for to save data
medTraining = input('Press "0" if this is before meditation training.  Otherwise, Press "1": ');  % 0 if pre-training, 1 if post
Directory = pwd; % Finds the directory to save into
% makes directories into strings
premed = strcat(Directory,'Pre-Med Training');
postmed = strcat(Directory,'Post-Med Training');
medit = strcat(Directory,'Meditators');
testing = strcat(Directory,'Testing');

% Makes the proper directory if it doesn't already exist.
if exist(premed) ~= 7
    mkdir('Pre-Med Training');
elseif exist(postmed) ~= 7
    mkdir('Post-Med Training');
elseif exist(medit) ~= 7
    mkdir('Meditators');
elseif exist(testing) ~= 7
    mkdir('Testing');
end

% I do global SoundHandle on each and every function, is that alright?  
% Or is it bad in terms of global variables?


InitializePsychSound(1);
SamplingFreq = 44100;
NbChannels = 2;
SoundHandle = PsychPortAudio('Open',[],[],2,SamplingFreq,NbChannels);

%Initialize Parameters so screen() doesn't crash
%
% Screen('Preference','SyncTestSettings' [, maxStddev=0.001 secs][, minSamples=50][, maxDeviation=0.1][, maxDuration=5 secs]);
%
% 'maxStddev' selects the amount of tolerable noisyness, the standard
% deviation of measured timing samples from the computed mean. We default
% to 0.001, ie., 1 msec.
%
% 'minSamples' controls the minimum amount of valid measurements to be
% taken for successfull tests: We require at least 50 valid samples by
% default.
%
% 'maxDeviation' sets a tolerance threshold for the maximum percentual
% deviation of the measured video refresh interval duration from the
% duration suggested by the operating system (the nominal value). Our
% default setting of 0.1 allows for +/- 10% of tolerance between
% measurement and expectation before we fail our tests.
%
% 'maxDuration' Controls the maximum duration of a single test run in
% seconds. We default to 5 seconds per run, with 3 repetitions if
% neccessary. A well working system will complete the tests in less than 1
% second though.
%
% Empirically we've found that especially Microsoft Windows Vista and
% Windows-7 may need some tweaking of these parameters, as some of those
% setups do have rather noisy timing.
% %

Screen('Preference','SyncTestSettings',[.005],[50],[.5],[5]);

%Open first screen, solid black
[windowPtr, rect] = Screen('OpenWindow',screens,[0 0 0]);

%% Establishing the dipole movement

% Expected time: 6 minutes + 10 seconds

[subject_quit_dipole_creation, initial_time_dipole_creation, time_list] = Dipole_Creation(windowPtr);
if (subject_quit_dipole_creation)
    return
end


%% 1) Display Instructions + Training Block (expected time: 4 minutes)
sprintf('Display Instructions and Training Block')
not_understand_task_1 = true;
not_understand_task_2 = true;

% whenever display_instructions is called, the screen will display an image
% that has the instructions on it.
display_instructions(windowPtr,1);
display_instructions(windowPtr,2);
%Training Blocks

while (not_understand_task_1)
    
    % does the first block of training, which tests only right hand
    [output_array_training_1,error_1,subject_quit_training_1] = Channel_Training_Block_1(windowPtr);
    
    if (error_1)
        fprintf('Repeat Training 1');
        display_instructions(windowPtr,4)
    else
        not_understand_task_1 = false;
    end
    
    if (subject_quit_training_1)
        return
    end
end

display_instructions(windowPtr,3);

%training task 2 is slightly quicker than training task 1, and it tests left hand
while (not_understand_task_2)
    [output_array_training_2,error_2,subject_quit_training_2] = Channel_Training_Block_2(windowPtr);
    if (error_2)
        fprintf('Repeat Training 2')
        display_instructions(windowPtr,4)
    else
        not_understand_task_2 = false;
        
    end
    
    if (subject_quit_training_2)
        return
    end
end

display_instructions(windowPtr,3.5);


%% 2) Go into PEST Convergence Procedure

% The PEST Convergence Procedure should be done for each hand, so how would we do that?

%first we do PEST on the left side
sprintf('PEST Convergence Procedure')
[detection_threshold_left,output_array_PEST_left,subject_quit_PEST] = PEST_Convergence_Procedure(windowPtr, 'Left');

if (subject_quit_PEST)
    return
end

while (detection_threshold_left == 1)
    display_instructions(windowPtr,4)
    [detection_threshold_left,output_array_PEST_left, subject_quit_PEST] = PEST_Convergence_Procedure(windowPtr, 'Left');

    if (subject_quit_PEST)
        return
    end
end

save('detection_threshold_left.mat');

% next we do PEST on the right side

[detection_threshold_right,output_array_PEST_right,subject_quit_PEST] = PEST_Convergence_Procedure(windowPtr, 'Right');

if (subject_quit_PEST)
    return
end

while (detection_threshold_right == 1)
    display_instructions(windowPtr,4)
    [detection_threshold_right,output_array_PEST_right, subject_quit_PEST] = PEST_Convergence_Procedure(windowPtr, 'Right');

    if (subject_quit_PEST)
        return
    end
end

save('detection_threshold_right.mat');

%% 3) Tactile Detection Task
% also, is this correct MATLAB formatting w/ the ellipsis?
sprintf('Tactile Detection Task')
[tactile_detection_task_data,subject_quit_tactile_detection,final_left_threshold, final_right_threshold] = ...
    Channel_Dynamic_Thresholding(windowPtr,detection_threshold_left, detection_threshold_right);

save('tactile_detection_task.mat');

if (subject_quit_task_1)
    
    return
    
end
%}



display_instructions(windowPtr,7);

Screen('CloseAll')


if medTraining == 0 % Before Meditation
    saveDir = strcat(Directory,'/Pre-Med Training/Participant_', subjectID);
    save(fullfile(saveDir),'subjectID','detection_threshold_left','detection_threshold_right','output_array_tactile_detection_1','final_left_threshold','final_right_threshold')
elseif medTraining == 1
    saveDir = strcat(Directory,'/Post-Med Training/Participant_', subjectID);
    save(fullfile(saveDir),'subjectID','detection_threshold_left','detection_threshold_right','output_array_tactile_detection_1','final_left_threshold','final_right_threshold')
elseif medTraining == 2
    saveDir = strcat(Directory,'/Meditators/Participant_', subjectID);
    save(fullfile(saveDir),'subjectID','detection_threshold_left','detection_threshold_right','output_array_tactile_detection_1','final_left_threshold','final_right_threshold')
elseif medTraining == 3
    saveDir = strcat(Directory,'/Testing/Participant_', subjectID);
    save(fullfile(saveDir),'subjectID','detection_threshold_left','detection_threshold_right','output_array_tactile_detection_1','final_left_threshold','final_right_threshold')
end

