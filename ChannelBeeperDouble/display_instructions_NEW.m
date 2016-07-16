function display_instructions_NEW(windowPtr, instructions)

global solid_black_screen
Screen(windowPtr,'Flip')

if instructions == 0
    Screen('DrawTexture',windowPtr,solid_black_screen);
    Screen(windowPtr,'Flip');
    
elseif instructions == 1
    instructions_1 = imread('Slide01.png');
    instructions_screen = Screen('MakeTexture', windowPtr, instructions_1);
    Screen('DrawTexture',windowPtr,instructions_screen);
    Screen(windowPtr,'Flip');
    keyCode = 1;
    while (find(keyCode) ~= 49) 
        [~, keyCode, ~] = KbWait([], 2, GetSecs()+600);
    end
    
    instructions_2 = imread('Slide02.png');
    instructions_screen = Screen('MakeTexture', windowPtr, instructions_2);
    Screen('DrawTexture',windowPtr,instructions_screen);
    Screen(windowPtr,'Flip');
    keyCode = 1;
    while (find(keyCode) ~= 49)
        [~, keyCode, ~] = KbWait([], 2, GetSecs()+600);
    end
    
    instructions_3 = imread('Slide03.png');
    instructions_screen = Screen('MakeTexture', windowPtr, instructions_3);
    Screen('DrawTexture',windowPtr,instructions_screen);
    Screen(windowPtr,'Flip');
    keyCode = 1;
    while (find(keyCode) ~= 49)
        [~, keyCode, ~] = KbWait([], 2, GetSecs()+600);
    end
    
    instructions_4 = imread('Slide04.png');
    instructions_screen = Screen('MakeTexture', windowPtr, instructions_4);
    Screen('DrawTexture',windowPtr,instructions_screen);
    Screen(windowPtr,'Flip');
    keyCode = 1;
    while (find(keyCode) ~= 49)
        [~, keyCode, ~] = KbWait([], 2, GetSecs()+600);
    end
    
    instructions_5 = imread('Slide05.png');
    instructions_screen = Screen('MakeTexture', windowPtr, instructions_5);
    Screen('DrawTexture',windowPtr,instructions_screen);
    Screen(windowPtr,'Flip');
    keyCode = 1;
    while (find(keyCode) ~= 49)
        [~, keyCode, ~] = KbWait([], 2, GetSecs()+600);
    end
    
    instructions_6 = imread('Slide06.png');
    instructions_screen = Screen('MakeTexture', windowPtr, instructions_6);
    Screen('DrawTexture',windowPtr,instructions_screen);
    Screen(windowPtr,'Flip');
    keyCode = 1;
    while (find(keyCode) ~= 49)
        [~, keyCode, ~] = KbWait([], 2, GetSecs()+600);
    end
    
    instructions_7 = imread('Slide07.png'); % Begin 1st Practice Session
    instructions_screen = Screen('MakeTexture', windowPtr, instructions_7);
    Screen('DrawTexture',windowPtr,instructions_screen);
    Screen(windowPtr,'Flip');
    keyCode = 1;
    while (find(keyCode) ~= 49)
        [~, keyCode, ~] = KbWait([], 2, GetSecs()+600);
    end
    
elseif instructions == 2 % 1st Practice Session Has Ended; Starting PEST Left
    instructions_8 = imread('Slide08.png');
    instructions_screen = Screen('MakeTexture', windowPtr, instructions_8);
    Screen('DrawTexture',windowPtr,instructions_screen);
    Screen(windowPtr,'Flip');
    keyCode = 1;
    while (find(keyCode) ~= 49)
        [~, keyCode, ~] = KbWait([], 2, GetSecs()+600);
    end
    
    instructions_9 = imread('Slide09.png'); % PEST Left Instructions
    instructions_screen = Screen('MakeTexture', windowPtr, instructions_9);
    Screen('DrawTexture',windowPtr,instructions_screen);
    Screen(windowPtr,'Flip');
    keyCode = 1;
    while (find(keyCode) ~= 49)
        [~, keyCode, ~] = KbWait([], 2, GetSecs()+600);
    end    
    
