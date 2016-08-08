%% runSubScript
% Runs subscript after deciding two stimulators will be used.
nidaqTriggerInterface('Initial')

%% 2) Display Instructions + Training Block (expected time: 4 minutes)
%{
fprintf('==========\nDisplay Instructions and Training Block\n==========\n')
not_understand_task = true;

% Whenever display_instructions is called, the screen will display an image
% that has the instrcutions on it.
%display_instructions(windowPtr,1);
%display_instructions(windowPtr,2);
display_instructions_NEW(windowPtr,1);

% Training Block 1
while not_understand_task
        
    % does the first block of training, which tests d
    [output_array_training_1, error_1, subject_quit_training_1] = Channel_Training_Double(windowPtr,1);
    
    if error_1
        fprintf('Repeat Training 1');
        display_instructions_NEW(windowPtr,'error1');
    else
        not_understand_task = false;
    end
    
    % Subject Quit breaks out of loop.
    if subject_quit_training_1
        return
    end
end
%display_instructions(windowPtr,3);
%display_instructions(windowPtr,3.5);

%}
%% 3) PEST Convergence Procedure
%{
display_instructions_NEW(windowPtr,2)
% Pest Directed to one hand and then the other hand.
fprintf('==========\nPEST Convergence Procedure on LEFT Hand\n==========\n')
left_threshold = 1;
right_threshold = 1;

% Call PEST on the Left Hand
while left_threshold >= 1
    [left_threshold,output_array_PEST_left,subject_quit_PEST_left] = PEST_Convergence_Procedure(windowPtr, 'Left');
    if left_threshold >=1
        fprintf('-----\nThreshold >= 1.  Returning to PEST.  Press any key to continue.-----\n')
        KbWait([], 2, GetSecs()+600)
    elseif subject_quit_PEST_left
        return        
    end
end

% Call PEST on the Right Hand
display_instructions_NEW(windowPtr,3)
while right_threshold >= 1
    [right_threshold,output_array_PEST_right,subject_quit_PEST_right] = PEST_Convergence_Procedure(windowPtr, 'Right');
    if right_threshold >=1
        fprintf('-----\nThreshold >= 1.  Returning to PEST.  Press any key to continue.-----\n')
        KbWait([], 2, GetSecs()+600)
    elseif subject_quit_PEST_right
        return        
    end
end


%% Training Block 2 | Is slightly quicker than training task 1
not_understand_task = true;
display_instructions_NEW(windowPtr,4)
while not_understand_task
    
    % does the second block of training
    [output_array_training_2, error_2, subject_quit_training_2] = Channel_Training_Double(windowPtr,2,left_threshold,right_threshold);
    
    if error_2
        fprintf('Repeat Training 2');
        display_instructions_NEW(windowPtr,'error2')
    else
        not_understand_task = false;
    end
    
    if subject_quit_training_2
        return
    end
end
%}
%% 4) Tactile Detection Protocol
 left_threshold = .38; 
 right_threshold = .38;
display_instructions_NEW(windowPtr,5)
[output_array, subject_quit, new_left_threshold, new_right_threshold, left, right] = Channel_Dynamic_Thresholding_Double(windowPtr, left_threshold, right_threshold);

nidaqTriggerInterface('End')
%% 5) Saving Protocol
display_instructions_NEW(windowPtr,6)
savVars = whos; % Identifies all variables in the workspace

% Identifies the variables of interest
compVars = {'subjectID','left_threshold',...
    'right_threshold','output_array_PEST_left'...
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
varsToSave = saveData(savVars, compVars);
save(saveDir,varsToSave{:})


