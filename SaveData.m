function SaveData(x,y,dirpath,filename,type)


for i = 1:length(x)
    dlmwrite(fullfile(dirpath,[type '_' filename{i}]),[x{i} y{i}],'delimiter','\t','newline','pc');
end