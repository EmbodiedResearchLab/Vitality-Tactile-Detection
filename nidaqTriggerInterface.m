function nidaqTriggerInterface(option)
global s

if ~exist(s, 'var')
    s = daq.createSession('ni');
    % setup the session -- initialize the session-based interface to the NI-DAQ
    % device.
end

ch = addDigitalChannel(s, 'Dev1', 'Port2/Line0:7', 'OutputOnly');
% Setup an 8-bit range as a channel to which events can be written

if strcmp(option, 'on')
    outputSingleScan(s, dec2binvec(64,8))
    % Immediately preceding or following a stimulus, set a non-zero value on
    % the 8 bit range from bit 0 through 7.  This sets the length of the
    % produced vector to 8, which is required.  Here, the values immediately following dec2binvec can be any
    % integer from 1 to 255.
    
elseif strcmp(option,'off')
    outputSingleScan(s, zeros(1,8))
    % Reset port to zero.  This should be done within (1000/<EEG Sampling rate>
    % +2 milliseconds to ensure the port is ready for the next event (the code
    % should not be too long), and to ensure that codes are not missed (code
    % should not be so short that the start and finish may both fall between
    % EEG samples)
end

end