function [G,T] = PNCT_graph(Pre,Post,M0)
% GRAPH : This function builds Reachability/Coverability Graph of a Petri Net system.
%         ***************************************************************************
%                                     ## SYNTAX ##
%
%        GRAPH(Pre,Post,M0): 
%          This function gives a matrix visualization of a Petri Net's
%          Reachability/Coverability Graph being introduced the Pre & Post
%          matrices and the initial marking M0.                     
%          This is a step-by-step mode for didactical purpose.
%
%        G=GRAPH(Pre,Post,M0):
%          This function returns a matrix G of integers that represents
%          Reachability/Coverability Graph being introduced the Pre & Post 
%          matrices and the initial marking M0.
%
%        [G,T]=GRAPH(Pre,Post,M0): 
%          This function returns two integer matrices: 
%             G for Reachability/Coverability Graph;  
%             T for Reachability/Coverability Tree.                         
%
%        See also TREE

Mx=M0';% trasforma la marcatura iniziale da vettore colonna a vettore riga
ni=nargin;
no=nargout;
error(nargchk(3,3,ni));
% Determines which syntax is being used for output arguments
switch no 
case 0  %-------------------------Visualisation step by step-----------------------------------------------
   fprintf('\n***Tree(T) & Graph(G)***\n')
   fprintf('\n     step-by-step\n\n')
   [m,n]=size(Post);
   [c,p]=size(Mx);
   if (size(Post)==size(Pre))&(c==1)&(p==m)
      fprintf('\nPress enter to continue\n')
      pause
      fprintf('\nInitial marking is :\n')
      fprintf('\nM1= \n')
      pause
      disp(M0)
      fprintf('\n Net places m = %d',m)
      fprintf('\n Net transitions n = %d\n',n)
      pause
      fprintf('\nWe can think of a data structure as:\n')
      fprintf('\n M(P1) M(P2) ... M(Pi)**** F **** L **** T1--M1 **** T2--M2 **** T3--M3 **** ... **** Ti--Mi\n') 
      T=[Mx 0 0];
      fprintf('\n Where: M(P1)...M(Pi) are net places with their own markings\n')
      fprintf('        F is the father of a reached marking\n')
      fprintf('        L is the label of a marking; can be\n') 
      fprintf('                                              0 for new markings\n')
      fprintf('                                             -2 for old singular markings\n')
      fprintf('                                             -1 for deadlock markings\n')
      fprintf('                                              positive integers for duplicate markings\n')
      fprintf('        Pay attention! a positive integer tells what''s the singular marking which refers.\n')
      fprintf('        T1--M1 **** T2--M2 **** Ti--Mi are enabled transitions & relative reached markings\n')
      pause
      N=[Mx 0 0];
      TY=[];
      T1=[];
      rN1=1;
      rN=1;
      r=1;
      g=1;
      while r<=g
         if T(r,m+2)==0
            k=1;
            for j=1:n
               if T(r,1:m)>=Pre(:,j)' %Condizione di abilitazione allo scatto di una transizione
                  g=g+1;
                  fprintf('\nFrom : \n')
                  fprintf('\nM%d= \n',r)
                  disp((T(r,1:m))')
                  fprintf('\n ..which Father:  %d \n',T(r,m+1))
                  fprintf('\n ..and Label %d \n',T(r,m+2))
                  pause
                  fprintf('\n ..Firing T%d\n',j)              
                  T(r,m+2*k+1)=j
                  fprintf('\n leads to marking:\n')            
                  T(r,m+2*k+2)=g;
                  M=(T(r,1:m)-Pre(:,j)'+Post(:,j)')'
                  M=M';
                  a=r;
                  pause
                  fprintf('\n Coverability control:\n')
                  pause
                  while a~=0  % Controllo Copertura
                     if M >=T(a,1:m),
                        for i=1:m;
                           if M(i)>T(a,i)
                              M(i)=inf;
                              fprintf('\nthis marking is covering the previous one!\n')
                              M'
                              pause
                           end
                        end
                        a=1;
                     end
                     a=T(a,m+1);
                  end
                  fprintf('\nNow I add relative row in the Tree\n')
                  T(g,1:m)=M
                  fprintf('\nand I update fathers column of this row! \n')
                  T(g,m+1)=r
                  pause
                  N(rN,m+1)=rN1;
                  N(rN,m+2)=rN;
                  fprintf('\n Duplicate Control:\n')
                  for w=1:rN    
                     if N(w,1:m)==T(g,1:m)
                        TY(g,1)=w;
                        T(g,m+2)=N(w,m+1);
                        fprintf('\n This Marking is duplicate of M%d\n', N(w,m+1))
                        break
                     end
                  end
                  pause
                  k=k+1;
                  if T(g,m+2)==0 
                     M1=[M 0 0];
                     N=[N;M1];
                     rN=rN+1;
                     rN1=g;
                     N(rN,m+1)=rN1;
                     N(rN,m+2)=rN;
                  end               
               end
            end
            if k==1,
               fprintf('\nUpdating Label for the deadlock marking\n')
               fprintf('\nM%d=\n',r)
               disp((T(r,1:m))')
               T(r,m+2)=-1
               TY(r,1)=-1;
               pause
            else
               fprintf('\nUpdating Label for the singular marking\n')
               fprintf('\nM%d=\n',r)
               disp((T(r,1:m))')
               T(r,m+2)=-2
               TY(r,1)=-2;
               pause
            end
         end
         r=r+1;
      end
      fprintf('\n *****THE REACHABILITY/COVERABILITY TREE IS FINISHED***** \n')
      pause
      fprintf('\n *****STARTING TO BUILD REACHABILITY/COVERABILITY GRAPH***** \n')
      fprintf('\n We have to join duplicate markings with their relatives, updating the reached markings column.\n')
      fprintf('\n This can be obtained erasing duplicate nodes and using an auxiliary array: "AUX"\n')
      fprintf('\n AUX entries show how to update reached markings column of Tree\n')
      fprintf('\n Let see :\n')
      pause
      aux=1:g;
      aux1=1:g;
      T1=[T1,aux1'];
      v=1;     
      for r=1:g 
         if TY(r,1)<0 
            aux(r)=v;   
            v=v+1;
         else aux(r)=TY(r,1);
            aux(r)=TY(r,1);
         end    
      end
      disp('AUX')
      disp(aux')
      pause
      [g,d]=size(T);
      fprintf('\n Consider T\n')
      disp(T)
      fprintf('\n Consider all column of reached markings:\n')
      disp(T(:,m+4:2:d))
      fprintf('\n When the algorithm find a relative marking (that refers to a duplicate one)...\n')
      fprintf('\n..search row index and replaces the element with the aux''s one with the same index\n')
      fprintf('\n Also update the index of reached singular markings.\n')
      pause
      fprintf('\n Updating...\n')
      pause
      for r=1:g       
         for b=m+4:2:d
            q=T(r,b);
            if q~=0
               T(r,b)=aux(q);
            end   
         end
      end
      fprintf('\nUpdated!!!!\n')
      disp(T(:,m+4:2:d))      
      pause
      s=0;
      G=[];
      fprintf('\nErasing duplicate nodes...\n')
      pause
      for r=1:g
         if T(r,m+2)<0
            s=s+1;
            G(s,:)=T(r,:);        
         end
      end
      [i1,i2]=size(G); 
      for x=i1:-1:1
         for y=1:i1
            if G(y,end)==G(x,m+1)
               G(x,m+1)=y;
            end
         end
      end
      G(:,end)=[];
      fprintf('\n...we obtain G \n')
   elseif size(Post)~=size(Pre)
      fprintf('Error: Different matrice''s dimension between Pre and Post!\n')
      fprintf('Insert Pre and Post again\n')
   else   
      fprintf('\nERROR! Initial marking dimensions wrong!!\n')
   end 
   
otherwise %---------------------------Save the Graph in G and the Tree in T------------------------------
   %Both the Tree and the Graph are shown
   %fprintf('\n***Algorithm for Graph(G) and Tree(T)***\n\n')
   [m,n]=size(Post);
   [c,p]=size(Mx);
   if (size(Post)==size(Pre))&(c==1)&(p==m)
      T=[Mx 0 0 0];
      N=[Mx 0 0 ];
      rN=1;
      rN1=1;
      r=1;
      g=1;
      while r<=g
         if T(r,m+2)==0 
            k=1;
            for j=1:n 
               if T(r,1:m)>=Pre(:,j)' 
                  g=g+1;
                  T(r,m+1+2*k+1)=j; 
                  T(r,m+1+2*k+2)=g; 
                  M=T(r,1:m)-Pre(:,j)'+Post(:,j)';
                  a=r;
                  while a~=0  
                     if M >=T(a,1:m), 
                        for i=1:m;
                           if M(i)>T(a,i)
                              M(i)=inf;
                           end
                        end
                        a=1;
                     end
                     a=T(a,m+1);
                  end
                  T(g,1:m)=M; 
                  T(g,m+1)=r;  
                  N(rN,m+1)=rN1;
                  N(rN,m+2)=rN;
                  for w=1:rN    
                     if N(w,1:m)==T(g,1:m)
                        T(g,m+2)=w;
                        T(g,m+3)=N(w,m+1);
                        break
                     end
                  end
                  k=k+1;
                  if T(g,m+2)==0 
                     M1=[M 0 0];
                     N=[N;M1];
                     rN=rN+1;
                     rN1=g;
                     N(rN,m+1)=rN1;
                     N(rN,m+2)=rN;
                  end
               end
            end
            if k==1,
               T(r,m+2)=-1;
               T(r,m+3)=-1;
            else
               T(r,m+2)=-2;
               T(r,m+3)=-2;
            end
         end
         r=r+1;
      end
      T1=T;
      aux=1:g;
      %***************indexing T******
      aux1=1:g;
      T1=[T1,aux1'];
      %*******************************
      v=1;     
      for r=1:g 
         if T1(r,m+2)<0 
            aux(r)=v;   
            v=v+1;
         else aux(r)=T1(r,m+2);
            aux(r)=T1(r,m+2);
         end    
      end 
      [g,d]=size(T1); 
      for r=1:g       
         for b=m+5:2:d
            q=T1(r,b);
            if q~=0
               T1(r,b)=aux(q);
            end
         end
      end
      s=0;
      G=[];
      for r=1:g
         if T1(r,m+2)<0
            s=s+1;
            G(s,:)=T1(r,:);        
         end
      end
      %***************Fathers correction!!!************
      [i1,i2]=size(G); 
      for x=i1:-1:1
         for y=1:i1
            if G(y,end)==G(x,m+1)
               G(x,m+1)=y;
            end
         end
      end
      G(:,end)=[];
      %******************END***************************
      [i1,i2]=size(G); 
      K=zeros(1,i2);
      G=[G;K];
      T=[T;K];
      T(:,m+2)=[];
      G(:,m+2)=[];
      [i3,i2]=size(G);
      [i4,cT]=size(T);
      G(i3,1)=m;
      G(i3,2)=n;
      G(i3,3)=1;
      T(i4,1)=m;
      T(i4,2)=n;
      T(i4,3)=0;
   elseif size(Post)~=size(Pre)
      fprintf('Error: Different matrice''s dimension between Pre and Post!\n')
      fprintf('Insert Pre and Post again\n')
   else
      fprintf('\nERROR! Initial marking dimensions wrong!!\n')
   end    
end



