function nidaqTriggerInterface

s = daq.createSession('ni');
% setup the session -- initialize the session-based interface to the NI-DAQ
% device.  

ch = addDigitalChannels(s, 'Dev1', 'Port2/Line0:7,' 


end