function y = DTConvolution(x, h)
N = length(x);
y = 0*x;

for n=0:N-1
   
    for k=0:N-1
        y(n+1)=y(n+1)+x(k+1)*feval(h, n-k);
    end
    
end
end

