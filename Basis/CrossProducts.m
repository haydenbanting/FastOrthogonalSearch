function Products = CrossProducts(TermsMat, NewTerms)
%-------------------------------------------------------------------------%
% Generate all cross products between TermsMat and NewTerms
%-------------------------------------------------------------------------%
idx = 1;
for i=1:size(TermsMat,1)
    for j=1:size(NewTerms,1)   
        Products(idx,:) = TermsMat(i,:) .* NewTerms(j,:);
        idx = idx + 1;  
    end  
end
end

