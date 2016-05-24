function trig = nidaqTriggerInterface(status,vargin)
global s
global ch

if isempty(s)
    s = daq.createSession('ni');
    % setup the session -- initialize the session-based interface to the NI-DAQ
    % device.
end

if isempty(ch)
ch = addDigitalChannel(s, 'Dev1', 'Port2/Line0:7', 'OutputOnly');
% Setup an 8-bit range as a channel to which events can be written
end

% Determine trigger value by cue type.
if strcmp(vargin{1}, 'Left')
    trig = 100;
elseif strcmp(vargin{1}, 'Right')
    trig = 200;
end

% Determine trigger value by stimulus intensity
if vargin{2} == 1
    trig = trig + 10;
elseif vargin{2} == 0;
    trig = trig + 30;
else
    trig = trig + 20;
end
    
% Changes the trigger by its status
if strcmp(status, 'on')
    outputSingleScan(s, dec2binvec(trig,8))
    % Immediately preceding or following a stimulus, set a non-zero value on
    % the 8 bit range from bit 0 through 7.  This sets the length of the
    % produced vector to 8, which is required.  Here, the values immediately following dec2binvec can be any
    % integer from 1 to 255.
    
elseif strcmp(status,'off')
    outputSingleScan(s, zeros(1,8))
    % Reset port to zero.  This should be done within (1000/<EEG Sampling rate>
    % +2 milliseconds to ensure the port is ready for the next event (the code
    % should not be too long), and to ensure that codes are not missed (code
    % should not be so short that the start and finish may both fall between
    % EEG samples)
end

end