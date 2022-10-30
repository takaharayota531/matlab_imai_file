function save_history(h_history,filename)
filename = horzcat(filename, '.mat');
save(filename,'h_history');
end