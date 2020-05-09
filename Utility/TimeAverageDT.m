function ave = TimeAverageDT(x, No)
%-------------------------------------------------------------------------%
% This function evaluates the discrete time average of a signal x(n) over
% n=No,...,N. To average the entire signal, that is n=1,...,N pass No as 1.
%-------------------------------------------------------------------------%
N = length(x);
ave = 1 / (N-No+1) * sum(x(No:N));
end

