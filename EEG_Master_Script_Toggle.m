%% EEG Group Master Script w/ Stimulator Toggle

% This script will contain the following procedure:

% Set up - 30 min
% 1) Dipole Creation -- 6 minutes, 10 seconds
% 2) Training Blocks (1+2) -- 2.5 minutes
% 3) PEST - 3 minutes
% 4) Tactile Detection Task - 20 minutes

% Clean up - 20 minutes
% then repeat for the two control conditions

%% Clear Workspace
% Clear the workspace
clear all; %#ok<CLALL>
close all;
sca; % Screen('CloseAll')
global stimulators

t_start_subject = tic;

%% Prep for Save. Experimenter Inputs
subjectID = input('SubjectID: ','s'); % Identify Subject ID as a string to save data.
medTraining = input('0 - Premeditation Training.\n1 - PostMeditation Training.\n2 - Meditators.\n3 - Debugging: '); % If this is cross-sectional, just use "0".

stimulators = 0;
while ~ismember(stimulators, [1 2])
    stimulators = input('How many stimulators are being used? ');
    if ~ismember(stimulators, [1 2])
        fprintf('Stimulators must be an integer (1 or 2)\n')
    elseif stimulators == 1
        fprintf('\n~~~~~~~~~~\nEnsure that the LEFT audio signal is used for the tactile stimulator.\nThe RIGHT audio signal may be used to time lock events.\n~~~~~~~~~~\n')
    end
end


% Makes directories into strings
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
%Initialize Psych Sound

% initializes screens to 1, which means it will always refer to the extra
% monitor, not to the computer that has the code.
[windowPtr, rect] = setGlobalVariables();

%% 1) Establishing the Dipole Movement
% Delete Brackets to include dipole. Brackets is for debugging only.
% Expected time: 6 minutes + 10 seconds
initial_time_dipole_creation = 'dipole';

%{
[subject_quit_dipole_creation, initial_time_dipole_creation, time_list] = Dipole_Creation_Toggle(windowPtr);
if subject_quit_dipole_creation
    return
end
%}

% Script will crash if Dipole is commented out and script is not debugging.
if strcmp(initial_time_dipole_creation, 'dipole') == 1
    if medTraining ~= 3
        error('Delete Brackets in "EEG_Master_Script.m" to allow Dipole.')
    end
end

%% Script breaks into it's respective parts by how many stimulators are present...
run('runSubScript.m')

%% 2) display Instructions + Training Block (expected time: 4 minutes)
%
fprintf('==========\nDisplay Instructions and Training Block\n==========\n')
not_understand_task = true;

% Whenever display_instructions is called, the screen will display an image
% that has the instrcutions on it.
display_instructions(windowPtr,1);
display_instructions(windowPtr,2);

% Training Block 1
while not_understand_task
    
    % does the first block of training, which tests d
    [output_array_training_1, error_1, subject_quit_training_1] = Channel_Training_Block_1_Toggle(windowPtr,stimulators);
    
    if error_1
        fprintf('Repeat Training 1');
        display_instructions(windowPtr,4)
    else
        not_understand_task = false;
    end
    
    % Subject Quit breaks out of loop.
    if subject_quit_training_1
        return
    end
end
display_instructions(windowPtr,3);

% Training Block 2 | Is slightly quicker than training task 1
not_understand_task = true;
while not_understand_task
    
    % does the second block of training
    [output_array_training_2, error_2, subject_quit_training_1] = Channel_Training_Block_2_Toggle(windowPtr, stimulators);
    
    if error_1
        fprintf('Repeat Training 2');
        display_instructions(windowPtr,4)
    else
        not_understand_task = false;
    end
    
    if subject_quit_training_1
        return
    end
end
%}
display_instructions(windowPtr,3.5);

%% 3) Go into PEST Convergence Procedure

% The PEST Convergence Procedure should be done for each hand.

% PEST is done on the left hand first
fprintf('==========\nPEST Convergence Procedure on LEFT Hand\n==========\n')

[detection_threshold_left,output_array_PEST_left,subject_quit_PEST] = PEST_Convergence_Procedure(windowPtr, 'Left');

% May need to get into a loop?
if subject_quit_PEST
    return
end

% Safeguard in case PEST is done improperly
while detection_threshold_left >= 1
    fprintf('\n==========\nPEST Threshold >= 1.  Returning to PEST.\n==========\n')
    display_instructions(windowPtr,4)
    [detection_threshold_left, output_array_PEST_left, subject_quit_PEST] = PEST_Convergence_Procedure(windowPtr, 'Left');
    
    if subject_quit_PEST
        return
    end