elseif instructions == 3
    instructions_10 = imread('Slide10.png'); % PEST Right Instructions
    instructions_screen = Screen('MakeTexture', windowPtr, instructions_10);
    Screen('DrawTexture',windowPtr,instructions_screen);
    Screen(windowPtr,'Flip');
    keyCode = 1;
    while (find(keyCode) ~= 49)
        [~, keyCode, ~] = KbWait([], 2, GetSecs()+600);
    end        
    
elseif instructions == 4
    instructions_11 = imread('Slide11.png'); % Practice Session 2
    instructions_screen = Screen('MakeTexture', windowPtr, instructions_11);
    Screen('DrawTexture',windowPtr,instructions_screen);
    Screen(windowPtr,'Flip');
    keyCode = 1;
    while (find(keyCode) ~= 49)
        [~, keyCode, ~] = KbWait([], 2, GetSecs()+600);
    end         
    
elseif instructions == 5
    instructions_12 = imread('Slide12.png'); % Practice Session 2 ended
    instructions_screen = Screen('MakeTexture', windowPtr, instructions_12);
    Screen('DrawTexture',windowPtr,instructions_screen);
    Screen(windowPtr,'Flip');
    keyCode = 1;
    while (find(keyCode) ~= 49)
        [~, keyCode, ~] = KbWait([], 2, GetSecs()+600);
    end     
    
    instructions_13 = imread('Slide13.png'); % Dynamic Thresholding
    instructions_screen = Screen('MakeTexture', windowPtr, instructions_13);
    Screen('DrawTexture',windowPtr,instructions_screen);
    Screen(windowPtr,'Flip');
    keyCode = 1;
    while (find(keyCode) ~= 49)
        [~, keyCode, ~] = KbWait([], 2, GetSecs()+600);
    end     
    
elseif instructions == 6
    instructions_14 = imread('Slide14.png'); % End of the Experiment
    instructions_screen = Screen('MakeTexture', windowPtr, instructions_14);
    Screen('DrawTexture',windowPtr,instructions_screen);
    Screen(windowPtr,'Flip');
    keyCode = 1;
    while (find(keyCode) ~= 49)
        [~, keyCode, ~] = KbWait([], 2, GetSecs()+600);
    end 
    
elseif strcmpi(instructions, 'error1') % Error in 1st Practice Session
    instructions_error1 = imread('error_practice_1.png');
    instructions_screen = Screen('MakeTexture', windowPtr, instructions_error1);
    Screen('DrawTexture',windowPtr,instructions_screen);
    Screen(windowPtr,'Flip');
    keyCode = 1;
    while (find(keyCode) ~= 32)
        [~, keyCode, ~] = KbWait([], 2, GetSecs()+600);
    end
    
elseif strcmpi(instructions, 'error2')
    instructions_error2 = imread('error_practice_2.png');
    instructions_screen = Screen('MakeTexture', windowPtr, instructions_error2);
    Screen('DrawTexture',windowPtr,instructions_screen);
    Screen(windowPtr,'Flip');
    keyCode = 1;
    while (find(keyCode) ~= 32)
        [~, keyCode, ~] = KbWait([], 2, GetSecs()+600);
    end
    
elseif strcmpi(instructions, 'Break')
    instructions_break1 = imread('Break1.png'); % Break 1 during CDT
    instructions_screen = Screen('MakeTexture', windowPtr, instructions_break1);
    Screen('DrawTexture',windowPtr,instructions_screen);
    Screen(windowPtr,'Flip');
    keyCode = 1;
    while (find(keyCode) ~= 49)
        [~, keyCode, ~] = KbWait([], 2, GetSecs()+50);
    end     
    
    instructions_break2 = imread('Break2.png'); % Break 2 during CDT
    instructions_screen = Screen('MakeTexture', windowPtr, instructions_break2);
    Screen('DrawTexture',windowPtr,instructions_screen);
    Screen(windowPtr,'Flip');
    keyCode = 1;
    while (find(keyCode) ~= 49)
        [~, keyCode, ~] = KbWait([], 2, GetSecs()+10);
    end     
end