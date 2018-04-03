% CSCI-431: Introduction to Computer Vision
% Project - Iceberg Classifier
%
% @author Stephen Allan <swa9846>
% @author Douglas Lee <dxl7697>


function result = IcebergClassifier(jsonFilepath)
    % ICEBERGCLASSIFIER TODO: Summary
    %   TODO: Description
    
    %% Parse Arguments
    if ~ischar(jsonFilepath)
        error('IcebergClassifier First parameter must be a character vector <''filepath''>');
    end
    
    fileID = fopen(jsonFilepath, 'r');
    rawData = fread(fileID, '*char');
    fclose(fileID);
    
    data = jsondecode(rawData);
    
    %% Visualize Data
    visualizeData(data(1));
    
    
    result = data;
end
