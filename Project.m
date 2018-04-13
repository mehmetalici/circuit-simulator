%Circuit Simulator Program: it prompt the user for the name of the text file and display the solution (i.e. the node voltages) on screen. 

txt_name = input('Please enter the name of the file ' , 's'); %Getting the circuit from the user

node_volts = getValues(txt_name); %Determining the node-voltages.


node_num = length(node_volts);   %Printing the result
for i= 1:node_num  
    fprintf("NODE %d V:%f\n" , i, node_volts(i));
end