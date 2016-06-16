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
saveDir = pwd; % Change this to the path where participant data can be secured.

SubjectID = input('SubjectID: ');
saveData = strcat('Participant',num2str(SubjectID),'_',datestr(date,'mmddyyyy'),'_EEG'); %Participantxx_mmddyyyy_EEG
medTraining = input('0 - Premeditation Training.\n1 - PostMeditation Training.\n2 - Meditators.\n3 - Debugging: '); % If this is cross-sectional, just use "0".
saveDir = fullfile(saveDir,saveData);

model = 'TactileStimEEG';
openGUI = {'g.Nautilus','g.SCOPE', 'g.Nautilus Impedance Check','DIN'};

nautCom = strcat(model,'/',openGUI{1});
scopeCom = strcat(model,'/',openGUI{2}); % g.SC ersfind the mask parametOPE is a mask. 
impCom = strcat(model,'/',openGUI{3});
trigCom = strcat(model,'/',openGUI{4});

openCom = {nautCom, scopeCom, impCom};

load_system(model)
%open_system(openCom); % Opens both g.SCOPE and Impedance Check
open_system(nautCom);
%open_system(scopeCom,'DialogParameters'); % Opens the g.SCOPE
open_system(scopeCom);
open_system(impCom); % Opens the Impedance Check

eeglabdata = [y(2:17,:); y(24,:)];
saveVars = {'yout','SubjectID','eeglabdata'}; % Specify variables of interest to save later
save(saveData,saveVars{:});