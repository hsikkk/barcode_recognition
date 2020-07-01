fc=2000;        % carrier freq.
fb=100;         % baud rate
fs=44100;       % sampling rate

%rec=audiorecorder(fs,16,1,1);
%recordblocking(rec,2); 
%x=getaudiodata(rec)';

[x,fs]=audioread('lab5_qpsk_received_line.wav');
x = x';

[start, theta, freq_offset]=find_timing_phase_freq_offset(x,fb,fc,fs); 
tt=(0:length(x)-1)/fs;
y1=x.*cos(2*pi*(fc+freq_offset)*tt+theta);  % multiplication by cosine and sine
y2=x.*sin(2*pi*(fc+freq_offset)*tt+theta);
m=fs/fb;    % this needs to be an integer
r=rcosdesign(0.3,50,m); % root raised cosine with roll-off factor 0.3 and span from -25 to 25
y1f=conv(y1,r);  % matched filtering (since r is symmetric, it does not need to be flipped)
y2f=conv(y2,r);
t=(0:length(y1f)-1)/fs;   % change 't' to match the length of y1f and y2f
y1s=y1f(start:m:end);   % sampling
y2s=y2f(start:m:end);
length1 = max(length(y1s),length(y2s));
n=0;
a_bit=zeros(1,30);
b_bit=zeros(1,30);
location=0;
 
for i= 1:length1
    if(y1s(i)>0.1&&y2s(i)>0.1)       
        n=n+1;                   
        if(n==5)                          
           a_bit(1:5)=1;
           b_bit(1:5)=1; 
           location=i;               
           break
        end
        
    else
        n=0;
    end
end   
 
if(location)                              
    for i=1:25
        if(y1s(location+i)>0.01)
            a_bit(i+5)=1;
        end    
        if(y1s(location+i)<-0.01)
            a_bit(i+5)=-1;
        end
        if(y2s(location+i)>0.01)
            b_bit(i+5)=1;
        end
        if(y2s(location+i)<-0.01)
            b_bit(i+5)=-1;
        end      
    end        
end   

 
