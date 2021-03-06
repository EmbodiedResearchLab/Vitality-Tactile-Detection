function trig = nidaqTriggerInterface(varargin)
% Creates a digital pulse to act as a trigger when collecting data.
% trig = nidaqTriggerInterface(cue, updated_threshold, intensity, response)
% trig = 50;
% trig = 100; if left
% trig = 200; if right
% trig = trig + 10; for suprathreshold
% trig = trig + 20; for threshold
% trig = trig + 30; for null
% trig = trig + 1; for yes
% trig = trig + 2; for no
% trig = trig + 3; for no response

% Status turns the the trigger 'on' or 'off'.
% Cue takes whether the participant was cued left or right.
% Intensity takes the volume from ChannelBeeper.
% Response is adds based on 'yes' or 'no' responses.

global s
global ch
global yes
global no

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
% Floor(trig/100)
if nargin == 2-1
    if strcmpi(varargin{1},'Initial')
        trig = 50;
    elseif strcmpi(varargin{1},'End')
        trig = 55;
    elseif strcmpi(varargin{1}, 'Left') || strcmpi(varargin{1}, 'White')
        trig = 100;
    else
        trig = 200;
    end
    
elseif nargin == 4-1 % Calling ChannelBeeperTrigger
    if strcmpi(varargin{1}, 'Left') || strcmpi(varargin{1}, 'White')
        trig = 100;
    elseif strcmpi(varargin{1},'Right')
        trig = 200;
    end
    
    if varargin{3} == varargin{2} % threshold trial
        trig = trig + 20;
    elseif varargin{3} == 0; % null trial
        trig = trig + 10;
    elseif varargin{3} > varargin{2} % suprathreshold
        trig = trig + 30;
    else
        trig = trig + 50; % This will identify any mishaps
    end
elseif nargin == 5-1 % Determining Response
    if strcmpi(varargin{1}, 'Left') || strcmpi(varargin{1}, 'White')
        trig = 100;
    elseif strcmpi(varargin{1},'Right')
        trig = 200;
    end
    
    if varargin{3} == varargin{2} % threshold trial
        trig = trig + 20;
    elseif varargin{3} == 0; % null trial
        trig = trig + 10;
    elseif varargin{3} > varargin{2} % suprathreshold
        trig = trig + 30;
    else
        trig = trig + 50; % This will identify any mishaps
    end
    
    if varargin{4} == yes
        trig = trig+1;
    elseif varargin{4} == no
        trig = trig+2;
    elseif varargin{4} == 0
        trig = trig+3;
    end
else
    trig = 50;
end

%{
trig = 50;
if nargin > 1
    if strcmpi(varargin{1}, 'Left') || strcmpi(varargin{1},'White')
        trig = 100;
    elseif strcmpi(varargin{1}, 'Right')
        trig = 200;
    end
end

% Determine trigger value by stimulus intensity
% mod(floor(trig/10),10)
if nargin > 2
    if varargin{2} == varargin{3} % threshold trial
        trig = trig + 20;
    elseif varargin{2} == 0; % null trial
        trig = trig + 10;
    elseif varargin{2} == 2*varargin{3} % suprathreshold
        trig = trig + 30;
    else
        trig = trig + 50;
    end
end

% Determine trigger value by participant response.
% mod(trig,2), mod(trig,3)
if nargin > 3
    if varargin{3} == yes
        trig = trig+1;
    elseif varargin{3} == no
        trig = trig+2;
    elseif varargin{3} == 0
        trig = trig+3;
    end
end
%}

%Turn trigger on
    outputSingleScan(s, dec2binvec(trig,8));
    % Immediately preceding or following a stimulus, set a non-zero value on
    % the 8 bit range from bit 0 through 7.  This sets the length of the
    % produced vector to 8, which is required.  Here, the values immediately following dec2binvec can be any
    % integer from 1 to 255.
    
 %Turn trigger off   
    outputSingleScan(s, zeros(1,8));
    % Reset port to zero.  This should be done within (1000/<EEG Sampling rate>
    % +2 milliseconds to ensure the port is ready for the next event (the code
    % should not be too long), and to ensure that codes are not missed (code
    % should not be so short that the start and finish may both fall between
    % EEG samples)
end