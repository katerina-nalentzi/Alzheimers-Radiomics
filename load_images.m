clc;clear;close all force

Selected_Imaging_View = 1; % 1: sliceviewer 2: orthosliceViewer
Select_Plane = 2;% 1: Axial, 2:Coronal, 3:Sagittal

quant_level = 8;% 2^8
wd = pwd;
addpath(wd);

Demographics = xlsread('path\to\file.xlsx','C1:C374')
[~,Group] = xlsread('path\to\file.xlsx','D2:D374');

cpath = 'path\to\folder';
SavePath = 'path\to\folder';

cd(cpath)
foldnames = ls;
foldnames(1:2,:) = [];
Planes = [1 3 2;2 3 1;1 2 3];

for j = 143 :size(foldnames,1)
    if Demographics(j) == 1
        fprintf('=== Load Now:  %s :: <strong>%s</strong>  ===\n\t When you decide the slice press ENTER... \n\t\tWhen you finish PRESS RIGHT CLICK!!!\n',foldnames(j,:),Group{j})
        cd(cpath)
        cd([foldnames(j,:) '\RAW\'])
        filenames = ls;
        filenames(1:2,:) = [];
        im = zeros(256,256);
        Vtotal = zeros(256,256,128);
        for i = 1:size(filenames,1)/2
            rfilename = ['mpr-' num2str(i) '.nifti.img'];
            V{i} = niftiread(rfilename);            
            Vtotal = Vtotal + V{i};
        end
        Vtotal  = Vtotal/3;
               
        % --------------------------------------------------------------------------------
        % Change the viewplane [1 3 2]: axial , [2 3 1]:Coronal, [1 2 3]:Sagittal
        if ~iscell(Vtotal), Vtotal = {Vtotal}; numericvalues = true;
        else
            numericvalues = false;
        end
        pl = Planes(Select_Plane,:);
        Vtotal = cellfun(@(x) permute(x, [pl]), Vtotal,'UniformOutput',false);
        if numericvalues, Vtotal = Vtotal{1}; end
        % --------------------------------------------------------------------------------
        
        switch Selected_Imaging_View
            case 1
                sv = sliceViewer(flipud(Vtotal),'SliceDirection', [0  0 1]);%Axial:010, Coronal:001, Sagittal:100
                pause
                SliceNumber = sv.SliceNumber;
                
            case 2
                sv = orthosliceViewer(flipud(Vtotal));
                pause
                SliceNumber = sv.SliceNumbers(2);
        end      

        fprintf('\t Now Draw the ROI...\n')        
        figure(2);imshow(flipud(Vtotal(:,:,SliceNumber)),[])
        points = drawpolygon;

        Ig = flipud(Vtotal(:,:, SliceNumber));
        
        BW = createMask(points);
        figure;imshow(BW,[]);
        Seg = Ig.*BW;
        figure;imshow(Seg,[]);        
        
        % save a ROI beafore and after the slice
        STATS = regionprops(BW,'BoundingBox');
        TT = round([STATS.BoundingBox(1) STATS.BoundingBox(2) STATS.BoundingBox(3) STATS.BoundingBox(4)]);
                
        k  = -1;
        for ii = 1:3            
            im = flipud(Vtotal(:,:, SliceNumber+k));
            ROI(:,:,ii) = im(TT(2):TT(2)+TT(4),TT(1):TT(1)+TT(3));
            k = k+1;
        end
        
        savefname = [SavePath '\' foldnames(j,:) '.mat'];
        save(savefname, 'BW', 'Seg', 'Ig', 'points','SliceNumber','ROI');
        fprintf('*** Roi saved as Load Now:  %s ***\n\n',savefname)

        clear BW Seg Ig points SliceNumber BW TT ROI
        close all force
       
    else
        
    end

end

