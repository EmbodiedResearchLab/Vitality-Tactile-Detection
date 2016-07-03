function ChannelBeeper(frequency, fVolume, durationSec, channelDirection)
% this function right here takes in the frequency, volume, duration, and 
% which channel the beeper should go to.  Then it follows the directions.

global SoundHandle

% Makes sure that SoundHandle is called once and won't crash the script.
if isempty(SoundHandle)
    InitializePsychSound(1);
    SamplingFreq = 44100;
    NbChannels = 2;
    SoundHandle = PsychPortAudio('Open',[],[],2,SamplingFreq,NbChannels);
end

if ~exist('channelDirection', 'var')
	channelDirection = 'Both';
end

% a la https://github.com/Psychtoolbox-3/Psychtoolbox-3/blob/master/Psychtoolbox/PsychBasic/Beeper.m
% lines 34-43, makes sure that 
if ~exist('fVolume', 'var')
    fVolume = 0.4;
else
    % Clamp if necessary
    if fVolume > 1.0
        fVolume = 1.0;
    elseif fVolume < 0
        fVolume = 0;
    end
end


sound = MakeBeep(frequency, durationSec,[]) * fVolume; %creates a sound for 10 ms

if (strcmp(channelDirection, 'Left'))
	leftSound = [sound;zeros(1,size(sound,2))]; % left stereo
	PsychPortAudio('FillBuffer', SoundHandle, leftSound);
    PsychPortAudio('Start', SoundHandle, 1, []);
elseif (strcmp(channelDirection, 'Right'))
	rightSound = [zeros(1,size(sound,2));sound]; % right stereo
	PsychPortAudio('FillBuffer', SoundHandle, rightSound);
    PsychPortAudio('Start', SoundHandle, 1, []);
elseif (strcmp(channelDirection, 'Both'))
	bothSound = [sound; sound]; % self explanatory
	PsychPortAudio('FillBuffer', SoundHandle, bothSound); 
    PsychPortAudio('Start', SoundHandle, 1, []);
else
	fprintf('Please put in a correct channelDirection')
end

end