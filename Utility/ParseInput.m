function [First, Middle, Last] = ParseInput(Input)

for i=1:length(Input)
    N = length(Input(i).x);
    First(i).x = Input(i).x(1:N/3);
    Middle(i).x = Input(i).x(N/3+1:2*N/3);
    Last(i).x = Input(i).x(2*N/3+1:end);
end

end

