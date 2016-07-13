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

% Adds the appropriate experiment to path by the number of stimulators present
if stimulators == 1
    experiment = fullfile(pwd,'ChannelBeeperSingle');
    saveloc = experiment;
    %saveloc = fullfile('path/to/secure/location','ChannelBeeperSingle'); 
    % saveloc designates where data will be saved.  Change this to OSCAR, hardrive, or other secure location.
    addpath(experiment);
else
    experiment = fullfile(pwd,'ChannelBeeperDouble');
    saveloc = experiment;
    %saveloc = fullfile('path/to/secure/location','ChannelBeeperDouble');
    % saveloc designates where data will be saved.  Change this to OSCAR, hardrive, or other secure location.
    addpath(experiment);
end

% makes directories into strings for saving data later.  Save locations
% should be stored some place more secure.  Tentatively, they have been 
% placed in the same location as the experiment.  

data = fullfile(saveloc,'Data');
premed = fullfile(data,'Pre-Med Training');
postmed = fullfile(data,'Post-Med Training');
medit = fullfile(data,'Meditators');
testing = fullfile(data,'Testing');
strings = {data, premed, postmed, medit, testing};

% Makes the proper directories if they do not exist
for i = 1:length(strings)
    j = char(strings(i));
    if exist(j, 'dir') ~=7
        mkdir(j)
    end
end

%% Initializing setGlobalVariables and Psychtoolbox functions

[windowPtr, rect] = setGlobalVariables();

%% Script breaks into it's respective parts by how many stimulators are present...
run('runSubScript.m')
display_instructions(windowPtr,7);

t_elapsed_subject = toc(t_start_subject);
min = floor(t_elapsed_subject/60);
sec = t_elapsed_subject - min*60;
fprintf('RunTime: %2.0f minutes and %2.3f seconds.\n', min, sec);
%% Saving Protocols

%{
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
%}
%% Close Screens and Prep for next Participant
sca;

% Remove folders from path
if stimulators == 1
    rmpath('ChannelBeeperSingle')
else
    rmpath('ChannelBeeperDouble')
end

fprintf('Ready for next participant!\n')

 