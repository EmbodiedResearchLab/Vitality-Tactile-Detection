function displayResponses(output_array, varargin)
% Takes in output array and displays it for the researcher.  Includes which
% hand was stimulated when 2 stimulators are used.

if nargin == 1
    if size(output_array,1) < 3
        % Outputs trial data
        Trial = output_array(end, 1);
        RunTime = output_array(end, 2);
        Delay = output_array(end, 3);
        Hand = output_array(end, 4);
        Intensity = output_array(end, 5);
        Response = output_array(end, 6);
        Trialtime = output_array(end, 7);
        ReactionTime = output_array(end,8);
    else
        Trial = output_array(end-2:end, 1);
        RunTime = output_array(end-2:end, 2);
        Delay = output_array(end-2:end, 3);
        Hand = output_array(end-2:end, 4);
        Intensity = output_array(end-2:end, 5);
        Response = output_array(end-2:end, 6);
        Trialtime = output_array(end-2:end, 7);
        ReactionTime = output_array(end-2:end,8);
    end
    table(Trial, RunTime, Delay, Hand, Intensity, Response, ReactionTime, Trialtime)
elseif nargin == 2
    if strcmp(varargin{1}, 'All')
        % Outputs all of the data in output_array if noted.
        Trial = output_array(:, 1);
        RunTime = output_array(:, 2);
        Delay = output_array(:, 3);
        Hand = output_array(:, 4);
        Intensity = output_array(:, 5);
        Response = output_array(:, 6);
        Trialtime = output_array(:, 7);
        ReactionTime = output_array(:,8);
        table(Trial, RunTime, Delay, Hand, Intensity, Response, Trialtime, ReactionTime)
        
    elseif strcmp(varargin{1}, 'Threes')
        Trial = output_array(end-2:end, 1);
        RunTime = output_array(end-2:end, 2);
        Delay = output_array(end-2:end, 3);
        Hand = output_array(end-2:end, 4);
        Intensity = output_array(end-2:end, 5);
        Response = output_array(end-2:end, 6);
        Trialtime = output_array(end-2:end, 7);
        ReactionTime = output_array(end-2:end,8);
        table(Trial, RunTime, Delay, Hand, Intensity, Response, Trialtime, ReactionTime)
    elseif strcmp(varargin{1}, 'Error')
        if size(output_array,1) < 3
            % Outputs trial data
            Trial = output_array(end, 1);
            RunTime = output_array(end, 2);
            Delay = output_array(end, 3);
            Hand = output_array(end, 4);
            Intensity = output_array(end, 5);
            Response = output_array(end, 6);
            Trialtime = output_array(end, 7);
            ReactionTime = output_array(end,8);
            ErrorCount = output_array(end, 9);
        else
            Trial = output_array(end-2:end,1);
            RunTime = output_array(end-2:end,2);
            Delay = output_array(end-2:end,3);
            Hand = output_array(end-2:end,4);
            Intensity = output_array(end-2:end,5);
            Response = output_array(end-2:end,6);
            Trialtime = output_array(end-2:end,7);
            ReactionTime = output_array(end-2:end,8);
            ErrorCount = output_array(end-2:end,9);
        end
        table(Trial, RunTime, Delay, Hand, Intensity, Response, Trialtime, ReactionTime, ErrorCount)
    end    
end
end