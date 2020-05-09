function Check = CheckSignificance(gm, D, y, M, N, No)
%-------------------------------------------------------------------------%
% Computes the 0.05 level of significance check
%-------------------------------------------------------------------------%
LHS = gm(M).^2 * D(M, M);
RHS = TimeAverageDT(y.*2, No);
for m=1:M-1
    RHS = RHS - gm(m).^2 * D(m,m);
end
RHS = RHS * 4 / (N - No + 1);

Check = (abs(LHS) > abs(RHS));

end

