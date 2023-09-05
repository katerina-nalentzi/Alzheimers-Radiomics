clc;clear all;

pvalue = 0.01;pvalue_cor = 0.05;%0.01 0.005 0.001


Folder2keep = xlsread('path\to\file.xlsx','C1:C374');
% [~,Group] = xlsread('path\to\file.xlsx','D2:D374');
Class_Labels = xlsread('path\to\file.xlsx','E1:E374');

% load FirstOrder_features
load 1st_2nd_Order_features
ClassLabels = Class_Labels(logical(Folder2keep));

[index1,qq] = find(ClassLabels == 1);
[index2,qq] = find(ClassLabels == 2);
[index3,qq] = find(ClassLabels == 3);

Class{1} = feat(index1,:);
Class{2} = feat(index2,:);
FL = Feat_Labels;

Super = [Class{1};Class{2}];

i_1 = 0; i_2 = 0;
for j = 1:size(Super,2)
    [hl(j),pl(j)] = lillietest(Super(:,j),'Alpha',pvalue);

    if hl(j)<1
        i_1 = i_1+1; 
        [pW(i_1),hW(i_1)] = ranksum(Class{1}(:,i_1),Class{2}(:,i_1),'Alpha',pvalue);
        Indexes(j,:) = [j 1 pW(i_1)];
    else
        i_2 = i_2+1; 
        [ht(i_2),pt(i_2)] = ttest2(Class{1}(:,i_2),Class{2}(:,i_2),'Alpha',pvalue);
        Indexes(j,:) = [j 2 pt(i_2)];
    end
end


qSt = find(Indexes(:,2)==2 & Indexes(:,3)<pvalue);
fprintf('# of features from Student''s t-test: %d\n', length(qSt)); 
qWx = find(Indexes(:,2)==1 & Indexes(:,3)<pvalue);
fprintf('# of features from Wilcoxon test: %d\n', length(qWx)); 

feat = find(Indexes(:,3)<pvalue);
fprintf('\nFeatures with SSD p<%.3f\n',pvalue);
for j = 1:length(feat)
    fprintf('%d :%s\n',j,FL{feat(j)});
end
