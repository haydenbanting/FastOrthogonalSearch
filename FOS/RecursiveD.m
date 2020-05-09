function Dmr = RecursiveD(m, r, Pm, Pr, Alpha, D, No)
Dmr = TimeAverageDT(Pm .* Pr, No);
for i=1:r-1
     Dmr = Dmr - Alpha(r,i) * D(m, i);
end
end

