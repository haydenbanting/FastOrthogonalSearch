function [Input, Stats] = SetupInput(Stats)
Stats = NewProcess(Stats, 'Input Setup');
%-------------------------------------------------------------------------%
% This function parses an input xml file which contains the varoius inputs 
% to apply to the system. Each input in the ml file is defined by a "type",
% "NumSamples", and "TimeStep". Type will specify the time function which
% describes the input, such as white-gaussian noise, step function, dirac
% delta, sinusoid, etc. NumSamples is the number of samples to use in the
% input signal, and TImeStep is the time interval between each sample. The
% input signals are saved in a single structure and returned by this
% function.
%-------------------------------------------------------------------------%
% Parse all inputs data from XML
DOMnode = xmlread([pwd '/Input/input.xml']);
Inputs = DOMnode.getElementsByTagName('Input');

for i=0:Inputs.getLength-1
    iInput = Inputs.item(i);
    typeEle = iInput.getElementsByTagName('Type');
    Input(i+1).type = char(typeEle.item(0).getFirstChild.getData);
    
    if strcmp(Input(i+1).type, 'iodata')
        dataFileEle = iInput.getElementsByTagName('Filename');
        Input(i+1).filename =  char(dataFileEle.item(0).getFirstChild.getData);
        Input(i+1).output_solve_required = 0;   
    else
        Input(i+1).output_solve_required = 1;   
        numSamplesEle = iInput.getElementsByTagName('NumSamples');
        timeStepEle = iInput.getElementsByTagName('TimeStep');
        Input(i+1).n = str2double(numSamplesEle.item(0).getFirstChild.getData);
        Input(i+1).dt = str2double(timeStepEle.item(0).getFirstChild.getData);
    end
    

end

% Generate samples for each input 
for i=1:length(Input)
    
    type = Input(i).type;

    switch type
        case 'wgn'
            n = Input(i).n;
            for j=1:n
                Input(i).x(j) = white_gaussian_noise(j);
            end
            
        case 'sinusoid'
            n = Input(i).n;
            dt = Input(i).dt;
            t = linspace(0, dt*(n-1), n);
            Input(i).x = sinusoid(t);
            
        case 'dirac'
            n = Input(i).n;
            dt = Input(i).dt;
            t = linspace(0, dt*(n-1), n);
            Input(i).x = dirac_delta(t);
            
        case 'step'
            n = Input(i).n;
            dt = Input(i).dt;
            t = linspace(0, dt*(n-1), n);
            Input(i).x = unit_step(t);
            
        case 'triangle'
            n = Input(i).n;
            dt = Input(i).dt;
            t = linspace(0, dt*(n-1), n);
            Input(i).x = sawtooth(t) + 2*sawtooth(2*t) + sawtooth(3*t);
            
        case 'iodata'
            filename = Input(i).filename;
            M = dlmread(filename);
            Input(i).x = M(1,:);
            
        otherwise
            error(['Error: Unknown input waveform "' type '". Check input configuration file. Supported input types are: "wgn" "sinusoid" "triangle" "step" "dirac" "iodata"']);
    end
end

Stats = EndOfProcess(Stats);
end

