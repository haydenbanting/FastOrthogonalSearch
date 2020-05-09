function Output = AddNoise(Output, P)
assert(P >= 0)

for i=1:length(Output)
    
    y = Output(i).y;
    
    %---------------------------------------------------------------------%
    % Generate WGN
    %---------------------------------------------------------------------%
    N = length(Output(1).y);
    u = randn(1, N);
    
    %---------------------------------------------------------------------%
    % Measure ratio of variance
    %---------------------------------------------------------------------%
    a = P * var(y) / 100 / var(u);

    %---------------------------------------------------------------------%
    % Add correctly scaled noise which contaminated output by P percent
    %---------------------------------------------------------------------%
    Output(i).y_noisy = y + sqrt(a)*u;
    
     
end


end
