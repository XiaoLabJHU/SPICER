%%This is the algorithum for the monte carlo phase space search according
%%to the paper anyway.
function [sigma, scanner]=MCMC(numofsteps, scaledisplacements, Initialsig, xtrjtotal, ytrjtotal, ztrjtotal,dt,winds)


[totalloglikely]=forwardbackalg2(xtrjtotal,ytrjtotal,ztrjtotal,Initialsig,dt);
space=100;
Testparmeter1=Initialsig;
scanner=zeros(5,numofsteps);
ccvyt=1;
timer=1;

for ww=1:numofsteps
   
    if ww==timer
        if winds==3
            disp(['SPICER in Progress, %Done:',num2str(ww/numofsteps)])
            timer=timer+space;
        end
    end
    
    scanner(1,ccvyt)=Testparmeter1(1);
    scanner(2,ccvyt)=Testparmeter1(2);
    scanner(3,ccvyt)=Testparmeter1(3);
    scanner(4,ccvyt)=Testparmeter1(4);
    scanner(5,ccvyt)=totalloglikely;
    ccvyt=ccvyt+1;
    
    
   % parfor_progress
    choose=rand;
    if choose<.25
        k=1;
    elseif choose<.5
        k=2;
    elseif choose<.75
        k=3;
    else
        k=4;
    end
       
    Testparmeter=Testparmeter1;
    Testparmeter(k)=Testparmeter1(k)+random('Normal',0,scaledisplacements(k));
    
    %Make sure kinetic rates and other parameters are positive...
    while Testparmeter(k)<0
        Testparmeter(k)=Testparmeter1(k)+random('Normal',0,scaledisplacements(k));
    end
    
    %calculate the log likelyhood with the new parameters
    totalloglikely2=forwardbackalg2(xtrjtotal,ytrjtotal,ztrjtotal,Testparmeter,dt);
    
    choose1=rand;
    if totalloglikely2>=totalloglikely
        Testparmeter1=Testparmeter;
        totalloglikely=totalloglikely2;
    else
        if log(choose1)<=totalloglikely2-totalloglikely
            Testparmeter1=Testparmeter;
            totalloglikely=totalloglikely2;
        end
    end
end
sigma=Testparmeter1;
end

