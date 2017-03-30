clear;
%load_head_csv;
%M=csvread('F:\毕设\flower\waveform_0.csv');
load flower_data.mat
peak=zeros(length(Index),1);
hpw=zeros(length(Index),1);
for i=1:length(Index)
    disp(i);
     %amp_i=AMP(i,:);
     amp_i=AMP(i,1:3:end-2)+AMP(i,2:3:end-1)+AMP(i,3:3:end);
     %amp_i=smooth(AMP(i,:),3);
     peak_i=findpeak_flower(amp_i);
     hpw_i=findhpw_flower(amp_i);
     peak(i)=peak_i;
     hpw(i)=hpw_i;
end
%求梯度
flower_gradient;
%----
peak=peak/(max(peak)-min(peak));
hpw=hpw/(max(hpw)-min(hpw));
%保存所有数据
fid=fopen('flower.dat','w');
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
fid=fopen('flower_train.dat','w');
for i=1:length(idx)
    fprintf(fid,'%d 1:%d 2:%d\n',idx(i),peak_train(i),hpw_train(i));
end
fclose(fid);
%画训练数据
figure(1);
plot(peak_train(idx==1),hpw_train(idx==1),'g.',peak_train(idx==2),hpw_train(idx==2),'r.')
xlabel('约化峰值高度')
ylabel('约化梯度')
title('训练样本聚类结果');
figure(2);
Z_train=Z(select);
Y_train=Y(select);
plot(Z_train(idx==1)/200+26,Y_train(idx==1)/200+26,'g.',Z_train(idx==2)/200+26,Y_train(idx==2)/200+26,'r.')
xlabel('像素')
ylabel('像素')
axis equal tight;
title('训练样本空间分布');
%训练和预测
system('C:\Users\Z.Y.Li\Documents\MATLAB\ksvm\libsvm-3.22\windows\svm-train.exe flower_train.dat flower.model');
system('C:\Users\Z.Y.Li\Documents\MATLAB\ksvm\libsvm-3.22\windows\svm-predict.exe flower.dat flower.model flower_out.dat');
%画预测数据
load flower_out.dat;
figure(3);
plot(peak(flower_out==1),hpw(flower_out==1),'r.',peak(flower_out==2),hpw(flower_out==2),'g.')
xlabel('约化峰值高度')
ylabel('约化梯度')
title('全部样本SVM分类结果');
figure(4);
for i=1:length(Index)
    max_image(Y(i)/200+26,Z(i)/200+26)=peak(i);
end
image(max_image*100);
hold on;
plot(Z(flower_out==1)/200+26,Y(flower_out==1)/200+26,'r.',Z(flower_out==2)/200+26,Y(flower_out==2)/200+26,'g.')
axis equal tight;
xlabel('像素')
ylabel('像素')
title('全部样本SVM分类结果');
