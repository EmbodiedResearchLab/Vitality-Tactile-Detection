function varsToSave = saveData(saveDir, savVars, compVars)
% Returns a string of variables available to save at the end of the
% experiment.

for i = 1:length(compVars)
    for j = 1:length(savVars)
        if strcmp(savVars(j).name, char(compVars{i}))
            Saving{i} = savVars(j).name;
        end
    end
end

save(fullfile(saveDir),Saving)

end