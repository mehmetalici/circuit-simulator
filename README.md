# Circuit Simulator
The program implements circuit simulator using Modified Nodal Analysis Algorithm. It reads a text input file representing the circuit and determines the node voltages using the algorithm Modified Node Analysis.

## Overview
The simulator is capable of simulating any circuit with the following circuit elements:
- Resistors
- Independent voltage sources
- Independent current sources

The program prompts the user for the name of the text file and display the solution (i.e. the node voltages) on screen. The program is  modular and it includes functions that takes the file name as an input argument and returns the node voltages.

The text file will include the information regarding circuits with the following rules:
- Each element is entered in a single row.
- The first column is the unique identifier for the element whose first letter indicates the type of the element: R, I or V and the rest is an integer. The second and the third columns denote the node numbers of the element. The last column denotes the value of the element in Ohms, Amperes or Volts. 
- NodeNumber@SecondColumn < NodeNumber@ThirdColumn.
- Positive value for the current source means that the current is entering the <Node@ThirdColumn.
- Positive value for the voltage source means: 
- Voltage of Node@SecondColumn < Voltage of Node@ThirdColumn.

### Running The Tests

Suppose the input file contains the following:
```
V1 0 1 80
V2 5 7 50
V3 1 2 -15
V4 2 8 75 
V5 4 10 -60
V6 12 13 160
V7 10 11 -100
I1 4 5 10
I2 0 7 -20
I3 9 10 10
I4 11 12 -20
I5 2 6 -10
I6 4 13 -2
R1 1 2 5	
R3 0 2 5
R4 4 6 8
R5 6 7 4.3
R6 2 3 5.7
R7 3 4 10.2
R8 4 12 40
R9 1 8 80
R10 8 9 30
```
The program outputs:
```
NODE 1 V:80.000000
NODE 2 V:65.000000
NODE 3 V:-49.000000
NODE 4 V:-253.000000
NODE 5 V:-506.000000
NODE 6 V:-413.000000
NODE 7 V:-456.000000
NODE 8 V:140.000000
NODE 9 V:-160.000000
NODE 10 V:-313.000000
NODE 11 V:-413.000000
NODE 12 V:-1133.000000
NODE 13 V:-973.000000
```

