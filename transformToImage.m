FILENAME = 'train.json';

fid = fopen(FILENAME);
raw = fread(fid,inf);
str = char(raw');
fclose(fid);
val = jsondecode(str);

for n = 1:length(val)
    image = bandToImage(val(n).band_1);
    writeAsImage(val(n).id, (image), val(n).is_iceberg);
end

fprintf('finished separating images from iceberg and ships\n');