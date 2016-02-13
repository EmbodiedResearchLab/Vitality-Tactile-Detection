%% BenderPlate Displacement
disp_interval = 0:.1:1;

for i = 1:length(disp_interval)
    sprintf('Volume: %f', disp_interval(i))
    ChannelBeeper(100,disp_interval(i),.01)
    measured(i) = input('Measured Displacement? ')
end

output = [disp_interval;measured];
    