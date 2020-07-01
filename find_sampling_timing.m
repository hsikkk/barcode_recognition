function idx=find_sampling_timing(x,period_min,period_max,delta)
% x: input vector of length n carrying information (high amplitude/low amplitude)
% period_min: minimum period
% period_max: maximum period
% period will be found between [period_min, period_max]
% delta: step size for finding period
% Written by Sae-Young Chung
% Last update: 2014/4/24

n=length(x);
x=reshape(x,1,n);	% make 'x' a row vector
a=abs(conv(x,[1 -1]));  % find absolute values of running difference
t=(0:n);
periods=period_min:delta:period_max;
abs_inner_prod=zeros(1,length(periods));
k=1;
i=sqrt(-1);	% this is already defined in matlab, but just in case
for p=periods
    ref=exp(i*2*pi*t/p);	% reference complex exponential signal
    abs_inner_prod(k)=abs(ref*a');	% absolute value of inner product between ref and a
    k=k+1;
end

[mx,ix]=max(abs_inner_prod);	% find where the maximum is

p=periods(ix);	% find the optimal sampling period
th=exp(i*2*pi*t/p)*a';	% inner product at the optimal sampling period
ang=atan2(imag(th), real(th));	% convert to angle from -pi to pi
idx=p*((0:ceil(n/p))+ang/2/pi+0.5)+1-0.5;	% generate sampling indices for 'x'
    % This can be fractional. 
    % Convert it to integers by rounding such that this can be used as sampling indices for 'x'.
    
start_index = length(idx);
for k=1:length(idx)
    if round(idx(k))>=1
        start_index = k;
        break;
    end
end

end_index = 1;
for k=length(idx):-1:1
    if round(idx(k))<=n
        end_index = k;
        break;
    end
end

if end_index >= start_index
    idx=idx(start_index:end_index);	% to make sure round(idx) is inside the range 1:n
else
    idx = 0;
end
