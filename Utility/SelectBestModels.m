function [ChosenModel, Stats] = SelectBestModels(Models, Input, Output, P, Stats)
indent = '    ';

for i = 1:length(Input)
    
    for j = 1:length(Models)
        Stats = NewProcess(Stats, [indent 'Testing Model ' num2str(j) ' Output For Input ' num2str(i)]);
        Model = Models(j).Model;
        No = max(Model.K, Model.L);
        y_model = GenerateOutputFromModel(Input(i), Output(i), Model.Data(i), No);
        Test(i).MSE(j) = ComputePercentMSE(Output(i).y, y_model, No);
        Stats = EndOfProcess(Stats);
    end
    
    [~, idx] = min(Test(i).MSE);
    ChosenModel(i).ModelData = Models(idx).Model.Data(i);
    ChosenModel(i).ModelData.K = Models(idx).Model.K;
    ChosenModel(i).ModelData.L = Models(idx).Model.L;
    disp([indent 'Selected Best Model With MSE=' num2str(Test(i).MSE(idx)) ' (ideal MSE=' num2str(ComputeIdealMSE(P)) ')'])
    
end



end

