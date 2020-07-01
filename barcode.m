% barcode decoder
% Written by Sae-Young Chung
% Last update: 2016/4/2

dx=300;
dy=100;

% from 0 to 9 (UPC barcode)
bar_code_table=[
0 0 0 1 1 0 1   % 0
0 0 1 1 0 0 1   % 1
0 0 1 0 0 1 1   % 2
0 1 1 1 1 0 1   % 3
0 1 0 0 0 1 1   % 4
0 1 1 0 0 0 1   % 5
0 1 0 1 1 1 1   % 6
0 1 1 1 0 1 1   % 7
0 1 1 0 1 1 1   % 8
0 0 0 1 0 1 1   % 9
];

while 1
	f=double(snapshot(cam))/255;
    g=f(:,:,2);    % copy the green component
    r = 0;
    c=[1 0 0];
    c2=[1 1 0];
    for i=1:3   % draw a bounding box and a scan line
    	f(238-dy/2:243+dy/2,[(158:160)-dx/2 (161:163)+dx/2]+160,i)=c(i);
        f([(238:240)-dy/2 (241:243)+dy/2],(158-dx/2:163+dx/2)+160,i)=c(i);
        f(240:242,(161-dx/2:160+dx/2)+160,i)=c2(i);
    end
    
    x=g(241,(161-dx/2:160+dx/2)+160);
    xavg=sum(x)/length(x);
    idx=find_sampling_timing(x,2,5,0.001);
    d=(x(round(idx))<xavg)*1.0;
    start = 0;
    for k=1:length(d)
        if (d(k)==1)
            start = k + 3;
            break;
        end
    end
    
    decoded1 = '******';    % 1x6 array of '*'
   
    if (start)
        for k=0:5
            if start + k * 7 + 6 <= length(d)
                for j=1:10
                    if sum(abs(d(start+k*7:start+k*7+6)-bar_code_table(j,:)))==0
                        decoded1(k+1)=47+j;  % 48 in ASCII code is '0', 49 is '1', and so on
                        break;
                    end
                    if sum(abs(d(start+k*7:start+k*7+6)-bar_code_table(j,7:-1:1)))==0
                        decoded1(k+1)=47+j;  % 48 in ASCII code is '0', 49 is '1', and so on
                        break;
                    end
                    if sum(abs(d(start+k*7:start+k*7+6)-(1-bar_code_table(j,:))))==0
                        decoded1(k+1)=47+j;  % 48 in ASCII code is '0', 49 is '1', and so on
                        break;
                    end
                    if sum(abs(d(start+k*7:start+k*7+6)-(1-bar_code_table(j,7:-1:1))))==0
                        decoded1(k+1)=47+j;  % 48 in ASCII code is '0', 49 is '1', and so on
                        break;
                    end
                end
            else
                break;
            end
        end
    end
    
    decoded2 = '******';
    start = start + 47;
    
    if (start)
        for k=0:5
            if start + k * 7 + 6 <= length(d)
                for j=1:10
                    if sum(abs(d(start+k*7:start+k*7+6)-bar_code_table(j,:)))==0
                        decoded2(k+1)=47+j;  % 48 in ASCII code is '0', 49 is '1', and so on
                        break;
                    end
                    if sum(abs(d(start+k*7:start+k*7+6)-bar_code_table(j,7:-1:1)))==0
                        decoded2(k+1)=47+j;  % 48 in ASCII code is '0', 49 is '1', and so on
                        break;
                    end
                    if sum(abs(d(start+k*7:start+k*7+6)-(1-bar_code_table(j,:))))==0
                        decoded2(k+1)=47+j;  % 48 in ASCII code is '0', 49 is '1', and so on
                        break;
                    end
                    if sum(abs(d(start+k*7:start+k*7+6)-(1-bar_code_table(j,7:-1:1))))==0
                        decoded2(k+1)=47+j;  % 48 in ASCII code is '0', 49 is '1', and so on
                        break;
                    end
                end
            else
                break;
            end
        end
    end
    
	image(f)
    decoded = strcat(decoded1, decoded2);
	ht=text(320,100,sprintf('decoded = %s %s', decoded));
   	set(ht,'LineWidth',[3])
	set(ht,'FontSize',[30])
	set(ht,'Color',[0 1 0])
	set(ht,'HorizontalAlignment','center')
	drawnow()
    
    flag = 1;
    for i = 1:12
        if decoded(i) == '*'
            flag = 0;
        end
    end
    
    if flag == 1
        system(strcat('"C:\Program Files\Internet Explorer\iexplore.exe" https://www.google.com/search?q=9', decoded));
    end
    
end
