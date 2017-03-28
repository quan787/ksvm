clear;
load tissue_data.mat
%
AMP_r=zeros(length(Index),8000);
for i=1:length(Index)
    [~,mi]=max(AMP(i,1:4000));
    AMP_r(i,:)=AMP(i,mi-1999:mi+6000)-mean(AMP(i,mi-1999:mi-999));
end