function [timestamp, trigger, channels, gNautilus] = siftEEG(EEGData)
% Sifts through the EEG data to find timestamps, triggers, recording
% channels.  Other data points are placed into a struct

timestamp = EEGData(1,:);
trigger = EEGData(24,:);
channels = EEGData(2:17,:);

gNautilus = struct('Acceleration',EEGData(18:20,:),'Counter',EEGData(21,:),...
    'LQI',EEGData(22,:),'BatteryLevel',EEGData(23,:),'DigitalInput',...
    EEGData(24,:),'Valid',EEGData(25,:),'NetworkChannel',EEGData(26,:));

end