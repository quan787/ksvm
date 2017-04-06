clear;
load tissue_data.mat
AMP=AMP_r;

npar=3;
sample_ratio=0.4;
ncluster=3;

AMP=AMP(:,1:3:end-2)+AMP(:,2:3:end-1)+AMP(:,3:3:end);
param=zeros(length(Index),npar);
param(:,1)=npeak(AMP);
param(:,2)=nhpw(AMP);
param(:,3)=ngrad(Index,Y,Z,param(:,1));

%保存所有数据
fid=fopen('tissue.dat','w');
for i=1:length(Index)
    fprintf(fid,'%d',3);
    for j=1:npar
        fprintf(fid,' %d:%d',j,param(i,j));
    end
    fprintf(fid,'\n');
end
fclose(fid);
%选取训练数据
select=randsample(length(Index),ceil(length(Index)*sample_ratio));
param_train=param(select,:);
idx=kmeans(param_train,ncluster);
%保存训练数据
fid=fopen('tissue_train.dat','w');
for i=1:length(select)
    fprintf(fid,'%d',idx(i));
    for j=1:npar
        fprintf(fid,' %d:%d',j,param(i,j));
    end
    fprintf(fid,'\n');
end
fclose(fid);
%训练和预测
system('C:\Users\Z.Y.Li\Documents\MATLAB\ksvm\libsvm-3.22\windows\svm-train.exe -t 0  tissue_train.dat tissue.model');
system('C:\Users\Z.Y.Li\Documents\MATLAB\ksvm\libsvm-3.22\windows\svm-predict.exe tissue.dat tissue.model tissue_out.dat');
%画训练数据
color=['g.';'b.';'r.'];
figure(1);
cla;
if npar==3
    for i=1:ncluster
        param_draw=param_train(idx==i,:);
        plot3(param_draw(:,1),param_draw(:,2),param_draw(:,3),color(i,:));
        hold on;
    end
end
xlabel('peak')
ylabel('hpw')
zlabel('grad')
title('训练样本聚类结果');
hold off;
figure(2);
cla;
for i=1:length(Index)
    max_image(Y(i)/300+17,Z(i)/300+17)=param(i,1);
end
image(max_image*100);
hold on;
Z_train=Z(select);
Y_train=Y(select);
for i=1:ncluster
    plot(Z_train(idx==i)/300+17,Y_train(idx==i)/300+17,color(i,:));
    hold on;
end
hold off;
%画预测数据
load tissue_out.dat;
figure(3);
cla;
if npar==3
    for i=1:ncluster
        param_draw=param(tissue_out==i,:);
        plot3(param_draw(:,1),param_draw(:,2),param_draw(:,3),color(i,:));
        hold on;
    end
end
hold off;
figure(4);
cla;
for i=1:length(Index)
    max_image(Y(i)/300+17,Z(i)/300+17)=param(i,1);
end
image(max_image*100);
hold on;
for i=1:ncluster
    plot(Z(tissue_out==i)/300+17,Y(tissue_out==i)/300+17,color(i,:));
    hold on;
end
hold off;