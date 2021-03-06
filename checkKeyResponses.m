function [yes, no, esc] = checkKeyResponses
% Function to determine what keys are going to be used for "yes", "no", and
% "esc" responses.
% [yes, no, esc] = checkKeyResponses()

fprintf('Press the button that will code "yes" responses: \n')
yes = find(keyCode);

fprintf('Press the button that will code "no" responses: \n')
[~, keyCode, ~] = KbWait(-3, 2, GetSecs()+600);
no = find(keyCode);

fprintf('Press the button that will end the experiment: \n')
[~, keyCode, ~] = KbWait(-3, 2, GetSecs()+600);
esc = find(keyCode); 

end