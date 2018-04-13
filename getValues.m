%Function that takes the file name as an input argument and returns the node voltages.
function nodeVolts = getValues(txt_name)
    
 fid = fopen(txt_name); 
 
%Error control    

  if fid == -1                                   
     disp('file open not successful')
  end
        
        
%% Input manipulations

info_c = textscan(fid,'%s %f %f %f'); %Input in cell format.

elts_num = length(info_c{1});         %Determining total element number 
for i = elts_num:-1:1                 %Creating input in struct format.             
    info_s(i).id = info_c{1}{i};
    info_s(i).nodeLow = info_c{2}(i);
    info_s(i).nodeHigh = info_c{3}(i);
    info_s(i).value = info_c{4}(i);
end
 


%% THE A MATRIX

    %A matrix is formed of 4 Submatrices, that is G,B,C,D.
    
     %% Forming G Submatrix of A
    node_num = max(info_c{3});      %Determining node number 
    G = zeros(node_num,node_num);   %Preallocating G.
    info_s_pssv = structExtracter(info_s,'R'); %Forming a new struct with passive elts from the input struct by a func.
    num_elts_pssv = length(info_s_pssv); %finding its elt num.
    
 for i = 1:node_num % double for loops to fill two dimensions of G submatrix.
    for j= 1:node_num
        if i==j     %Filling diagonal entries of G submatrix
            for k = 1:num_elts_pssv
                 if info_s_pssv(k).nodeLow == i || info_s_pssv(k).nodeHigh...
                         == i % Determining the elts connected to the corresponding node.
                     G(i,j) = G(i,j) + (1/double(info_s_pssv(k).value)); %Sum of conductances.
                 end
            end
        else %Filling non-diagonal entries of G submatrix
            for k = 1:num_elts_pssv
                if info_s_pssv(k).nodeLow == min(i,j) && info_s_pssv(k).nodeHigh...
                         == max(i,j) %Determining the elts connected to pair of corresponding node.
                     G(i,j) = -(1/double(info_s_pssv(k).value)); %the negative conductance.
                end
            end
        end
    end
 end
      
 
    %% Forming B submatrix of A

info_s_ind_vol = structExtracter(info_s,'V'); %Forming a new struct with voltage sources from the input struct by a func.
num_elts_vol = length(info_s_ind_vol); %finding its elt num.


B = zeros(node_num,num_elts_vol); %Preallocating B.
for i = 1:node_num %Double for loops to fill B.
    for j=1:num_elts_vol
        for k=1:num_elts_vol % Finding the corresponding voltage source.
            if str2double(info_s_ind_vol(k).id(2)) == j   
                if info_s_ind_vol(k).nodeLow == i %if the negative terminal is connected to the i'th node
                    B(i,j) = -1; % then this particular location's value is -1.
                elseif info_s_ind_vol(k).nodeHigh == i %and vica versa.
                    B(i,j) = 1;
                end % otherwise, as preallocated, 0.
            end
        end
    end
end
 %% Forming C submatrix of A

C = transpose(B); 


%% Forming D submatrix of A

D = zeros(num_elts_vol); 
        
%% Contracention of A by existing four submatrices.

A = [ G, B ; C, D ];

 
%% THE z MATRIX
   %The z matrix will be developed as the combination of 2 smaller matrices i_m and e.
   
    %% Forming i_m submatrix
info_s_ind_cur = structExtracter(info_s,'I'); %Forming a new struct of current sources from the input struct by a func.
num_elts_cur = length(info_s_ind_cur); %finding its elt num.
i_m = zeros(node_num,1); %Preallocating i_m

for i = 1:node_num % For loop to fill i_m
    for j=1:num_elts_cur %Determining the independent current sources
        if double(info_s_ind_cur(j).nodeLow) == i %If the current sources are directed outward,
            i_m(i) = i_m(i) - double(info_s_ind_cur(j)... %sum of these current sources' value with a minus sign.
                .value);
        elseif double(info_s_ind_cur(j).nodeHigh) == i % vica versa
            i_m(i) = i_m(i) + double(info_s_ind_cur(j)... % with a positive sign.
                .value);
        end
    end
end

    %% Forming e submatrix
e = zeros(num_elts_vol,1);
j=1;
for i = 1:num_elts_vol
    if str2double(info_s_ind_vol(i).id(2)) == j % Finding the corresponding independent voltage source.
       e(j) = double(info_s_ind_vol(i).value); % filling the location with its value.
       j = j + 1;
    end
end 

%% Contracention of z by existing two submatrices.

z = [ i_m ; e];   


%% Determining node-voltages

x = A^-1 * z; %The circuit is solved by this matrix manipulation.
nodeVolts = zeros(node_num,1); % Preallocating the vector.

for i = 1:node_num % Only the top elements, node voltages, are needed.
    nodeVolts(i) = x(i);
end

 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 