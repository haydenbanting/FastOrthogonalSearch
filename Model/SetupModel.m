function [Model, Stats] = SetupModel(Stats)
Stats = NewProcess(Stats, 'Model Setup');

DOMnode = xmlread([pwd '/Model/model.xml']);
Mod = DOMnode.getElementsByTagName('Model').item(0);
ModOrder = Mod.getElementsByTagName('Order').item(0);
ModXDelay = Mod.getElementsByTagName('Lmax').item(0);
ModYDelay = Mod.getElementsByTagName('Kmax').item(0);
ModMaxM = Mod.getElementsByTagName('Mmax').item(0);
ModEps = Mod.getElementsByTagName('eps').item(0);
ModNV = Mod.getElementsByTagName('TrainingVariations').item(0);

Model.Order = str2double(ModOrder.getFirstChild.getData);
Model.L = str2double(ModXDelay.getFirstChild.getData);
Model.K = str2double(ModYDelay.getFirstChild.getData);
Model.Mmax = str2double(ModMaxM.getFirstChild.getData);
Model.eps = str2double(ModEps.getFirstChild.getData);
Model.nVariations = str2double(ModNV.getFirstChild.getData);

assert(Model.L >= 0); assert(Model.K > 0); assert(Model.Order > 0);
Stats = EndOfProcess(Stats);
end

