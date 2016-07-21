function [timestamp, trigger, channels, gNautilus] = siftEEG(EEGData)
% Sifts through the EEG data to find timestamps, triggers, recording
% channels.  Other data points are placed into a struct

timestamp = EEGData(1,:);
trigger = EEGData(24,:);
channels = EEGData(2:17,:);

valid_Triggers = [100 110 120 130 111 112 112 121 122 123 131 132 133,...
    200 210 220 230 211 212 213 221 222 223 231 232 233 150 151 152 153,...
    250 251 252 253 50 55 0];

trig_del = 0;
for i = 1:length(trigger)
    trigCheck = (trigger(i) == valid_trigger);
    if isempty(trigCheck(trigCheck>0))
        trigger(i) = 0;
        trig_del = trig_del+1;
    end
end

gNautilus = struct('Acceleration',EEGData(18:20,:),'Counter',EEGData(21,:),...
    'LQI',EEGData(22,:),'BatteryLevel',EEGData(23,:),'DigitalInput',...
    EEGData(24,:),'Valid',EEGData(25,:),'NetworkChannel',EEGData(26,:));

end

function detectTriggers(trigger)
end