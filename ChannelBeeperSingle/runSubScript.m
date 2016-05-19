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
    
    % does the first block of training, which tests d
    [output_array_training_1, error_1, subject_quit_training_1] = Channel_Training_Block_1f(windowPtr);
    
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
    [output_array_training_2, error_2, subject_quit_training_1] = Channel_Training_Block_2(windowPtr);
    
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
fprintf('==========\nPEST Convergence Procedure on LEFT Hand\n==========\n')
detection_threshold_left = 1;

% Call PEST
while detection_threshold_left >= 1
    [detection_threshold_left,output_array_PEST_left,subject_quit_PEST] = PEST_Convergence_Procedure(windowPtr, 'Left');
    if detection_threshold_left >=1
        fprintf('-----\nThreshold >= 1.  Returning to PEST.  Press any key to continue.-----\n')
        KbWait([], 2, GetSecs()+600)
    elseif subject_quit_PEST
        return        
    end
end


%% 4) Tactile Detection Protocol
[output_array, subject_quit_tactile_detection] = 
