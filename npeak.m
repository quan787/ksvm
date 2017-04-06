function peak=npeak(amp)
peak=max(amp(:,1000:end),[],2);
peak=peak/(max(peak)-min(peak));
end