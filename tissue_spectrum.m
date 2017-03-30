cancer_spec=[];
healthy_spec=[];
load tissue_data.mat
AMP_s=zeros(length(Index),7000);
AMP_lr=zeros(length(Index),12000);
for i=1:length(Index)
    [~,mi]=max(AMP(i,1:4000));
    AMP_lr(i,:)=AMP(i,mi-1999:mi+10000)-mean(AMP(i,mi-1999:mi-999));
end
for i=1:length(Index)
    %disp(i);
    [~,mi]=max(AMP_lr(i,3000:end));
    if mi>3000
        mi=3000;
        disp(tissue_out(i));
    end
    AMP_s(i,:)=AMP_lr(i,mi-999+3000:mi+6000+3000);
end
for i=1:length(Index)
    if tissue_out(i)==1
        f=abs(fft(AMP_s(i,:)));
        cancer_spec=[cancer_spec;f(1:1000)];
    end
    if tissue_out(i)==2
        f=abs(fft(AMP_s(i,:)));
        healthy_spec=[healthy_spec;f(1:1000)];
    end
end
figure(1);
plot(log(sum(cancer_spec',2)));
figure(2);
plot(log(sum(healthy_spec',2)));