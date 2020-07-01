n=2000;
x5=zeros(1,n);
d=0;
for k=1:n
    if mod(k,4)==1      % new bit every 5 samples
        d=randi(2)-1;   % random data of 0's and 1's
    end
    x5(k)=d;
end

idx=find_sampling_timing(x5,4,6,0.001); 
    % find sampling timing with sampling period from 4 to 6 in steps of 0.001

plot(1:n,x5,'-',idx,0.5,'o')    % show the signal 'd' and sampling points by circles

x_sampled = x5(round(idx));     % sampled signal
