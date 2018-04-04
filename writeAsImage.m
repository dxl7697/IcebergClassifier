function writeAsImage(id,image, isIceberg)
%WRITEASIMAGE Summary of this function goes here

    destFolder = strcat(pwd,'\images\ship');
    if(isIceberg)
        destFolder = strcat(pwd,'\images\iceberg');
    end

    if ~exist(destFolder, 'dir')
      mkdir(destFolder);
    end
    %force binary image
    image=image-min(image(:)); 
    image=image/max(image(:)); 
    %png, jpg will throw error
    outputBaseName = [id, '.png'];
    fullDestinationFileName = fullfile(destFolder, outputBaseName);

    imwrite(image, fullDestinationFileName, 'BitDepth', 16);

end
