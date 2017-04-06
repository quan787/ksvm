function hpw=nhpw(amp)
amp=amp(:,1000:end);
peak=max(amp,[],2);
mask=amp>(peak*ones(1,length(amp))/2);
hpw=sum(mask,2);
hpw=hpw/(max(hpw)-min(hpw));
end