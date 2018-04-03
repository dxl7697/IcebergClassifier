% CSCI-431: Introduction to Computer Vision
% Project - Iceberg Classifier
%
% @author Stephen Allan <swa9846>
% @author Douglas Lee <dxl7697>


function bandImage = bandToImage(bandData)
    % BANDTOIMAGE TODO: Summary
    %   TODO: Description
    
    bandImage = zeros(75, 75);
    row = 1;
    col = 1;
    
    normalizedData = ((bandData - min(bandData))/(max(bandData) - min(bandData))) * 255;
    
    for i = 1:length(normalizedData)
        bandImage(row, col) = normalizedData(i);
        col = col + 1;
        
        if mod(i, 75) == 0
            row = row + 1;
            col = 1;
        end
    end
end
