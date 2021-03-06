function [ LabelMatrix_out ] = GetLabelMatrix_usingAC(BW_in, Image, n_iter, Smooth_factor, AC_mask_method)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

Do_closing = 0;
Disk_size = 3; % pixels

stats_objects = regionprops(BW_in,'BoundingBox', 'Centroid');

n_objects = length(stats_objects);
disp(['Number of objects before sorting: ', num2str(n_objects)]);
disp('Active contours...');

BW = zeros(size(Image));
h_wait = waitbar(0,'Please wait while active contours are calculated...','name','Wait bar');
tic

for i = 1:n_objects
    waitbar(i/n_objects);
    
    if strcmp(AC_mask_method, 'Otsu-thresholding')
        Mask = ismember(labelmatrix(bwconncomp(BW_in)), i);   % using the Otsu-segmentation as a starting mask
        %         Mask = imfill(Mask,'holes');   % is it sensible to do that?
        if Do_closing == 1
            se = strel('disk',Disk_size);
            Mask = imclose(Mask,se);
        end
        
    elseif strcmp(AC_mask_method, 'Bounding-box')
        Mask = zeros(size(Image));
        Mask(ceil(stats_objects(i).BoundingBox(2)):ceil(stats_objects(i).BoundingBox(2)+stats_objects(i).BoundingBox(4)),...
            ceil(stats_objects(i).BoundingBox(1)):ceil(stats_objects(i).BoundingBox(1)+stats_objects(i).BoundingBox(3))) = 1;
    end
    
    % Calculating the active contours
    if n_iter > 0
        Image_forAC = imadjust(Image/prctile(Image(:),99.99),[],[],0.7); % with these settings this does nothing
        bw_ac = activecontour(Image_forAC, Mask, n_iter, 'Chan-Vese','SmoothFactor',Smooth_factor);
    elseif n_iter == 0
        bw_ac = Mask;
    end
    %     LabelMatrix_out = LabelMatrix_out + i*double(bw_ac);    % this might be a problem when 2 masks overlap...
    BW = BW + bw_ac;
end
close(h_wait);
toc

% Convert to logical and label image
BW = logical(BW);
LabelMatrix_out = bwlabel(BW);


end

