clear;
load tissue_data.mat
%
AMP=AMP_r;
peak=zeros(length(Index),1);
hpw=zeros(length(Index),1);
for i=1:length(Index)
    disp(i);
     %amp_i=AMP(i,:);
     amp_i=AMP(i,1:3:end-2)+AMP(i,2:3:end-1)+AMP(i,3:3:end);
     %amp_i=smooth(AMP(i,:),3);
     peak_i=findpeak(amp_i);
     hpw_i=findhpw(amp_i);
     peak(i)=peak_i;
     hpw(i)=hpw_i;
end
peak=peak/(max(peak)-min(peak));
hpw=hpw/(max(hpw)-min(hpw))/2;
%保存所有数据
fid=fopen('tissue.dat','w');
for i=1:length(Index)
    fprintf(fid,'%d 1:%d 2:%d\n',2,peak(i),hpw(i));
end
fclose(fid);
%选取训练数据
select=rand(length(Index),1)<0.2;
peak_train=peak(select);
hpw_train=hpw(select);
%peak_r=peak_train/(max(peak_train)-min(peak_train));
%hpw_r=hpw_train/(max(hpw_train)-min(hpw_train));
peak_r=peak_train;
hpw_r=hpw_train;
idx=kmeans([peak_r hpw_r],2);
%保存训练数据
fid=fopen('tissue_train.dat','w');
for i=1:length(idx)
    fprintf(fid,'%d 1:%d 2:%d\n',idx(i),peak_train(i),hpw_train(i));
end
fclose(fid);
%画训练数据
figure(1);
plot(peak_train(idx==1),hpw_train(idx==1),'g.',peak_train(idx==2),hpw_train(idx==2),'r.')
figure(2);
Z_train=Z(select);
Y_train=Y(select);
plot(Z_train(idx==1),Y_train(idx==1),'g.',Z_train(idx==2),Y_train(idx==2),'r.')
%训练和预测
system('C:\Users\Z.Y.Li\Documents\MATLAB\ksvm\libsvm-3.22\windows\svm-train.exe tissue_train.dat tissue.model');
system('C:\Users\Z.Y.Li\Documents\MATLAB\ksvm\libsvm-3.22\windows\svm-predict.exe tissue.dat tissue.model tissue_out.dat');
%画预测数据
load tissue_out.dat;
figure(3);
plot(peak(tissue_out==1),hpw(tissue_out==1),'g.',peak(tissue_out==2),hpw(tissue_out==2),'r.')
figure(4);
for i=1:length(Index)
    max_image(Y(i)/300+17,Z(i)/300+17)=peak(i);
end
image(max_image*100);
hold on;
plot(Z(tissue_out==1)/300+17,Y(tissue_out==1)/300+17,'g.',Z(tissue_out==2)/300+17,Y(tissue_out==2)/300+17,'r.')


