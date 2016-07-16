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
    
    keyCode = 0;
    while (find(keyCode) ~= 49) 
        [~, keyCode, ~] = KbWait([], 2, GetSecs()+600);
    end
    
    instructions_2 = imread('Slide02.png');
    instructions_screen = Screen('MakeTexture', windowPtr, instructions_2);
    Screen('DrawTexture',windowPtr,instructions_screen);
    Screen(windowPtr,'Flip');
    keyCode = 0;
    while (find(keyCode) ~= 49)
        [~, keyCode, ~] = KbWait([], 2, GetSecs()+600);
    end
    
    instructions_3 = imread('Slide03.png');
    instructions_screen = Screen('MakeTexture', windowPtr, instructions_3);
    Screen('DrawTexture',windowPtr,instructions_screen);
    Screen(windowPtr,'Flip');
    keyCode = 0;
    while (find(keyCode) ~= 49)
        [~, keyCode, ~] = KbWait([], 2, GetSecs()+600);
    end
    
    instructions_4 = imread('Slide04.png');
    instructions_screen = Screen('MakeTexture', windowPtr, instructions_4);
    Screen('DrawTexture',windowPtr,instructions_screen);
    Screen(windowPtr,'Flip');
    keyCode = 0;
    while (find(keyCode) ~= 49)
        [~, keyCode, ~] = KbWait([], 2, GetSecs()+600);
    end
    
    instructions_5 = imread('Slide05.png');
    instructions_screen = Screen('MakeTexture', windowPtr, instructions_5);
    Screen('DrawTexture',windowPtr,instructions_screen);
    Screen(windowPtr,'Flip');
    keyCode = 0;
    while (find(keyCode) ~= 49)
        [~, keyCode, ~] = KbWait([], 2, GetSecs()+600);
    end
    
    instructions_6 = imread('Slide06.png');
    instructions_screen = Screen('MakeTexture', windowPtr, instructions_6);
    Screen('DrawTexture',windowPtr,instructions_screen);
    Screen(windowPtr,'Flip');
    keyCode = 0;
    while (find(keyCode) ~= 49)
        [~, keyCode, ~] = KbWait([], 2, GetSecs()+600);
    end
    
    instructions_7 = imread('Slide07.png'); % Begin 1st Practice Session
    instructions_screen = Screen('MakeTexture', windowPtr, instructions_7);
    Screen('DrawTexture',windowPtr,instructions_screen);
    Screen(windowPtr,'Flip');
    keyCode = 0;
    while (find(keyCode) ~= 49)
        [~, keyCode, ~] = KbWait([], 2, GetSecs()+600);
    end
    
elseif instructions == 1 % 1st Practice Session
    instructions_7 = imread('Slide07.png');
    instructions_screen = Screen('MakeTexture', windowPtr, instructions_7);
    Screen('DrawTexture',windowPtr,instructions_screen);
    Screen(windowPtr,'Flip');
    keyCode = 0;
    while (find(keyCode) ~= 49)
        [~, keyCode, ~] = KbWait([], 2, GetSecs()+600);
    end
    
elseif strcmp(instructions, 'Error1') % Error in 1st Practice Session
    instructions_8 = imread('Slide08.png');
    instructions_screen = Screen('MakeTexture', windowPtr, instructions_8);
    Screen('DrawTexture',windowPtr,instructions_screen);
    Screen(windowPtr,'Flip');
    keyCode = 0;
    while (find(keyCode) ~= 13) && (find(keyCode) ~= 32)
        [~, keyCode, ~] = KbWait([], 2, GetSecs()+600);
    end
    
elseif strcmp(instructions, 'Error2')
    %instructions_8 = imread('Slide0.png');
    %instructions_screen = Screen('MakeTexture', windowPtr, instructions_8);
    Screen('DrawTexture',windowPtr,instructions_screen);
    Screen(windowPtr,'Flip');
    keyCode = 0;
    while (find(keyCode) ~= 13) && (find(keyCode) ~= 32)
        [~, keyCode, ~] = KbWait([], 2, GetSecs()+600);
    end
end