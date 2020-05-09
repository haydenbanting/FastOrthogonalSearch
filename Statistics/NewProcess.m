function Stats = NewProcess(Stats, name)
%-------------------------------------------------------------------------%
% Call this function to start timing a process. The variable name will is a
% description of what process is being done. Call EndOfProcess to stop
% timing and save.
%-------------------------------------------------------------------------%
Stats.timing.start = tic;
Stats.process(Stats.process_idx).name = name;
end

