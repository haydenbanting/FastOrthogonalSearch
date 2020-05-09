function DisplayResults(Output)

for i = 1:length(Output)
    
    y = Output(i).y;
    y_model = Output(i).y_model;
  
    figure(i)
    hold on
    plot(y);
    plot(y_model);
    xlabel('n');
    ylabel('y(n)');
    legend('System Output', 'FOS Model Output')
   
end

end

