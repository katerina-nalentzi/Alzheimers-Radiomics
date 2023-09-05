function [feat, feat_labels] = f_FirstOrder_features(im)

roi = double(im);
indx_pos = roi(:)>0;
roi_vector = double(roi(indx_pos));
k = 1;
f(k) = mean(roi_vector);        k = k+1; %1 Mean Intensity
f(k) = std(roi_vector);         k = k+1; %2 Intensity Standard Deviation
f(k) = skewness(roi_vector);    k = k+1; %3 Intensity Skewness
f(k) = kurtosis(roi_vector);    k = k+1; %4 Intensity Kurtosis
f(k) = median(roi_vector);      k = k+1; %5 Median intensity
f(k) = min(roi_vector);         k = k+1; %6 Minimum intensity
f(k) = prctile(roi_vector,10);  k = k+1; %7 10th intensity percentile
f(k) = prctile(roi_vector,90);  k = k+1; %8 90th intensity percentile
f(k) = max(roi_vector);         k = k+1; %9 Maximum intensity
f(k) = iqr(roi_vector);         k = k+1; %10 Intensity interquartile range
f(k) = f(9) - f(6);             k = k+1; %11 Intensity Range
f(k) = mad(roi_vector,0);       k = k+1; %12 Intensity-based mean absolute deviation
f(k) = mad(roi_vector,1);       k = k+1; %13 Intensity-based median absolute deviation
f(k) = f(2)/f(1);               k = k+1; %14 Intensity-based coefficient of variation
p75 = prctile(roi_vector,75);
p25 = prctile(roi_vector,25);
f(k) = (p75 - p25)/(p75 + p25); k = k+1; %15 Intensity-based quartile coefficient of dispersion
f(k) = sum(roi_vector.^2);      k = k+1; %16 Intensity-based energy
roi(roi<0)=0;
f(k) = entropy(roi);                     %17 Intensity-based Entropy


feat = f;
feat_labels = {'Mean','Std','Skewness','Kurtosis','Median','Minimum','P10th','P90th','Maximum','IQR','Range','MeanAbsoluteDeviation','MedianAbsoluteDeviation','CV','QCD','Energy','Entropy'};
