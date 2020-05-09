function [Output, Stats] = SetupOutput(Input, System, Stats)
Stats = NewProcess(Stats, 'Output Setup');
Output = struct();

%-------------------------------------------------------------------------%
% Loop over inputs and assign an output for an each input. Some outputs
% will require solving using a system configuration if output data is not
% provided.
%-------------------------------------------------------------------------%
for i=1:length(Input)
    
    if Input(i).output_solve_required
        %-----------------------------------------------------------------%
        % This type of input has no set of associated set of output data,
        % use the system definition to produce at output for this input.
        %-----------------------------------------------------------------%
        switch System.type
            case 'lnl'
                Output(i).y = LNL(@LinearG, @StaticNL, System.params.I, ...
                                  @LinearK, Input(i).x);
            case 'diffeq'
                Output(i).y = DE(Input(i).x);   
        end
    else
        %-----------------------------------------------------------------%
        % This type of input has an assoicated set of output data, no need
        % to compute the output.
        %-----------------------------------------------------------------%
        filename = Input(i).filename;
        M = dlmread(filename);
        Output(i).y = M(2,:);
    end
    
end % next input

%-------------------------------------------------------------------------%
% Add noise to output signals
%-------------------------------------------------------------------------%
Output = AddNoise(Output, System.params.P);
Stats = EndOfProcess(Stats);
end

