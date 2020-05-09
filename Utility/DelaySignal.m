function y = DelaySignal(x, delay)
%-------------------------------------------------------------------------%
% This function takes an input signal x and returns a signal y which is the
% same length as x but with a delay.
%-------------------------------------------------------------------------%
y = [zeros(1, delay) x(1:end-delay)];
end

