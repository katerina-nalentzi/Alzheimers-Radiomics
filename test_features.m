clc;clear;close all force

SecondOrder_params.quant_level = 3;
SecondOrder_params.i_d = 1;

wd = pwd;
cpath = 'path/to/folder';

cd(cpath)
filenames = ls;
filenames(1:2,:) = [];

for j = 1:size(filenames,1)
    fprintf('=== Load Now:  %s \n',filenames(j,:))
    cd(cpath)    
    
    load(filenames(j,:));
    cd(wd)
    
    % keep only segmented area from 3d-ROI    
    STATS = regionprops(BW,'BoundingBox');
    TT = round([STATS.BoundingBox(1) STATS.BoundingBox(2) STATS.BoundingBox(3) STATS.BoundingBox(4)]);

    Ref_BW=BW(TT(2):TT(2)+TT(4),TT(1):TT(1)+TT(3));
    k  = -1;
    for ii = 1:3        
        ROI_Seg(:,:,ii) = ROI(:,:,ii).*Ref_BW;
        k = k+1;
%         figure;imshow(ROI_Seg(:,:,ii),[]);
    end

%     Calculate 1st Order Descriptors   
    roi = ROI_Seg(:,:,2);    
    roi  = round(double(roi)/max(roi(:))*(2^quant_level-1)); %0-255    
    [feat1, FirstOrder_Labels] = f_FirstOrder_features(roi);
    First_Order_Feat(j,:) = feat1;


    %Calculate 2nd Order Descriptors in 2D    
    [feat2, SecondOrder_Labels] = f_SecondtOrder_features(roi, SecondOrder_params.quant_level, SecondOrder_params.i_d);
    Second_Order_Feat(j,:) = feat2;
    

    clear BW Seg Ig points SliceNumber BW TT ROI ROI_Seg feat1 featureVector featureVector2 harMat harMat2 feat2 
end

feat = [First_Order_Feat Second_Order_Feat]
Feat_Labels = [FirstOrder_Labels SecondOrder_Labels]

% save and feature names
cd(wd)
fsave = ['1st_2nd_Order_features_' date];
save(fsave,'feat','Feat_Labels','SecondOrder_params') 
