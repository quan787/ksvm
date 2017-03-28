clear;
load_head_csv;
%M=csvread('F:\����\flower\waveform_0.csv');
load flower_data.mat
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
%������������
fid=fopen('flower.dat','w');
for i=1:length(Index)
    fprintf(fid,'%d 1:%d 2:%d\n',2,peak(i),hpw(i));
end
fclose(fid);
%ѡȡѵ������
select=rand(length(Index),1)<0.1;
peak_train=peak(select);
hpw_train=hpw(select);
%peak_r=peak_train/(max(peak_train)-min(peak_train));
%hpw_r=hpw_train/(max(hpw_train)-min(hpw_train));
peak_r=peak_train;
hpw_r=hpw_train;
idx=kmeans([peak_r hpw_r],2);
%����ѵ������
fid=fopen('flower_train.dat','w');
for i=1:length(idx)
    fprintf(fid,'%d 1:%d 2:%d\n',idx(i),peak_train(i),hpw_train(i));
end
fclose(fid);
%��ѵ������
figure(1);
plot(peak_train(idx==1),hpw_train(idx==1),'g.',peak_train(idx==2),hpw_train(idx==2),'r.')
figure(2);
Z_train=Z(select);
Y_train=Y(select);
plot(Z_train(idx==1),Y_train(idx==1),'g.',Z_train(idx==2),Y_train(idx==2),'r.')
%ѵ����Ԥ��
system('C:\Users\Z.Y.Li\Documents\MATLAB\ksvm\libsvm-3.22\windows\svm-train.exe flower_train.dat flower.model');
system('C:\Users\Z.Y.Li\Documents\MATLAB\ksvm\libsvm-3.22\windows\svm-predict.exe flower.dat flower.model flower_out.dat');
%��Ԥ������
load flower_out.dat;
figure(3);
plot(peak(flower_out==1),hpw(flower_out==1),'g.',peak(flower_out==2),hpw(flower_out==2),'r.')
figure(4);
plot(Z(flower_out==1),Y(flower_out==1),'g.',Z(flower_out==2),Y(flower_out==2),'r.')
