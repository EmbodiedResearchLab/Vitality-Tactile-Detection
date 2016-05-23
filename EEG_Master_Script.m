%EEG Group Master Script - Dynamic Thresholding

%This script will contain the following procedure:

% Set up - 30 min
% 1) Dipole Creation -- 6 minutes, 10 seconds
% 2) Training Blocks (1+2) -- 2.5 minutes
% 2) PEST - 3 min
% 3) Tacti1leDetection Task - 20 min

% Clean up - 20 min
% then repeat for the two control conditions

%% Clear the workspace
clear all; %#ok<CLALL>
close all;
sca;
global stimulators
global screens
%global windowPtr


%% Prep for Save.  Experimenter Inputs
subjectID = input('Subject ID: ','s'); % Identify Subject ID for to save data
medTraining = input('0 - PreMeditation Training.\n1 - PostMeditation Training.\n2 - Meditators.\n3 - Debugging: '); %Press "0" if this is before meditation training.  Otherwise, Press "1": ');  % 0 if pre-training, 1 if post

% Screens = 1 if using a second screen or 0 if using the same computer
% screen that is running the script.
screens = 1;
stimulators = 0;

% You can change the limitations of the while statements if you're using
% more than two stimulators so long as there is an appropriate folder that
% accomodates the number of stimulators desired.
while ~ismember(stimulators, [1 2])
    stimulators = input('How many stimulators are being used? ');
    if ~ismember(stimulators, [1 2])
        fprintf('Stimulators must be an integer (1 or 2)\n')
    elseif stimulators == 1
        fprintf('\n~~~~~~~~~~\nEnsure that the LEFT audio signal is used for the tactile stimulator.\nThe RIGHT audio signal may be used to time lock events.\n~~~~~~~~~~\n')
    end
end

% Changes the script that would run based on the number of stimulators
% present as provided by the user.
if stimulators == 1
    addpath('ChannelBeeperSingle')
else
    addpath('ChannelBeeperDouble')
end

% makes directories into strings
premed = strcat(pwd,'/Pre-Med Training');
postmed = strcat(pwd,'/Post-Med Training');
medit = strcat(pwd,'/Meditators');
testing = strcat(pwd,'/Testing');

% Makes the proper directory if it doesn't already exist.
if exist(premed,'dir') ~= 7
    mkdir('Pre-Med Training');
elseif exist(postmed,'dir') ~= 7
    mkdir('Post-Med Training');
elseif exist(medit,'dir') ~= 7
    mkdir('Meditators');
elseif exist(testing,'dir') ~= 7
    mkdir('Testing');
end

%% Initializing Psychtoolbox functions

[windowPtr, ~] = setGlobalVariables();

%% Establishing the dipole movement

% Expected time: 6 minutes + 10 seconds
t_start_subject = tic;
%{
[subject_quit_dipole_creation, initial_time_dipole_creation, time_list] = Dipole_Creation(windowPtr);
if (subject_quit_dipole_creation)
    return
end
%}

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

%% Saving Protocols
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
    save(fullfile(saveDir),'initial_time','subjectID','detection_threshold_left','detection_threshold_right','output_array_tactile_detection_1','final_left_threshold','final_right_threshold')
end

sca;
fprintf('Ready for next participant!\n')