end


% PEST is done on the right hand next if using 2 stimulators
if stimulators == 2
    fprintf('==========\nPEST Convergence Procedure on RIGHT Hand\n==========\n')
    
    [detection_threshold_right,output_array_PEST_right,subject_quit_PEST] = PEST_Convergence_Procedure(windowPtr, 'Left');
    
    if subject_quit_PEST
        return
    end
    
    % Safeguard in case PEST is done improperly
    while detection_threshold_right >= 1
        fprintf('\n==========\nPEST Threshold >= 1.  Returning to PEST.\n==========\n')
        display_instructions(windowPtr,4)
        [detection_threshold_right, output_array_PEST_right, subject_quit_PEST] = PEST_Convergence_Procedure(windowPtr, 'Right');
        
        if subject_quit_PEST
            return
        end
    end
end

%% 4) Tactile Detection Task
fprintf('Tactile Detection Task\n')

%
if stimulators == 2
    [output_array, subject_quit_tactile_detection] ...
        = TactileDetectionTask(windowPtr,...
        detection_threshold_left,detection_threshold_right);
elseif stimulators == 1
    [output_array, subject_quit_tactile_detection] ...
        = TactileDetectionTask(windowPtr,...
        detection_threshold_left);
end
%}
%{
if stimulators == 1
    [output_array, subject_quit, new_left_threshold, new_right_threshold] ...
        = Channel_Dynamic_Thresholding_Toggle
%}

if subject_quit_tactile_detection
    return
end

display_instructions(windowPtr,7);

t_elapsed_subject = toc(t_start_subject);
min = floor(t_elapsed_subject/60);
sec = t_elapsed_subject - min*60;
fprintf('RunTime: %2.0f minutes and %2.3f seconds.\n', min, sec);
%% Saving Protocols
if stimulators == 1
    if medTraining == 0
        saveDir = strcat(premed,'/Participant_',subjectID);
        save(fullfile(saveDir),'subjectID','detection_threshold_left',...
            'output_array_PEST_left','output_array')
    elseif medTraining == 1
        saveDir = strcat(postmed,'/Participant_',subjectID);
        save(fullfile(saveDir),'subjectID','detection_threshold_left',...
            'output_array_PEST_left','output_array')
    elseif medTraining == 2
        saveDir = strcat(medit,'/Participant_',subjectID);
         save(fullfile(saveDir),'subjectID','detection_threshold_left',...
            'output_array_PEST_left','output_array')
    elseif medTraining == 3
        saveDir = strcat(testing,'/Participant_',subjectID);
        save(fullfile(saveDir),'subjectID','detection_threshold_left',...
            'output_array_PEST_left','output_array')
    end        
elseif stimulators == 2
    if medTraining == 0
        saveDir = strcat(pwd,'/Pre-Med Training/Participant_',subjectID);
        save(fullfile(saveDir),'subjectID','detection_threshold_left',...
            'output_array_PEST_left','detection_threshold_right',...
            'output_array_PEST_right','tactile_detection_task_data',...
            'final_left_threshold','final_right_threshold')
    elseif medTraining == 1
        saveDir = strcat(pwd,'/Post-Med Training/Participant_',subjectID);
        save(fullfile(saveDir),'subjectID','detection_threshold_left',...
            'output_array_PEST_left','detection_threshold_right',...
            'output_array_PEST_right','tactile_detection_task_data',...
            'final_left_threshold','final_right_threshold')
    elseif medTraining == 2
        saveDir = strcat(pwd,'/Meditators/Participant_',subjectID);
        save(fullfile(saveDir),'subjectID','detection_threshold_left',...
            'output_array_PEST_left','detection_threshold_right',...
            'output_array_PEST_right','tactile_detection_task_data',...
            'final_left_threshold','final_right_threshold')
    elseif medTraining == 3
        saveDir = strcat(pwd,'/Testing/Participant_',subjectID);
        save(fullfile(saveDir),'subjectID','detection_threshold_left',...
            'output_array_PEST_left','detection_threshold_right',...
            'output_array_PEST_right','tactile_detection_task_data',...
            'final_left_threshold','final_right_threshold')
    end
end
%% Close Screens and Prep for next Participant
sca;
fprintf('Ready for next participant!\n')








