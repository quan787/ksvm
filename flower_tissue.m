for i=1:length(Index)
    max_image(Y(i)/300+17,Z(i)/300+17)=peak(i);
end
[fx,fy]=gradient(max_image);
max_gra=sqrt(fx.^2+fy.^2);
for i=1:length(Index)
    hpw(i)=max_gra(Y(i)/300+17,Z(i)/300+17);
end