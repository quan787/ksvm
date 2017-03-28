load flower_out.dat;
figure(2);
plot(Z(flower_out==1),Y(flower_out==1),'g.',Z(flower_out==2),Y(flower_out==2),'r.')
