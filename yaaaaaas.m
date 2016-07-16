    keyCode = 1;
    while (find(keyCode) ~= 13) && (find(keyCode) ~= 32)
        [~, keyCode, ~] = KbWait([], 2, GetSecs()+600);
    end