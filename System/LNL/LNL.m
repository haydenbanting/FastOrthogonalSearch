function y = LNL(g, a, I, k, x)
u = DTConvolution(x, g);
v = NonLinearity(u, a, I);
y = DTConvolution(v, k);
end

