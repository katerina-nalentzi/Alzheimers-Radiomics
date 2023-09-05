# Manual segmentation, Radiomic features extraction and statistical analysis in MATLAB

This README provides an overview of a MATLAB program that performs various image processing and statistical tasks for a basic radiomics analysis. Here's a high-level explanation of the key functionalities:

## Image Segmentation and Feature Extraction

The program begins with sequential image loading into 3D presentation to choose the preferred plane and slice, in order to perform manual segmentation and creation of a bounding box for the segmented images and then feature extraction:

1. Image Segmentation: It extracts regions of interest (ROIs) from input images using binary masks. These masks are created based on specified coordinates (TT) and are applied to three image channels.

2. 1st Order radiomic features: After segmentation, the code calculates first-order radiomic features. It processes the segmented ROI, scales the pixel values to a range between 0 and 255, and then computes a set of first-order features.

3. 2nd Order radiomic features in 2D: This step involves additional calculations based on specified parameters (quant_level and i_d).

## Statistical Analysis

Following image processing, the code performs statistical analysis on the computed features:

1. Data Preparation: The program loads data from an external source (an Excel file) that includes folder information, class labels, and feature data.

2. Class Separation: It separates data into different classes based on the provided class labels.

3. Statistical Testing: The code conducts statistical tests, including the Wilcoxon rank-sum test and Student's t-test, to determine the significance of feature differences between classes. Features with statistically significant differences are identified.

4. Reporting Results: The program reports the number of features with significant differences and lists the names of these features.
