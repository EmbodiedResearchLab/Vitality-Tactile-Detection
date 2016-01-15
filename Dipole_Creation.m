function [subject_quit, dipole_creation_beginning, time_list] = Dipole_Creation(windowPtr)


global dipole_creation_beginning
global SoundHandle
subject_quit = false;

% reading the image for the training block
display_instructions(windowPtr,0);

solid_black = imread('solid_black.png');
solid_black_screen = Screen('MakeTexture',windowPtr,solid_black);

WaitSecs(3);

dipole_creation_beginning = GetSecs();

Screen('DrawTexture',windowPtr,solid_black_screen);
Screen(windowPtr,'Flip');

%setting the hand to be hit
hand = 'tbd'

%data to return
time_list = []


for(i = 1:120)

    % determining which hand will be tapped.
    % the left hand will be tapped 60 times, 
    % and then the right hand will be tapped 60 times.
    if (i < 61)
        hand = 'Left';
    else
        hand = 'Right';
    end

    t = GetSecs();
    ChannelBeeper(100, 1, .01, hand);
    sprintf('Hand: %s.', hand) 

    data = [i, t];
    time_list = cat(1,time_list,data);
	% Checks for detection of a keypress, but waits only 2 seconds
    % function [secs, keyCode, deltaSecs] = KbWait(deviceNumber, forWhat, untilTime)
    %Waits until any key is down and optionally returns the time in seconds
    %and the keyCode vector of keyboard states, just as KbCheck would do. Also
    %allows to wait for release of all keys or for single keystrokes, see
    %below.
    % If you want to wait for a single keystroke, set the 'forWhat' value to 2.
    % KbWait will then first wait until all keys are released, then for the
    % first keypress, then it will return.
    % If deviceNumber is -3, all keyboard and keypad devices will be checked.
    % by the way, "keyCode vector of keyboard state"
    [s, keyCode, delta] = KbWait(-3, 2, GetSecs()+2.99 - .01);

    if (keyCode(46) == 1)
        subject_quit = true;
        fprintf('The subject indicated they wanted to quit the dipole creation.');
        %When flushed, as part of its exit sequence, Screen closes all its
        %windows, restores the screen's normal color table, and shows the cursor. Or you
        %can get just those effects, without flushing, by calling Screen('CloseAll')
        %or sca - which is an abbreviation for Screen('CloseAll').
        Screen('CloseAll');
        break
    end
end