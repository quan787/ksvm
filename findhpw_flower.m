function hpw=findhpw_flower(array)
array=array-array(1);
peak=max(array);

hpw=sum(array>(peak/2));
end