The simulator is capable of simulating any circuit with the following circuit elements:
	Resistors
	Independent voltage sources
	Independent current sources
The program reads a text input file representing the circuit and determines the node voltages using the algorithm provided below on Modified Node Analysis.
The text file will include the information regarding circuits with the following rules:
	Each element is entered in a single row.
	The first column is the unique identifier for the element whose first letter indicates the type of the element: R, I or V and the rest is an integer. The second and the third columns denote the node numbers of the element. The last column denotes the value of the element in Ohms, Amperes or Volts. 
	NodeNumber@SecondColumn < NodeNumber@ThirdColumn.
Positive value for the current source means that the current is entering the <Node@ThirdColumn.
Positive value for the voltage source means: 
Voltage of Node@SecondColumn < Voltage of Node@ThirdColumn.
	The program prompts the user for the name of the text file and display the solution (i.e. the node voltages) on screen. The program is  modular and it includes functions that takes the file name as an input argument and returns the node voltages.
