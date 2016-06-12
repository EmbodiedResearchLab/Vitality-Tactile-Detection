function displayResponses(output_array, varargin)
% Takes in output array and displays it for the researcher.

if nargin == 1
    if size(output_array,1) < 3
        % Outputs trial data
        Trial = output_array(end, 1);
        RunTime = output_array(end, 2);
        Delay = output_array(end, 3);
        Intensity = output_array(end, 4);
        Response = output_array(end, 5);
        Trialtime = output_array(end, 6);
        ReactionTime = output_array(end,7);
    else
        Trial = output_array(end-2:end, 1);
        RunTime = output_array(end-2:end, 2);
        Delay = output_array(end-2:end, 3);
        Intensity = output_array(end-2:end, 4);
        Response = output_array(end-2:end, 5);
        Trialtime = output_array(end-2:end, 6);
        ReactionTime = output_array(end-2:end,7);
    end
    table(Trial, RunTime, Delay, Intensity, Response, ReactionTime, Trialtime)
elseif strcmp(varargin{1}, 'All')
    % Outputs all of the data in output_array if noted.
    Trial = output_array(:,1);
    RunTime = output_array(:,2);
    Delay = output_array(:, 3);
    Intensity = output_array(:, 4);
    Response = output_array(:, 5);
    Trialtime = output_array(:, 6);
    ReactionTime = output_array(:, 7);
    if size(output_array,2) == 8
        Error_Count = output_array(:,8);
        table(Trial, RunTime, Delay, Intensity, Response, Trialtime, ReactionTime, Error_Count)
        %return
    end
elseif strcmp(varargin{1}, 'Error')
    % Display unique to Training Blocks that includes an error count.
    if size(output_array,1) < 3
        Trial = output_array(end,1);
        RunTime = output_array(end,2);
        Delay = output_array(end,3);
        Intensity = output_array(end,4);
        Response = output_array(end,5);
        Trialtime = output_array(end,6);
        ReactionTime = output_array(end,7);
        ErrorCount = output_array(end,8);
    else
        Trial = output_array(end-2:end,1);
        RunTime = output_array(end-2:end,2);
        Delay = output_array(end-2:end,3);
        Intensity = output_array(end-2:end,4);
        Response = output_array(end-2:end,5);
        Trialtime = output_array(end-2:end,6);
        ReactionTime = output_array(end-2:end,7);
        ErrorCount = output_array(end-2:end,8);
    end
    table(Trial, RunTime, Delay, Intensity, Response, Trialtime, ReactionTime, ErrorCount)
    %return
end


end