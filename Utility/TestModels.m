function [Output, Stats] = TestModels(Input, Output, Models, Stats)

for i=1:length(Input)
     K = Models(i).ModelData.K;
     L = Models(i).ModelData.L;
     No = max([K L]);
     Output(i).y_model = GenerateOutputFromModel(Input(i), Output(i), Models(i).ModelData, No);
     Output(i).MSE = ComputePercentMSE(Output(i).y, Output(i).y_model, No);
end

end

