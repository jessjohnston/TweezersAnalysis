function  fname = ChangeNames(filename)

fname = filename;
numFiles = length(filename);

clc;
status = 1;
while status == 1
    disp('Change names for Legends');
    for i = 1:numFiles
        disp([int2str(i) '. ' fname{i}]);
    end
    disp([int2str(numFiles+1) '. Done']);
    reply = input('Please select file to change the name:');

    if isnumeric(reply) & reply > 0 & reply < numFiles+2
        if reply == numFiles+1
            status = 0;
        else
            clc;
            disp(['Current name: ',fname{reply}]);
            fname{reply} = input('Enter the new name: ','s');
            clc;
        end
    else
        clc;
        disp('Invalid response... idiot');
    end
end