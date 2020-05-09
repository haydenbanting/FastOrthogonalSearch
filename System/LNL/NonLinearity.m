function v = NonLinearity(u, a, I)
v=0*u;
for i=0:I
   v = v + feval(a, i) * u .^ i;
end

end

