function Cm = RecursiveC(m, y, Pm, Alpha, C, No)
Cm = TimeAverageDT(y.*Pm, No);
for r=1:m-1
    Cm = Cm - Alpha(m,r) * C(r);
end
end

