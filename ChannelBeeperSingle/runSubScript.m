%% runSubScript
% Script runs after you decide what hand to write

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
% PEST is done on the left hand first
fprintf('==========\nPEST Convergence Procedure on LEFT Hand\n==========\n')

% Call PEST
[detection_threshold_left,output_array_PEST_left,subject_quit_PEST] = PEST_Convergence_Procedure(windowPtr, 'Left');


%% 4) Tactile Detection Protocol
[output_array, subject_quit_tactile_detection] = 

