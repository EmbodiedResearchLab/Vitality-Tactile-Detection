function varsToSave = saveData(savVars, compVars)
% saveData(saveDir, savVars, compVars) returns a string of variables
% available to save at the end of the experiment.  Useful for when
% participants quit experiments early and you would like to retain their
% data.

varsToSave = cell(1,length(compVars));

for i = 1:length(compVars)
    for j = 1:length(savVars)
        if strcmp(savVars(j).name, char(compVars{i}))
            varsToSave{i} = savVars(j).name;
        end
    end
end
%varsToSave = char(varsToSave{:});
%save(fullfile(saveDir),Saving)
varsToSave = varsToSave(~cellfun('isempty',varsToSave));

end