function [xnew, ynew, znew]=modfinaltraj(X, L, R, dim, Rvalue,dd)


ap=1;%This is a counter

%Create the new modified trajectory.

xnew=[];
ynew=[];
znew=[];

%Take into consideration the R-value;
thresholddistance=R-Rvalue;
temp=1;
clc
%Set the length for the cell
L=L-2*R;
while ap<=length(X)
    
    
    if dd==3
        if ap>temp
            temp=ap+3000;
            disp (['Making Modified Trajectories, %Done:',num2str(ap/length(X))])
          
        end
    end
    
    %Load all of the possitions of the molecules
    for k=1:size(X{1,ap},1)
        x(k)=X{1,ap}(k,1);
        y(k)=X{1,ap}(k,2);
        z(k)=X{1,ap}(k,3);
    end
    fe=2;
    
    
    

    while fe<=(size(X{1,ap},1))
        %If the displacement is in the cylindrical portion of the cell
        %automatically use the x displacement.
        
        if x(fe-1)>=0 && x(fe-1)<=L;
            xnew(ap,fe-1)=(x(fe)-x(fe-1));
            %If you only have two dimensions availible use those first
            if dim==2 && abs(y(fe-1))<thresholddistance
                ynew(ap,fe-1)=(y(fe)-y(fe-1));
                znew(ap,fe-1)=NaN;
            elseif dim==2
                ynew(ap,fe-1)=NaN;
                znew(ap,fe-1)=NaN;
            end
            
            
            %if you have three dimensions availible to you
            if dim==3 && (y(fe-1)^2+z(fe-1)^2)^.5<thresholddistance
                ynew(ap,fe-1)=(y(fe)-y(fe-1));
                znew(ap,fe-1)=(z(fe)-z(fe-1));
            elseif dim==3
                znew(ap,fe-1)=NaN;
                ynew(ap,fe-1)=NaN;
            end
            
            %if you just want to use one dimension
            if dim==1
                znew(ap,fe-1)=NaN;
                ynew(ap,fe-1)=NaN;
            end
            
            fe=fe+1;
            
        else
            
            %%Now for the heads of the cells
            if x(fe-1)>=L
                xmeasure=x(fe-1)-L;
            else
                xmeasure=x(fe-1);
            end
            
            if dim==1
                xnew(ap,fe-1)=(x(fe)-x(fe-1));
                znew(ap,fe-1)=NaN;
                ynew(ap,fe-1)=NaN;
            end
            
            if dim==2 && (xmeasure^2+y(fe-1)^2)^.5<=thresholddistance
                xnew(ap,fe-1)=(x(fe)-x(fe-1));
                ynew(ap,fe-1)=(y(fe)-y(fe-1));
                znew(ap,fe-1)=NaN;                
            elseif dim==2                
                xnew(ap,fe-1)=(x(fe)-x(fe-1));
                ynew(ap,fe-1)=NaN;
                znew(ap,fe-1)=NaN;
            end      
            
            %This will be for three dimensions
            if dim==3 && (xmeasure^2+y(fe-1)^2+z(fe-1)^2)^.5<=thresholddistance
                xnew(ap,fe-1)=(x(fe)-x(fe-1));
                ynew(ap,fe-1)=(y(fe)-y(fe-1));
                znew(ap,fe-1)=(z(fe)-z(fe-1));
            elseif dim==3
                xnew(ap,fe-1)=(x(fe)-x(fe-1));
                ynew(ap,fe-1)=NaN;
                znew(ap,fe-1)=NaN;
            end
            fe=fe+1;
        end
        
        
        
    end
    

ap=ap+1;
end











