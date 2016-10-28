%SPICER

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%This is a sample script to apply SPICER to analyze single particle
%trajectories and fit the data to a two state model. Some sample simulation data
%(sythetic_Data.mat) has been included to allow the user to test
%the algorithum. The different parameters of the simulation can be found
%inside the mat file.

%SPICER needs 4 pieces of information to analyze single particle tracking
%information in E. coli, assuming a classic bacterial cell shape. You will need to
%provide the length and the radius of each cell as well as the trajectories
%in local corrdinates. You will also need to define the R-value you wish to
%use. (Please see origonal manuscript for definition of R-value)

R=500; %The radius of the cell in nm 
L=2500; %The overall length of the bacteria, this is from cell pole to cell pole in nm

%set the initial guesses for the parameter search 

         %Initial D1, Initial D2, Initial p12, Initial p21
Initialsig=[1    , 1,      .01,       .01];   

%This is how large the jumps are at each step during the parameter search same
%as above for the different variables
                %Delta D1,  Delta D2,   Delta p12,     Delta p21
scaledisplacements=[.01,         .01,       .0007,       .0007];

%This is the distance, from the cell membrane, where you should analyze
%trajectories in only one dimension. This is the R-value for a larger
%diffusion coefficent of 1 um^2/s
RValue=200;

numofsteps=500; %This is the number of steps that will be performed for your MCMC scan
dt=.005;%This is the time step used to aquire your data.



%set the following for three dimensional tracking or 2 dimensional
%tracking.

d3=1;%Set to zero for 2 dimensional tracking
repeats=1;%The number of repeats to be performed, set to 1 for time consideration
sigma={};
scanner={};
counter=1;







%You get to pick out your own file
[filename, pathname] = uigetfile({'*.mat'}, 'Select HMM .mat file');
if ( filename == 0 )
    disp('Error! No (or wrong) file selected!')
    return
end


%This will load in all of the trajectories from your structure file.
full_filename = [ pathname, filename ];
a = load(filename);
X=cell(1, 3);
for n=1:length(a.finalTraj);
    X{n}=a.finalTraj{1,n};
end


for ii=1:repeats
xtrjtotal={};
ytrjtotal={};
ztrjtotal={};
%First is 1 dim, second is using all 2d or 3d, third is SPICER.
parfor dd=1:3

    if dd==1
        dim=1;
    else
        if d3==1
            dim=3;
        else
            dim=2;
        end
    end
    
    if dd==2
        Rvalue2=-1000;
    else
        Rvalue2=RValue;
    end
    
    [xtrjtotal{dd}, ytrjtotal{dd}, ztrjtotal{dd}]=modfinaltraj(X, L, R, dim, Rvalue2,dd)
end


%%

parfor winds=1:3
[sigma{counter, winds}, scanner{counter, winds}]=MCMC(numofsteps, scaledisplacements, Initialsig, xtrjtotal{winds}, ytrjtotal{winds}, ztrjtotal{winds},dt,winds);
end

counter=counter+1;
end

save Analyzed_data



