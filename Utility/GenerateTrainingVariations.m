function [L, K, Order] = GenerateTrainingVariations(ModelSetup)
MaxOrder = ModelSetup.Order;          % Maximum solve order
MaxL = ModelSetup.L;                  % Maximum x-delay
MaxK =  ModelSetup.K;                 % Maximum y-delay
nVariations = ModelSetup.nVariations; % Number of Order, K, L variations

L = round(linspace(0, MaxL, nVariations));
K = round(linspace(1, MaxK, nVariations));
Order = round(linspace(MaxOrder-1, MaxOrder, nVariations));
end

