%% runSubScript
% Script runs after you deciding one stimulator will be used.
nidaqTriggerInterface('Initial');

%% 2) Display Instructions + Training Block 1 (expected time: 4 minutes)
%{
fprintf('==========\nDisplay Instructions and Training Block\n==========\n')
not_understand_task = true;

% Whenever display_instructions is called, the screen will display an image
% that has the instrcutions on it.
display_instructions(windowPtr,1);
display_instructions(windowPtr,2);

% Training Block 1
while not_understand_task
    
    % does the first block of training
    [output_array_training_1, error_1, subject_quit_training_1] = Channel_Training(windowPtr, 1);
    
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


display_instructions(windowPtr,3.5);
%}
%% 3) PEST Convergence Procedure
% PEST is done on the left hand first
%
fprintf('==========\nPEST Convergence Procedure on LEFT Hand\n==========\n')
detection_threshold = 1;

% Call PEST until threshold is below 1.  Indicates to experiment when pest
% occurs again.
while detection_threshold >= 1
    [detection_threshold, output_array_PEST, subject_quit_PEST] = PEST_Convergence_Procedure(windowPtr, 'Left');
    if detection_threshold >=1
        fprintf('-----\nThreshold >= 1.  Returning to PEST.  Press any key to continue.-----\n')
        KbWait([], 2, GetSecs()+600)
    elseif subject_quit_PEST
        return
    end
end
%}

%% Training Block 2 | Is slightly quicker than training task 1
%{
not_understand_task = true;
while not_understand_task
    
    % does the second block of training
    [output_array_training_2, error_2, subject_quit_training_1] = Channel_Training(windowPtr,2, detection_threshold);
    
    if error_1
        fprintf('Repeat Training 2');
        display_instructions(windowPtr,4)
    else
        not_understand_task = false;
    end
    
    if subject_quit_training_1
        break;
    end
end
%}

%% 4) Tactile Detection Protocol
detection_threshold = .38;
% Call Dynamic Thresholding
[output_array, subject_quit_tactile_detection, new_threshold, tactile_task] = Channel_Dynamic_Thresholding_Single(windowPtr, detection_threshold);

nidaqTriggerInterface('End');
%% 5) Saving Protocol

savVars = whos; % Identifies all variables in the workspace
compVars = {'subjectID','detection_threshold','new_threshold',...
    'output_array_PEST','output_array','tactile_task'}; % Identifies the variables of interest

% Creates the path to save data based upon the kind of meditation training
% determined in the EEG_Master_Script.
naming = strcat('Participant_',num2str(subjectID),'_',datestr(date,'mmddyyyy'),'_Behavioral');
if medTraining == 0
    saveDir = fullfile(premed,naming);
elseif medTraining == 1
    saveDir = fullfile(postmed,naming);
elseif medTraining == 2
    saveDir = fullfile(medit,naming);
elseif medTraining == 3
    saveDir = fullfile(testing,naming);
end

% Function that compares all variables in the workspace to the variables of
% interest and places them into cell 'varsToSave'.
varsToSave = saveData(savVars, compVars);
save(saveDir,varsToSave{:})



