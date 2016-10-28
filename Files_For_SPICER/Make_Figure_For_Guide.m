%%This will be a script to generate a figure to interpret the results from
%%the analysis in the user guide.

%%
%This will plot the percent error for the best determined parameters for the three different
%methods 
repeat=1;%If you performed multiple repeats, choose which one you want to look at.
data=[];
for iiu=1:3
    [III, II]=max(scanner{1,iiu}(5,:));
    if scanner{1,iiu}(1,II)>scanner{1,iiu}(2,II)
        data(1,iiu)=scanner{repeat,iiu}(1,II);
        data(2,iiu)=scanner{repeat,iiu}(2,II);
        data(3,iiu)=scanner{repeat,iiu}(3,II);
        data(4,iiu)=scanner{repeat,iiu}(4,II);
    else
        data(1,iiu)=scanner{repeat,iiu}(2,II);
        data(2,iiu)=scanner{repeat,iiu}(1,II);
        data(3,iiu)=scanner{repeat,iiu}(4,II);
        data(4,iiu)=scanner{repeat,iiu}(3,II);
    end
end

subplot(1,2,1)
yy=[abs(flip(data(1,:))-1) ;abs(flip(data(2,:))-.7)/.7]
bar(yy)
set(gca,'XTickLabel',{'D_{1}', 'D_{2}'})

    legend('SPICER', '3d', '1d','Orientation','horizontal')
    legend boxoff

ylabel('% Error','Fontsize',10)
axis([0 3 -Inf Inf])

subplot(1,2,2)
yy=[abs(flip(data(3,:))-.0244)/.0244 ;abs(flip(data(4,:))-.0244)/.0244]
bar(yy)
set(gca,'XTickLabel',{'P_{12}', 'P_{21}'})
ylabel('% Error','Fontsize',10)
axis([0 3 -Inf Inf])

