%-------------------------------------------------------------------------%
% Fast Orthogonal Search Algoirthm For Non-Linear System Identification
%
% Author: Hayden Banting
% Version: 10 April 2019
%-------------------------------------------------------------------------%
close all
clear all
clc

%% Includes to Path
path(path, [pwd '/Input/']);
path(path, [pwd '/Input/Time Functions/']);
path(path, [pwd '/Input/Examples/']);
path(path, [pwd '/Output/']);
path(path, [pwd '/System/']);
path(path, [pwd '/System/LNL']);
path(path, [pwd '/System/DE']);
path(path, [pwd '/Statistics/']);
path(path, [pwd '/Basis/']);
path(path, [pwd '/FOS/']);
path(path, [pwd '/Utility/']);
path(path, [pwd '/Model/']);

%% Setup
%-------------------------------------------------------------------------%
% Setup the Stats struct which keeps track of computation times of various
% functions and processes
%-------------------------------------------------------------------------%
Stats = SetupStats();

%-------------------------------------------------------------------------%
% Parse the inputs definition file and setup the input structure
%-------------------------------------------------------------------------%
[Input, Stats] = SetupInput(Stats);

%-------------------------------------------------------------------------%
% Parse the system definition file and setup the System structure
%-------------------------------------------------------------------------%
[System, Stats] = SetupSystem(Stats);

%-------------------------------------------------------------------------%
% Generate the output strcutre based on the system and inputs
%-------------------------------------------------------------------------%
[Output, Stats] = SetupOutput(Input, System, Stats);

%-------------------------------------------------------------------------%
% Parse the model definition file and setup the model setup
%-------------------------------------------------------------------------%
[ModelSetup, Stats] = SetupModel(Stats);

%-------------------------------------------------------------------------%
% Split the inputs and outputs into 3 sections
%-------------------------------------------------------------------------%
[TrainingInput, SelectingInput, TestingInput] = ParseInput(Input);
[TrainingOutput, SelectingOutput, TestingOutput] = ParseOutput(Output);

%% Training Phase
disp(['Training Phase ...'])
%-------------------------------------------------------------------------%
% Generate various combinations of Order, L, K based on the Model Setup
% which will be used in the FOS models
%-------------------------------------------------------------------------%
[L, K, Order] = GenerateTrainingVariations(ModelSetup);

%-------------------------------------------------------------------------%
% Produce a FOS model for each variation of K, L, Order
%-------------------------------------------------------------------------%
for i=1:length(L)
    [Basis, Stats] = SetupBasis(TrainingInput, TrainingOutput, ...
                                Stats, Order(i), L(i), K(i));
    [TrainingModels(i).Model, Stats] = FOS(TrainingInput, ...
                                           TrainingOutput, ...
                                           Basis, Stats, ...
                                           L(i), K(i), ...
                                           ModelSetup.Mmax, ... 
                                           ModelSetup.eps, ...
                                           System.noiseType);
end

%% Selection Phase
disp(['Selection Phase ...'])
%-------------------------------------------------------------------------%
% For each model generated, test the output it produces over against the
% sampled system output (compute MSE) and select the best model
%-------------------------------------------------------------------------%
[ChosenModels, Stats] = SelectBestModels(TrainingModels, ...
                                         SelectingInput, ...
                                         SelectingOutput, ... 
                                         System.params.P, ...
                                         Stats);


%% Testing Phase
%-------------------------------------------------------------------------%
% Demonstrate the performance of the selected model to predict the system
%-------------------------------------------------------------------------%
[TestingOutput, Stats] = TestModels(TestingInput, TestingOutput, ...
                                    ChosenModels, Stats);
DisplayResults(TestingOutput)







