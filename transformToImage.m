FILENAME = 'train.json';
%1 CHANNEL = 1 (HH)
%2 CHANNEL = 2 (HH HV)
%3 CHANNEL = 3 (HH HV HH)
%2 CHANNEL ROTATE = 4 (HH HV)
    %orig image with 2 rand rotations of that orig image
channel= 4;

fid = fopen(FILENAME);
raw = fread(fid,inf);
str = char(raw');
fclose(fid);
val = jsondecode(str);

if(channel==1)
    for n = 1:length(val)
        image1 = bandToImage(val(n).band_1);
        writeAsImage(val(n).id, (image1), val(n).is_iceberg,1);
    end

    fprintf('1 channel -- separated images from iceberg and ships\n');
    
elseif(channel == 2)
    for n = 1:length(val)
        image1 = bandToImage(val(n).band_1);
        image2 = bandToImage(val(n).band_2);
        fuse = imfuse(image1,image2);
        fuse(:,:,3) = 0;
        writeAsImage(val(n).id, (fuse), val(n).is_iceberg,2);
    end
    fprintf('2 channel -- separated images from iceberg and ships\n');

elseif(channel == 3)
    for n = 1:length(val)
        image1 = bandToImage(val(n).band_1);
        image2 = bandToImage(val(n).band_2);
        fuse = imfuse(image1,image2);
        writeAsImage(val(n).id, (fuse), val(n).is_iceberg,3);
    end

    fprintf('3 channel -- separated images from iceberg and ships\n');
    
elseif(channel == 4)
    for n = 1:length(val)
        image1 = bandToImage(val(n).band_1);
        image2 = bandToImage(val(n).band_2);

        %orig image
        fuse = imfuse(image1,image2);
        fuse(:,:,3) = 0;
        writeAsImage(val(n).id, (fuse), val(n).is_iceberg,4);
        
        %first rand rotate
        fuse = imrotate(fuse,(181-randi(361)),'bilinear','crop');
        writeAsImage(strcat(val(n).id,'r1'), (fuse), val(n).is_iceberg,4);
        
        %second rand rotate
        fuse = imrotate(fuse,(181-randi(361)),'bilinear','crop');
        writeAsImage(strcat(val(n).id,'r2'), (fuse), val(n).is_iceberg,4);
    end
    fprintf('2 channel ROTATED-- separated images from iceberg and ships\n');

end

    
