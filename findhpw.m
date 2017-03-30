function hpw=findhpw(array)
%array=array-array(1);
array=array(1000:end);
peak=max(array);
%flag=0;
% for i=1:length(array)
%     if flag==0
%         if array(i)>(peak/2)
%             flag=1;
%             head=i;
%         end
%     end
%     if flag==1 
%         if array(i)<(peak/2) || i==length(array)
%             hpw=i-head;
%             break;
%         end
%     end
% end

hpw=sum(array>(peak/2));
%[~,i]=max(array);
%hpw=i;
%hpw=max(array)-min(array);
end