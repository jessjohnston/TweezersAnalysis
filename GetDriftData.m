function [output]= GetDriftData(showplot)
%first choose a drift file and a fileindex
%the funciton will find out time and piezo position of sin sweep that is
%slower than .1 Hz
%output format is cell {t,x}_freq1, {t,x}_freq2, {t,x}_freq2

%% choose file

dirpath = fileparts(pwd);
[driftname,driftpath] = uigetfile(fullfile(dirpath,'*.txt'),'Select Drift file');
drift = dlmread(fullfile(driftpath,driftname));

% select file index
[filename,filepath] = uigetfile(fullfile(fileparts(driftpath(1:end-1)),'*.txt'),'Select FileIndex');

% get frequencies
fid = fopen(fullfile(filepath,filename));
A = textscan(fid,'%s %f %f');
fclose(fid);


%%
%process file index
filename33=A{1}{1};
freq1=A{1,2};
freq1=freq1(freq1<1);
freq = freq1;
% freq=unique(freq1,'stable');

% freq=A{1,2};
% total_ind=1:length(freq);
% freq_th=.1;
% remain_ind=total_ind(freq<freq_th);
% freq=freq(freq<freq_th);
% amp=A{1,3}/20;

%process drift, find peaks in time
t=drift(:,1);
x=drift(:,2);
dt=diff(t);
[pks,locs] = findpeaks(dt(1:end/2),'minpeakheight',1.03);

%plot
if showplot==1
    f=figure;
    plot(t,x);hold;
end
output=[];
% output=cell(1,length(freq));
start_time=zeros(1,length(freq));
count=0;
for i=1:length(freq)
    banlist=[];
    dup=sum(freq1==freq(i));
    for ii=1:dup
        %     %previous time
        %     if i==1
        %         previous_time=0;
        %     elseif freq(i)~=freq(i-1)
        %         previous_time=0;
        %     end
        %reset corr and corrected location
        corr=zeros(1,length(locs));
        loc1=locs;
        %iterate locations
        for j=1:length(locs)
            if isempty(find(banlist==locs(j)))
                %reset corr
                tmp_corr=10000;
                new_loc=0;
                %iterate nearby location
                for k=0:5
                    start=locs(j)+k;
                    if t(start)+1/freq(i) <t(round(end))
                        inds=find(t>=t(start)& t<=(t(start)+1/freq(i)));
                        %             inds=[inds;inds(end)+1];
                        ts=t(inds);
                        if length(ts)>=3
                            xs=x(inds);
                            amp1=max((max(xs)-min(xs))/2,20);
                            %                         x1s=[xs(1);amp1*sin(2*pi*freq(i)*(ts(2:end)-ts(2)))+xs(1)];
                            x1s=amp1*sin(2*pi*freq(i)*(ts-ts(2)))+xs(1);
                            %                                           plot(ts,x1s,'r');title(num2str(freq(i)));hold on;pause
                            if sum((xs-x1s).^2)/length(ts)<tmp_corr
                                tmp_corr=sum((xs-x1s).^2)/length(ts);
                                new_loc=start;
                            end
                        end
                    end
                end
            end
            corr(j)=tmp_corr;
            loc1(j)=new_loc;
        end
        [~,tmp_ind]=min(corr);
        start_time(i)=loc1(tmp_ind);
        
        banlist=[banlist,locs(tmp_ind)];
        
        inds=find(t>=t(start_time(i))& t<=(t(start_time(i))+1/freq(i)));
        ts=t(inds);
        xs=x(inds);
        count=count+1;
        output(count).t=ts;
        output(count).x=xs;
        output(count).filename=filename33;
        output(count).freq=freq(i);
        output(count).fileindex=i;
        %
        if showplot==1
            amp1=max((max(xs)-min(xs))/2,20);
%             x1s=[xs(1);amp1*sin(2*pi*freq(i)*(ts(2:end)-ts(2)))+xs(1)];
%             ts1=ts(1):.001:ts(end);
            x1s1=amp1*sin(2*pi*freq(i)*(ts-ts(2)))+xs(1);
%             plot(ts,x1s,'.r',ts1,x1s1,'-r');hold on;
            plot(ts,x1s1,'-r');hold on;
            text(ts(1),x1s(1),num2str(i))
        end
    end
end


%reagrange
tmin=size(1,count);
fi=size(1,count);
for i=1:count
    tmin(i)=output(i).t(1);
    fi(i)=output(i).fileindex;
end
% for i=1:count
%     aa=find(freq(fi)==freq1(i))
%     output1=output()
% end
sortoutput=sortrows([fi',tmin',(1:count)']);
rearange=sortoutput(:,3);
output1=output;
for i=1:count
    output1(i)=output(rearange(i));
    output1(i).fileindex=i;
    output1(i).filename=[filename33,'_00',num2str(i)];
end




