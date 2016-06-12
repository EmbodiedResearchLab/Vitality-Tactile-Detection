%% Run EEG

saveDir = pwd; % Change this to the path where participant data can be secured.

SubjectID = input('SubjectID: ','s');
saveData = strcat('Participant',SubjectID,'_',date);
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
open_system(scopeCom,'DialogParameters',[8 256 1]); % Opens the g.SCOPE
open_system(impCom); % Opens the Impedance Check

saveVars = {'yout','SubjectID'}; % Specify variables of interest to save later
save(saveData,saveVars{:});