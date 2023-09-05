function [feat, feat_labels] = f_SecondtOrder_features(roi, quant_level, i_d)
% % roi:  Region Of Interest for feat extraction
% % feat: i.e [1:8] for all features
% % quant_level:  3: 2^3 = 8  roi grayscale depth

C  = round(double(roi)/max(roi(:))*(2^quant_level-1)); %0-7   
roi = double(C);
roi1 = roi;
Num_Tones = 2^(quant_level);

% Calculate 2nd order statistical features from co-occurence matrix P = graycomatrix(roi, 'GrayLimits',[m,M],'NumLevels',N,'Offset',d);
P0  = graycomatrix(roi,'GrayLimits',[],'NumLevels',Num_Tones,'Offset',[0 1]) + graycomatrix(flipdim(roi,2),'GrayLimits',[],'NumLevels',Num_Tones,'Offset',[0 1]);
P45 = graycomatrix(roi,'GrayLimits',[],'NumLevels',Num_Tones,'Offset',[-1 1]) + graycomatrix(rot90(roi,2),'GrayLimits',[],'NumLevels',Num_Tones,'Offset',[-1 1]);
P90 = graycomatrix(roi,'GrayLimits',[],'NumLevels',Num_Tones,'Offset',[-1 0]) + graycomatrix(flipdim(roi,1),'GrayLimits',[],'NumLevels',Num_Tones,'Offset',[-1 0]);
P135= graycomatrix(roi,'GrayLimits',[],'NumLevels',Num_Tones,'Offset',[-1 -1]) + graycomatrix(rot90(roi,2),'GrayLimits',[],'NumLevels',Num_Tones,'Offset',[-1 -1]);

f0 = graycoprops(P0); f90 = graycoprops(P90); f45 = graycoprops(P45); f135 = graycoprops(P135);
k = 1;
CON = [f0.Contrast f90.Contrast f45.Contrast f135.Contrast];
COR = [f0.Correlation f90.Correlation f45.Correlation f135.Correlation];
ENR = [f0.Energy f90.Energy f45.Energy f135.Energy];
HMG = [f0.Homogeneity f90.Homogeneity f45.Homogeneity f135.Homogeneity];

f(k) = mean(CON);   k = k+1;
f(k) = range(CON);  k = k+1;
f(k) = mean(COR);   k = k+1;
f(k) = range(COR);  k = k+1;
f(k) = mean(ENR);   k = k+1;
f(k) = range(ENR);   k = k+1;
f(k) = mean(HMG);   k = k+1;
f(k) = range(HMG);   

feat = f;
feat_labels = {'Contrast_m','Contrast_r','Correlation_m','Correlation_r','Energy_m','Energy_r','Homogeneity_m','Homogeneity_r'};

