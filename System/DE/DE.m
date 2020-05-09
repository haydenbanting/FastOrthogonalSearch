function y = DE(x)
y = 0 * x;
for n=2:length(x)
    % Some example difference equation system
    y(n) =  0.5*exp(-0.3*x(n)) + 0.8*exp(-0.6*y(n-1));
end



end

