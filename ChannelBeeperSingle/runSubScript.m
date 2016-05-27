%% runSubScript
% Script runs after you deciding one stimulator will be used.

%% 2) Display Instructions + Training Block (expected time: 4 minutes)
%
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

% Training Block 2 | Is slightly quicker than training task 1
not_understand_task = true;
while not_understand_task
    
    % does the second block of training
    [output_array_training_2, error_2, subject_quit_training_1] = Channel_Training(windowPtr,2);
    
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

%% 3) PEST Convergence Procedure
% PEST is done on the left hand first
%{
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

%% 4) Tactile Detection Protocol
detection_threshold = .38;
% Call Dynamic Thresholding
[output_array, subject_quit_tactile_detection, new_threshold, tactile_task] = Channel_Dynamic_Thresholding(windowPtr, detection_threshold);

%% 5) Saving Protocol

if medTraining == 0
    saveDir = strcat(premed,'/Participant_',num2str(subjectID));
    save(fullfile(saveDir),'subjectID','detection_threshold',...
        'new_threshold','output_array_PEST','output_array','tactile_task')
elseif medTraining == 1
    saveDir = strcat(postmed,'/Participant_',subjectID);
    save(fullfile(saveDir),'subjectID','detection_threshold',...
        'new_threshold','output_array_PEST','output_array','tactile_task')
elseif medTraining == 2
    saveDir = strcat(medit,'/Participant_',subjectID);
    save(fullfile(saveDir),'subjectID','detection_threshold',...
        'new_threshold','output_array_PEST','output_array','tactile_task')
elseif medTraining == 3
    saveDir = strcat(testing,'/Participant_',subjectID);
    save(fullfile(saveDir),'subjectID','detection_threshold',...
        'new_threshold','output_array_PEST','output_array','tactile_task')
end


