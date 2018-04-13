function circuitSim(fid)
fid='circuit.txt'
[elName Node1 Node2 Val]=textread(fid,'%s %s %s %s');
%Initialize some conditions
ResNu=0;
VsNu=0;
IsNu=0;
NodeNu=0;
%name cases
for i=1:length(elName)
    if (elName{i}(1))=='R'
        ResNu=ResNu+1;
        Res(ResNu).Name=elName{i};
        Res(ResNu).Node1=str2num(Node1{i});
        Res(ResNu).Node2=str2num(Node2{i});
        Res(ResNu).Value=str2num(Val{i});
               
    elseif(elName{i}(1))=='V',
        VsNu=VsNu+1;
        Vs(VsNu).Name=elName{i};
        Vs(VsNu).Node1=str2num(Node1{i});
        Vs(VsNu).Node2=str2num(Node2{i});
        Vs(VsNu).Value=str2num(Val{i});
    else (elName{i}(1))=='I',
        IsNu=IsNu+1;
        Is(IsNu).Name=elName{i};
        Is(IsNu).Node1=str2num(Node1{i});
        Is(IsNu).Node2=str2num(Node2{i});
        Is(IsNu).Value=str2num(Val{i});     
    end
    NodeNu=max(str2num(Node1{i}),max(str2num(Node2{i}),NodeNu));
end
%Cell Arrays to split A to (G B C D),X to (V j) and Z to (I E)
%G=(n*n),B=(n*m),C=(m*n),D=(m*m),v=(n*1),j=(m*1),i=(n*1),e=(m*1)
%n=number of nodes , m=number of independent voltage sources

G=cell(NodeNu,NodeNu);
B=cell(NodeNu,VsNu);
C=cell(VsNu,NodeNu);
D=cell(VsNu,VsNu);
V=cell(NodeNu,1);
J=cell(VsNu,1);
I=cell(NodeNu,1);
E=cell(VsNu,1);

%Matrix G
[G{:}]=deal('0');
for i=1:ResNu
    nd1=Res(i).Node1;
    nd2=Res(i).Node2;
    g = ['1/' Res(i).Name];  
    
    %No connection to ground *(-)
    if (nd1~=0) & (nd2~=0)
        G{nd1,nd2}=[ G{nd1,nd2} '-' g];
        G{nd2,nd1}=[ G{nd2,nd1} '-' g];
    end
   %diagonal entries
    if (nd1~=0),
        G{nd1,nd1}=[ G{nd1,nd1} '+' g];
    end
   %diagonal entries
    if (nd2~=0),
        G{nd2,nd2}=[ G{nd2,nd2} '+' g];
    end   
end
%Matrix B
%Positive value for the voltage source means
%Voltage of Node@SecondColumn(n1) < Voltage of Node@ThirdColumn(n2).
[B{:}]=deal('0'); 
for i=1:VsNu       
    for j=1:NodeNu  
        if (Vs(i).Node1==j)       
            B{j,i}='-1';                 
        elseif (Vs(i).Node2==j)   
            B{j,i}='1';
        end
    end
end
%Matrix C
[C{:}]=deal('0');
for i=1:VsNu          
    for j=1:NodeNu     
        if (Vs(i).Node1==j)      
            C{i,j}='-1';                
        elseif (Vs(i).Node2==j)   
            C{i,j}='1';
        end
    end
end
%Matrix D
%Matrix D Is always zero except there are dependent sources 
%in our case there can not be dependent source in ckt so...
[D{:}]=deal('0');%always zero
%Matrix V
%unknown voltages at equivalant node in circuit
%v_1 means voltage at node 1 v_2(node2)...NodeNu
for i=1:NodeNu
    V{i}=['v_' num2str(i)];
end
%Matrix J
%unknown currents throgh the voltage sources (m*1)=(VsNu*1)
for i=1:VsNu
    J{i}=['I_' Vs(i).Name];
end
%Matrix I
[I{:}]=deal('0');
%Positive value for the current source means that
%the current Is entering the Node@ThirdColumn.
%contains sum of currents through resIstors into corresponding nodes
%zero or sum of ind current sources
for i=1:NodeNu
    for j=1:IsNu
        if (Is(j).Node1==i)
            I{i}=[I{i} '-' Is(j).Name];
        elseif (Is(j).Node2==i)
            I{i}=[I{i} '+' Is(j).Name];
        end
    end
end
%Matrix E
%hold values of the independent voltage sources (Vs(1),...Vs(VsNu))
[E{:}]=deal('0');
for i=1:VsNu
    E{i}=Vs(i).Name;
end
%put together G B C D as Matrix A
%V J as Matrix X
%I E as Matrix Z
cA=[deal(G) deal(B);
    deal(C) deal(D)];
cX=[deal(V);
    deal(J)];
cZ=[deal(I);
    deal(E)];
%to define matrices(character matrices) that we are desgin upper side
%we need a sybolic variable
VarSym='syms s ';
for i=1:ResNu
    VarSym=[VarSym Res(i).Name ' '];
end
for i=1:VsNu
    VarSym=[VarSym J{i} ' '];
    VarSym=[VarSym E{i} ' '];
end
for i=1:IsNu
    VarSym=[VarSym Is(i).Name ' '];
end
for i=1:NodeNu
    VarSym=[VarSym V{i} ' '];
end
eval(VarSym);%Now we need to evaluate thIs symbolic variables
%eval(EXPRESSION) evaluates the MATLAB code in the character vector EXPRESSION.
%A,X,Z are cell arrays. We need to evaluate these arrays of string.
stA='A=[';
stX='X=[';
stZ='Z=[';
for i=1:length(cA)     
    for j=1:length(cA) %2 dimension we need another for
        stA=[stA ' ' cA{i,j}]; 
    end
    stA=[stA ';'];          
    stX=[stX  cX{i} ';'];
    stZ=[stZ  cZ{i} ';'];    
end
stA=[stA '];'];  
stX=[stX '];'];
stZ=[stZ '];'];
%Evaluate
eval([stA ' ' stX ' ' stZ])
%now we can do some vector manupulation
%x[V J]=A'*Z
V=simplify(inv(A)*Z);
%Evaluate Matrix X
for i=1:length(V)
    eval([char(X(i)) '=' char(V(i)) ';']);
end
for i=1:ResNu
    
        eval([Res(i).Name '=' num2str(Res(i).Value)  ';']);    
end
for i=1:VsNu
        eval([Vs(i).Name '=' num2str(Vs(i).Value)  ';']);
end
for i=1:IsNu
        eval([Is(i).Name '=' num2str(Is(i).Value)  ';']);
end
for i=1:length(X)
    a(i)=eval(eval(X(i)));
end
for i=1:length(X)
    disp(X(i));
    disp('=');
    disp(a(i));
    fprintf('\n');
end
end