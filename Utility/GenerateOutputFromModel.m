function y_model = GenerateOutputFromModel(Input, Output, ModelData, No)

Types = ModelData.Type;
Coeffs = ModelData.a;
N = length(Input.x);
M = length(Types);

for i=2:length(Types)
    
    %---------------------------------------------------------------------%
    % Get info on what types of terms are in the model
    %---------------------------------------------------------------------%
    type_str = Types(i).term;
    term(i).num_x = count(type_str, 'x');
    term(i).num_y = count(type_str, 'y');
    term(i).x_delays = Types(i).delays(1:term(i).num_x);
    term(i).y_delays = Types(i).delays(term(i).num_x+1:end);
     
end

y_model = zeros(1, N);
y_model(1:No) = Output.y(1:No);
for i=No+1:N % for each sample
    
    y_model(i) = Coeffs(1);
    
    for j=2:M % for each term
        
        curTerm = 1;
        
        for ix=1:term(j).num_x
            curTerm = curTerm * Input.x(i-term(j).x_delays(ix));
        end
        
        for iy=1:term(j).num_y
            curTerm = curTerm * y_model(i-term(j).y_delays(iy));
        end
        
        y_model(i) = y_model(i) + Coeffs(j) * curTerm;
        
    end
     
end

end

