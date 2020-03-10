function  index = FindNextFileIndex(dirpath,filename,ext)

index = 1; 
status = 1;
while status == 1
    if ~exist(fullfile(dirpath,[filename num2str(index) '.' ext]),'file');
        status = 0;
    else
        index = index + 1;
    end
end
   