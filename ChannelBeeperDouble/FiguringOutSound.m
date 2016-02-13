% function Beeper(frequency, [fVolume], [durationSec]);
% sampleRate = Snd('DefaultRate');
% aka sampleRate = 22254.5454545454

% nSample = sampleRate*durationSec;
% soundVec = sin(2*pi*frequency*(1:nSample)/sampleRate);

% Scale down the volume
%soundVec = soundVec * fVolume;
% sound(soundVec);
%try % this part sometimes crashes for unknown reasons. If it happens replace sound with normal beep

%Snd('Play', soundVec, sampleRate);

% rate=Snd('DefaultRate') returns the default sampling rate in Hz, which
% currently is 22254.5454545454 Hz on all platforms for the old style sound
% implementation, and the default device sampling rate if PsychPortAudio is
% used. This default may change in the future, so please either specify a
% rate, or use this function to get the default rate. (This default is
% suboptimal on any system except MacOS-9, but kept for backwards
% compatibility!)


%     So, for example, you might create a 1 second, 1000 Hz tone, sampled at 44.1 kHz:

t = (0:44100)'./44100;
y = sin(1000 * 2 * pi * t);
toolboxSampleRate = 22254.5454545454;
% You can then play it back in MATLAB in mono

% player = audioplayer(Y,Fs) creates an audioplayer object for signal Y, 
% using sample rate Fs. The function returns a handle to the audioplayer object, player.
% 
% player = audioplayer(y, toolboxSampleRate);
% player.play();

% or use it as just the left channel (switch the order of y and zeros(...)
% for just the right
player = audioplayer([y, zeros(size(y))], toolboxSampleRate);
player.play();

% WaitSecs(5);
%  Beeper(100, 1, 2);