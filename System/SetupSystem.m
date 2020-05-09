function [System, Stats] = SetupSystem(Stats)
%-------------------------------------------------------------------------%
% This function sets up a system based on the system.xml defintion file.
% This file will specify whether the system is a difference equation or LNL
% model. These definitons are used to solve output signals for given input
% signals. Optionally, if both input and output data are already given then
% a system description is not needed in system.xml.
%
%
% Note: LNL systems and using custom input/output data are just things I
% was trying with FOS. I was using the custom input/output data to model 
% the non-linearities of a diode. The focus of the report is on 
% difference equation systems.
%-------------------------------------------------------------------------%
Stats = NewProcess(Stats, 'System Setup');


DOMnode = xmlread([pwd '/System/system.xml']);
Sys = DOMnode.getElementsByTagName('System').item(0);
sysType = Sys.getElementsByTagName('Type').item(0);
sysParams = Sys.getElementsByTagName('Parameters').item(0);

sysP = sysParams.getElementsByTagName('P').item(0);
System.params.P = str2double(sysP.getFirstChild.getData);
System.type = char(sysType.getFirstChild.getData);

switch System.type
    case 'lnl'
        sysI = sysParams.getElementsByTagName('I').item(0);
        System.params.I = str2double(sysI.getFirstChild.getData);
    case 'diffeq'
        
    otherwise
        error(['Error: Unknown system type "' System.type '". Check system configuration file. Supported system types are: "lnl" "diffeq"']);
end

assert(System.params.P >= 0);
if System.params.P > 0
    System.noiseType = 'noisy';
else
    System.noiseType = 'noiseless';
end

Stats = EndOfProcess(Stats);
end

