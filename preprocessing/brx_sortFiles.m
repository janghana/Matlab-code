function ordFileNames = brx_sortFiles(fileNames,idx)
% ordFileNames = sortFiles(fileNames,idx)

fileNo = [];
for f = 1:length(fileNames), 
    fileNo = [fileNo,str2double(fileNames{f}(idx))];
end

[~,fileOrd] = sort(fileNo);

for f = 1:length(fileNames)
    ordFileNames{f} = fileNames{fileOrd(f)};
end

end