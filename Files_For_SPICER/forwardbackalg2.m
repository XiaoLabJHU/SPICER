function [forwardvar]=forwardbackalg2(xtrj, ytrj, ztrj, sig, dt)
%This will be the forward backward with the varying dimensions.
pii1=sig(4)/(sig(3)+sig(4));
pii2=1-pii1;
%Compute the log likely hood for each column
One11=likely(xtrj, ytrj, ztrj,sig(1), dt);
Two22=likely(xtrj, ytrj, ztrj,sig(2), dt);
alphai1=log(pii1)+One11(:,1);
alphai2=log(pii2)+Two22(:,1);
alphai1p=alphai1;
alphai2p=alphai2;

for j=2:size(xtrj,2)
    I = find(One11(:,j)~=0);
    alphai1p(I)=logsum(alphai1(I)+log(1-sig(3)), alphai2(I)+log(sig(4)))+One11(I,j);
    alphai2p(I)=logsum(alphai1(I)+log(sig(3)), alphai2(I)+log(1-sig(4)))+Two22(I,j);
    alphai1=alphai1p;
    alphai2=alphai2p;
end
forwardvar=sum(logsum(alphai1, alphai2));
end

