function a = ConvertCoefficients(g, Alpha)
%-------------------------------------------------------------------------%
% This function converts coefficients g_m to a_m
%-------------------------------------------------------------------------%
M = length(g); % There should be M total coefficients
a = zeros(1, M);

for m=1:M % Evaluate the m-th coefficient
    
    % Evaluate all v(i) required for a(m)
    v = zeros(1, M);
    v(m) = 1;
    for i=m+1:M
        for r=m:i-1
            v(i) = v(i) - Alpha(i, r) * v(r);
        end
    end
    
    % Evaluate a(m)
    for i=m:M
        a(m) = a(m) + g(i) * v(i);
    end
    
end


end

