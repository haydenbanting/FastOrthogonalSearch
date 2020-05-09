function [Basis, Stats] = SetupBasis(Input, Output, Stats, Order, L, K)
indent = '    ';
Stats = NewProcess(Stats, [indent 'Basis Setup (Order=' num2str(Order) ...
                           ', L=' num2str(L) ', K=' num2str(K) ')']);
Basis = struct();

%-------------------------------------------------------------------------%
% Loop over inputs (and associated outputs) to generate the candidates up
% to desired order
%-------------------------------------------------------------------------%
for i=1:length(Input)
    
    x = Input(i).x;
    y = Output(i).y;
    Candidates = [];
    Types = struct();
    Types.term = [];
    Types.delays = [];
        
    %---------------------------------------------------------------------%
    % Solve all combination of candidates for all orders up to the
    % specificed order. For example, order 3 will have the following
    % candidates generated: x, y, xx, xy, yy, xxx, xxy, xyy, yyy
    %---------------------------------------------------------------------%
    for iOrder=1:Order
        for j=0:iOrder 
                xTerms = iOrder - j;
                yTerms = j;
                [NewCandidates, NewTypes] = GenerateCandidates(x, y, ...
                                                               xTerms, ...
                                                               yTerms, ...
                                                               L, K);
                Candidates = [Candidates; NewCandidates];
                Types = [Types, NewTypes];
        end 
    end
    Types(1) = [];
    
    %---------------------------------------------------------------------%
    % Reshape the Candidates mat into the Basis structure, include the
    % associated type of each candidate
    %---------------------------------------------------------------------%
    for k=1:size(Candidates, 1)
        Basis(i).Candidates(k).Pm = Candidates(k,:);
        Basis(i).Candidates(k).Type = Types(k);
    end
    
end

Stats = EndOfProcess(Stats);

end

