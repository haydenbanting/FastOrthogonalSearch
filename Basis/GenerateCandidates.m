function [Candidates, Types] = GenerateCandidates(x, y, num_x, num_y, L, K)

termString = '';
for i=1:num_x
    termString = strcat(termString, 'x');
end
for i=1:num_y
    termString = strcat(termString, 'y');
end

%-------------------------------------------------------------------------%
% Evaluate x(n-l), l=0,...,L and y(n-k), k=1,...,K
%-------------------------------------------------------------------------%
if (num_x > 0)
    for xDelay=0:L
       xTerms(xDelay+1,:) = DelaySignal(x, xDelay);
    end 
end

if (num_y > 0)
    for yDelay=1:K
        yTerms(yDelay,:) = DelaySignal(y, yDelay);
    end
end

%-------------------------------------------------------------------------%
% Evaluate of all cross products for either x or y terms (e.g. xx, xxx, etc
% or yy, yyy, etc)
%-------------------------------------------------------------------------%
if (num_x > 0) && (num_y > 0) %xy, xxy, xyy, eyc
    
    TermsMat = xTerms;
    for i=2:num_x
        TermsMat = CrossProducts(TermsMat, xTerms);
    end
    
    for i=1:num_y
       TermsMat = CrossProducts(TermsMat, yTerms);
    end
    
elseif (num_x > 0) && (num_y == 0) %xx, xxx, etc
    
    TermsMat = xTerms;
    for i=2:num_x
        TermsMat = CrossProducts(TermsMat, xTerms);
    end
      
elseif (num_y > 0) && (num_x == 0) % yy, yyy, etc
    
    TermsMat = yTerms;
    for i=2:num_y
        TermsMat = CrossProducts(TermsMat, yTerms);
    end
end

%-------------------------------------------------------------------------%
% Assign the 
%-------------------------------------------------------------------------%
Candidates = TermsMat;


%-------------------------------------------------------------------------%
% Return the details of the candidate, that is what type 'x', 'y', 'xy',
% etc and what are the delays for each. 
%-------------------------------------------------------------------------%
xDelay = 0;
yDelay = 1;
delays = zeros(1, num_x+num_y);
delays(end-num_y+1:end) = yDelay;
count = [];

for i=1:size(Candidates,1)
    
    Types(i).term = termString;
    
    %---------------------------------------------------------------------%
    % If a term contains on y-terms
    %---------------------------------------------------------------------%
    if (num_x == 0) 
                
        if ~isempty(count)
            if conseq > 0
                delays(count(end)-conseq) = delays(count(end)-conseq) + 1;
                delays(count(end)-conseq+1:end) = 1;
                yDelay = 1;
            end
        end
        
        delays(num_y) = yDelay;

        count = find(delays == K);
        conseq = 0;
        for j = length(delays):-1:1
            if (delays(j) == K)
                conseq = conseq + 1;
            else
                break
            end
        end
        
    %---------------------------------------------------------------------%
    % If a term contains on x-terms
    %---------------------------------------------------------------------% 
    elseif (num_y == 0) 
        
        if ~isempty(count)
            if conseq > 0
                delays(count(end)-conseq) = delays(count(end)-conseq) + 1;
                delays(count(end)-conseq+1:end) = 0;
                xDelay = 0;
            end
        end
        
        delays(num_x) = xDelay;

        count = find(delays == L);
        conseq = 0;
        for j = length(delays):-1:1
            if (delays(j) == L)
                conseq = conseq + 1;
            else
                break
            end
        end
        
    %---------------------------------------------------------------------%
    % If a term contains both x and y terms
    %---------------------------------------------------------------------%                  
    else 
        
        if ~isempty(count)
            if conseq > 0
                delays(count(end)-conseq) = delays(count(end)-conseq) + 1;
                delays(count(end)-conseq+1:end) = 1;
                delays(count(end)-conseq+1:num_x) = 0;
                yDelay = 1;
            end
        end
        
        delays(num_x+num_y) = yDelay;
        
        xCount = find(delays(1:num_x) == L);
        yCount = find(delays(num_x+1:end) == K);
        count = [xCount, num_x+yCount];
        
        conseq = 0;
        xDelays = delays(1:num_x);
        yDelays = delays(num_x+1:end);
        chainBroken = 0;
        for j = length(yDelays):-1:1
            if (yDelays(j) == K)
                conseq = conseq + 1;
            else
                chainBroken = 1;
                break
            end
        end
        for j = length(xDelays):-1:1
            if (xDelays(j) == L) && (~chainBroken)
                conseq = conseq + 1;
            else
                break
            end
        end
        
        
    end
    
    Types(i).delays = delays;
    xDelay = xDelay + 1;
    yDelay = yDelay + 1;
         
end


end

