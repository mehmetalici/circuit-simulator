%This function specifically extracts elements with desired eltId and forms a new struct from them.
function struct_output = structExtracter(struct_input, eltId)
    

    j= 0; %Need two parallel loops.
    elts_num = length(struct_input);
    for i = 1:elts_num
        if struct_input(i).id(1) == eltId %Determining the dimensions of input Struct with eltId.
             j = j + 1;
             struct_output(j) = struct_input(i); %Filling the new struct with the determined struct dimension.
        end   
    end
    
    if j == 0 % That is if there is no desired eltId in the input struct,   
        struct_output = []; %The output struct will be empty.
    end

end
