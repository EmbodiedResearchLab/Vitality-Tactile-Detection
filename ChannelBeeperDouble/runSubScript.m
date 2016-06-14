%% runSubScript
% Runs subscript after deciding two stimulators will be used.

%% 2) Display Instructions + Training Block (expected time: 4 minutes)
%{
fprintf('==========\nDisplay Instructions and Training Block\n==========\n')
not_understand_task = true;

% Whenever display_instructions is called, the screen will display an image
% that has the instrcutions on it.
display_instructions(windowPtr,1);
display_instructions(windowPtr,2);

% Training Block 1
while not_understand_task
        
    % does the first block of training, which tests d
    [output_array_training_1, error_1, subject_quit_training_1] = Channel_Training(windowPtr,1);
    
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

%% 3) PEST Convergence Procedure
%{
% Pest Directed to one hand and then the other hand.
fprintf('==========\nPEST Convergence Procedure on LEFT Hand\n==========\n')
detection_threshold_left = 1;
detection_threshold_right = 1;

% Call PEST on the Left Hand
while detection_threshold_left >= 1
    [detection_threshold_left,output_array_PEST_left,subject_quit_PEST_left] = PEST_Convergence_Procedure(windowPtr, 'Left');
    if detection_threshold_left >=1
        fprintf('-----\nThreshold >= 1.  Returning to PEST.  Press any key to continue.-----\n')
        KbWait([], 2, GetSecs()+600)
    elseif subject_quit_PEST_left
        return        
    end
end

% Call PEST on the Right Hand
while detection_threshold_right >= 1
    [detection_threshold_right,output_array_PEST_right,subject_quit_PEST_right] = PEST_Convergence_Procedure(windowPtr, 'Right');
    if detection_threshold_right >=1
        fprintf('-----\nThreshold >= 1.  Returning to PEST.  Press any key to continue.-----\n')
        KbWait([], 2, GetSecs()+600)
    elseif subject_quit_PEST_right
        return        
    end
end
%}

%% Training Block 2 | Is slightly quicker than training task 1
not_understand_task = true;
while not_understand_task
    
    % does the second block of training
    [output_array_training_2, error_2, subject_quit_training_1] = Channel_Training_Block_2(windowPtr,2);
    
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
%% 4) Tactile Detection Protocol
left_threshold = .38;
right_threshold = .38;
[output_array, subject_quit, new_left_threshold, new_right_threshold, left, right] = Channel_Dynamic_Thresholding(windowPtr, left_threshold, right_threshold);

%% 5) Saving Protocol
%% 5) Saving Protocol

savVars = whos; % Identifies all variables in the workspace

% Identifies the variables of interest
compVars = {'subjectID','detection_threshold_left',...
    'detection_threshold_right','output_array_PEST_left'...
    'output_array_PEST_right','new_left_threshold','new_right_threshold',...
    'output_array_PEST','output_array','left','right'}; 

% Creates the path to save data based upon the kind of meditation training
% determined in the EEG_Master_Script.
if medTraining == 0
    saveDir = fullfile(premed,strcat('Participant_',num2str(subjectID)));
elseif medTraining == 1
    saveDir = fullfile(postmed,strcat('Participant_',num2str(subjectID)));
elseif medTraining == 2
    saveDir = fullfile(medit,strcat('Participant_',num2str(subjectID)));
elseif medTraining == 3
    saveDir = fullfile(testing,strcat('Participant_',num2str(subjectID)));
end

% Function that compares all variables in the workspace to the variables of
% interest and places them into cell 'varsToSave'.
varsToSave = saveData(savVars, compVars, saveDir);
save(saveDir,varsToSave{:})


