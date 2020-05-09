function Stats = EndOfProcess(Stats)
%-------------------------------------------------------------------------%
% Call this function to save the computation time of some process.
% NewProcess must be previously called.
%-------------------------------------------------------------------------%
Stats.process(Stats.process_idx).time = toc(Stats.timing.start);
disp([Stats.process(Stats.process_idx).name ' ... ' num2str(Stats.process(Stats.process_idx).time) 's'])
Stats.process_idx = Stats.process_idx + 1;
end

