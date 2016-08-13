%% Run EEG
%{ 
y(1,:) = timestamp based on sampling rate
y(2:17,:)= scalp EEG channels
y(18:20,:) = acceleration in the 3 dimensions
y(21,:) = Counter
y(22,:) = Link Quality
y(23,:) = Battery
y(24,:) = Digital Inputs
y(25,:) = Valid
y(26,:) = Network Channels
%}
clear all
saveFile = pwd; % Change this to the path where participant data can be secured.

SubjectID = input('SubjectID: ','s');
medTraining = input('1 - Premeditation Training.\n2 - PostMeditation Training.\n3 - Meditators.\n4 - Debugging: '); % If this is cross-sectional, just use "0".
if medTraining == 1, time = 'Pre'; elseif medTraining == 2, time = 'Post'; elseif medTraining == 3, time = 'Meditator'; else time = 'Test'; end
saveData = strcat(SubjectID,'_',datestr(date,'mmddyyyy'),'_EEG_',time); %Participantxx_mmddyyyy_EEG
saveFile = fullfile(saveFile,saveData);

model = 'TactileStimEEG';
openGUI = {'g.Nautilus','g.SCOPE', 'g.Nautilus Impedance Check','DIN'};

nautCom = strcat(model,'/',openGUI{1}); % g.Nautilus Parameters
scopeCom = strcat(model,'/',openGUI{2}); % g.SC ersfind the mask parametOPE is a mask. 
impCom = strcat(model,'/',openGUI{3}); % Impedence check
trigCom = strcat(model,'/',openGUI{4}); % Digital Input for Triggers

openCom = {nautCom, scopeCom, impCom};

%% Set parameters
load_system(model)
set_param('TactileStimEEG/To File','FileName',saveData) % Save File Name
if input(' Check g.Nautilus parameters? ') == 1
    open_system(nautCom);
end
open_system(scopeCom);
 
%%  Start EEG
%{
set_param(model,'SimulationCommand','start')
trig = [];
trig_val = 0;
WaitSecs(3);
while isempty(trig)
    trig = get_param('TactileStimEEG/6','RunTimeObject');
end

WaitSecs(3)
while trig_val ~= 55 || trig_val == 0
    x = get(trig.OutputPort(1));
    trig_val = x.Data;
end
set_param(model,'SimulationCommand','stop')

%open_system(impCom); % Opens the Impedance Check
%}