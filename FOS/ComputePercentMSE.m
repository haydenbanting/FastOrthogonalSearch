function MSE = ComputePercentMSE(system_output, model_output, No)
MSE = 100*TimeAverageDT((model_output-system_output).^2, No);
end

