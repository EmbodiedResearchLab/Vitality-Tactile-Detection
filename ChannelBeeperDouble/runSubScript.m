%% runSubScript
% Runs subscript after deciding two stimulators will be used.

%% 2) Display Instructions + Training Block (expected time: 4 minutes)

fprintf('==========\nDisplay Instructions and Training Block\n==========\n')
not_understand_task = true;

% Whenever display_instructions is called, the screen will display an image
% that has the instrcutions on it.
display_instructions(windowPtr,1);
display_instructions(windowPtr,2);

% Training Block 1
while not_understand_task
        
    % does the first block of training, which tests d
    [output_array_training_1, error_1, subject_quit_training_1] = Channel_Training_Block_1_Toggle(windowPtr);
    
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
    [output_array_training_2, error_2, subject_quit_training_1] = Channel_Training_Block_2_Toggle(windowPtr);
    
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

%% 4) Tactile Detection Protocol
