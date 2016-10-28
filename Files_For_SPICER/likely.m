function [loglikelyhood]=likely(dx, dy, dz, Di, dt)
%Only use the displacements that are well defined
loglikelyhood=zeros(size(dx));
for i=1:size(dx,1)
    jj=1;
while jj<=size(dx,2)
dim=0;
if jj<size(dx,2)
if ((dx(i,jj))==0 && (dx(i,jj+1))==0) || isnan(dx(i,jj))==1
    dx1=0;
    go=0;
    jj=size(dx,2)+20;
else
    dim=1;
    dx1=dx(i,jj)/10^3;
    go=1;
    
    if isnan(dy(i,jj))==1 || ((dy(i,jj))==0 && (dy(i,jj+1))==0)
    dy1=0;
    else
    dim=dim+1;
    dy1=dy(i,jj)/10^3;
    end
    if isnan(dz(i,jj))==1 || ((dz(i,jj))==0 && (dz(i,jj+1))==0)
    %dz(i,jj)=0;
    dz1=0;
    else
    dim=dim+1;
    dz1=dz(i,jj)/10^3;
    end
end


else
if (dx(i,jj))==0 || isnan(dx(i,jj))==1
    dx1=0;
    go=0;
    jj=size(dx,2)+20;
else
    dim=1;
    dx1=dx(i,jj)/10^3;
    go=1;
    
    if isnan(dy(i,jj))==1 || ((dy(i,jj))==0)
    dy1=0;
    else
    dim=dim+1;
    dy1=dy(i,jj)/10^3;
    end
    if isnan(dz(i,jj))==1 || ((dz(i,jj))==0)
    %dz(i,jj)=0;
    dz1=0;
    else
    dim=dim+1;
    dz1=dz(i,jj)/10^3;
    end
end


end


if go==1
like=exp(-(dx1^2+dy1^2+dz1^2)/(4*Di*dt))/(4*pi*Di*dt)^(dim/2);
loglikelyhood(i,jj)=log(like);
end
jj=jj+1;

end
end
end