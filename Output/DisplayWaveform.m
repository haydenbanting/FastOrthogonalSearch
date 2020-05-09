function DisplayWaveform(signal, title_str, type, fig_num)

figure(fig_num)
plot(signal)
title(title_str)
xlabel('n');

switch type
    case 'input'
        ylabel('x(n)')
    case 'output'
        ylabel('y(n)')
end

