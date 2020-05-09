function [First, Middle, Last] = ParseOutput(Output)

for i=1:length(Output)
    N = length(Output(i).y);
    First(i).y = Output(i).y_noisy(1:N/3);
    Middle(i).y = Output(i).y_noisy(N/3+1:2*N/3); 
    Last(i).y = Output(i).y(2*N/3+1:end);
end

end

