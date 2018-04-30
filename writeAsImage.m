function writeAsImage(id,image, isIceberg,channel)
%WRITEASIMAGE Summary of this function goes here

    if(channel == 1)
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
    elseif(channel==2)
        destFolder = strcat(pwd,'\images\twoDim\ship');
        if(isIceberg)
            destFolder = strcat(pwd,'\images\twoDim\iceberg');
        end

        if ~exist(destFolder, 'dir')
          mkdir(destFolder);
        end

        outputBaseName = [id, '.png'];
        fullDestinationFileName = fullfile(destFolder, outputBaseName);

        imwrite(image, fullDestinationFileName);
    
    elseif(channel==3)
        destFolder = strcat(pwd,'\images\threeDim\ship');
        if(isIceberg)
            destFolder = strcat(pwd,'\images\threeDim\iceberg');
        end

        if ~exist(destFolder, 'dir')
          mkdir(destFolder);
        end

        outputBaseName = [id, '.png'];
        fullDestinationFileName = fullfile(destFolder, outputBaseName);

        imwrite(image, fullDestinationFileName);
    
    elseif(channel==4)
        destFolder = strcat(pwd,'\images\rotateTwoDim\ship');
        if(isIceberg)
            destFolder = strcat(pwd,'\images\rotateTwoDim\iceberg');
        end

        if ~exist(destFolder, 'dir')
          mkdir(destFolder);
        end

        outputBaseName = [id, '.png'];
        fullDestinationFileName = fullfile(destFolder, outputBaseName);

        imwrite(image, fullDestinationFileName);

end
