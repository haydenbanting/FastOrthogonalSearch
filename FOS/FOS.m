function [Model, Stats] = FOS(Input, Output, Basis, Stats, L, K, Mmax, eps, type)

%-------------------------------------------------------------------------%
% Convenience variables fror text output
%-------------------------------------------------------------------------%
indent = '    ';
doubleIndent = [indent indent];

%-------------------------------------------------------------------------%
% Compute No
%-------------------------------------------------------------------------%
No = max([L K]);

for i=1:length(Input) 
    
    %---------------------------------------------------------------------%
    % Initialize start of algoirthm for this input
    %---------------------------------------------------------------------%
    Stats = NewProcess(Stats, [indent 'FOS Setup (' type ') for Input ' ...
                               num2str(i)] );
    N = length(Input(i).x);
    assert(No < N, 'Delay can not be longer than signal');
    x = Input(i).x;
    y = Output(i).y;
    ybar = TimeAverageDT(y, No);
    Stats = EndOfProcess(Stats);
    
    %---------------------------------------------------------------------%
    % Keep track of the setup used for this model
    %---------------------------------------------------------------------%
    Model.L = L;
    Model.K = K;

    %---------------------------------------------------------------------%
    % Solve first model term and require values
    %---------------------------------------------------------------------%
    Stats = NewProcess(Stats, [doubleIndent 'Assigned Candidate for M=1']);
    Model.Data(i).P(1,:) = ones(1,N);
    Model.Data(i).g(1) = ybar;
    Model.Data(i).Alpha(1,1) = 1;
    Model.Data(i).Q(1)= ybar^2;
    Stats = EndOfProcess(Stats);
    
    %---------------------------------------------------------------------%
    % Pull the candidate terms
    %---------------------------------------------------------------------%
    Candidates = Basis(i).Candidates;
    
    %---------------------------------------------------------------------%
    % Search for next model terms
    %---------------------------------------------------------------------%
    Searching = true;
    M = 2;
    while (Searching && M <= Mmax)
        
        Stats = NewProcess(Stats, [doubleIndent ...
                                   'Found Best Model Candidate for M=' ...
                                   num2str(M) ' out of ' ...
                                   num2str(length(Candidates)) ...
                                   ' Possible']);

        %-----------------------------------------------------------------%
        % Loop over candidates, evaluate Q(M) for each
        %-----------------------------------------------------------------%
        for j=1:length(Candidates)
            
            %-------------------------------------------------------------%
            % Reset some matricies
            %-------------------------------------------------------------%
            D = [];
            C = [];
             
            %-------------------------------------------------------------%
            % Calculate D(0,0)
            %-------------------------------------------------------------%
            D(1,1) = 1;

            %-------------------------------------------------------------%
            % Create a convenience variable which contains all model 
            %-------------------------------------------------------------%
            P = [Model.Data(i).P; Candidates(j).Pm];
            
            %-------------------------------------------------------------%
            % Calculate D(m,0)
            %-------------------------------------------------------------%
            for m=2:M
                D(m,1) = TimeAverageDT(P(m,:), No);
            end
             
            %-------------------------------------------------------------%
            % Calculate all Alpha(m,r) and D(m,r+1) for m=1,...,M and 
            % r=0,...,m-1
            %-------------------------------------------------------------%
            for m=2:M
                for r=1:m-1
                    Alpha(m,r) = D(m,r) / D(r,r);
                    D(m, r+1) = RecursiveD(m, r+1, P(m,:), P(r+1,:), ...
                                           Alpha, D, No);
                end
            end
            
            %-------------------------------------------------------------%
            % Evaluate all C(m)
            %-------------------------------------------------------------%
            C(1) = ybar;
            for m=2:M
                C(m) = RecursiveC(m, y, P(m,:), Alpha, C, No);
            end
                            
            %-------------------------------------------------------------%
            % Evaluate Q(M) for this candidate
            %-------------------------------------------------------------%
            gm = C(M) / D(M, M);
            QM = gm^2 * D(M, M);
                               
            %-------------------------------------------------------------%
            % Store candidate data 
            %-------------------------------------------------------------%
            Candidates(j).Q = QM;
            Candidates(j).g = gm;
            Candidates(j).D = D;
            Candidates(j).Alpha = Alpha;
            Candidates(j).C = C;
                       
        end % Next candidate
        
        %-----------------------------------------------------------------%
        % All candidates have had Q(M) evaluated. Find the candidate with
        % largest Q(M). Check if its getting added to the model or not.
        %-----------------------------------------------------------------%
        [Qmax, idx] = max([Candidates(:).Q]);
        
        if strcmp(type, 'noisy')
            check = CheckSignificance([Model.Data(i).g, ...
                                       Candidates(idx).g], ...
                                       Candidates(idx).D, y, M, N, No);
        elseif strcmp(type, 'noiseless')
            check = (Qmax > eps);
        end

        if check
            %-------------------------------------------------------------%
            % This candidate meets criteria to be added
            %-------------------------------------------------------------%
            Model.Data(i).Q(M) = Candidates(idx).Q;
            Model.Data(i).P(M,:) = Candidates(idx).Pm;
            Model.Data(i).Type(M) = Candidates(idx).Type;
            Model.Data(i).g(M) = Candidates(idx).g;
            Model.Data(i).Alpha = Candidates(idx).Alpha;
            Candidates(idx) = [];
            Stats = EndOfProcess(Stats);     
        else
            Searching = false;
        end
        
        %-----------------------------------------------------------------%
        % Prepare for next model term, if continuing
        %-----------------------------------------------------------------%
        M = M + 1; % Next M

    end % Next model term
    
    %---------------------------------------------------------------------%
    % Convert coefficients from gm to am
    %---------------------------------------------------------------------%
    Model.Data(i).a = ConvertCoefficients(Model.Data(i).g, ...
                                          Model.Data(i).Alpha);
    
end

end

